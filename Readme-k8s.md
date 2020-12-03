source .env
source .hlc.env
source .c.env
source .k8s.env
mkdir channel-artifacts
echo
echo -e $COLOR "Kindly make note before starting K8s deployments "$NONE
echo -e $BLCOLOR" Ensure you started minikube services, if not start by 'minikube start driver=none'"$NONE
echo -e $YCOLOR" As prerequestie for K8s, Mount current working dir to k8s cluster volumes manually,  
 ex: minikube mount /home/ravi/fabric-samples/HLFAuto:/home/ravi/fabric-samples/HLFAuto &  
 Note: change your working directory PATH from above syntax"$NONE
echo " For fabric version 1.4.x, you need to update priv.key manually when there is a change"
echo ""
#echo "Currently marbles CC is available for test, and im working on fabcar"
echo -e $PCOLOR "As prerequestie for K8s, Mount current working dir to k8s cluster" $NONE
echo  " Execute with below commands in sequence"
echo -e $GRCOLOR "ex :  \n k8sCleanCreateCrypto \n k8sreplKeys \n k8sDeployPOD  \n k8sjoinCHL \n k8sbuildCC \n k8sCCinstall \n k8sCCstart " $NONE


function k8shomedir () {
    source .k8s.env
    if [ -z $HMEDIR ] ; then
    pwd
    read -p "Provide your working dir PATH. It should be FULLPATH, Starts from "/" : " HMEDIR
    export $HMEDIR
    echo "HMEDIR=$HMEDIR" >> .k8s.env
    cd k8s
    for file in */* chaincode/*/*  ;
    do 
    echo "$file"
    sed -i -e "s,{HOME_DIR_PATH},$HMEDIR,g" $file
    done
    cd ../
    fi
}


function k8sCleanCreateCrypto () {
    cd $HL_CFG_PATH
    rm -rf crypto-config
    ./scripts/1a_firsttimeonly.sh
}




function k8sreplKeys () {

    source $HL_CFG_PATH/.hlc.env
    source $HL_CFG_PATH/.k8s.env
    
    
    ORG1KEY="$(ls crypto-config/peerOrganizations/$ORG_1/ca/ | grep 'sk$')"
    sed -i -e "s/{ORG1-CA-KEY}/$ORG1KEY/g" ./k8s/org1/org1-ca-deployment.yaml 


    ORG2KEY="$(ls crypto-config/peerOrganizations/$ORG_2/ca/ | grep 'sk$')"
    sed -i -e "s/{ORG2-CA-KEY}/$ORG2KEY/g" ./k8s/org2/org2-ca-deployment.yaml 


}

function k8sDeployPOD() {  
    source $HL_CFG_PATH/.hlc.env
    source $HL_CFG_PATH/.k8s.env
    cd $HL_CFG_PATH
    kubectl create ns $K8S_NS || true
    sleep 1
    kubectl create -f k8s/orderer-service/ || true 
    sleep 3
    kubectl create -f k8s/org1/ || true
    sleep 3
    kubectl create -f k8s/org2/ || true 
    sleep 10
    kubectl get pods -n $K8S_NS

}

function k8sjoinCHL() {
    echo "Joining org1"
    export CLI_ORG1="$(kubectl get pods -n $K8S_NS | grep cli-$ORG_1 | awk '{print $1}')"
    echo "CLI_ORG1=$CLI_ORG1" >> .k8s.env
    kubectl exec -it -n $K8S_NS $CLI_ORG1 -- bash -c "k8scripts/01_org1join.sh"

    echo "Joining org2"
    export CLI_ORG2="$(kubectl get pods -n $K8S_NS | grep cli-$ORG_2 | awk '{print $1}')"
    echo "CLI_ORG2=$CLI_ORG2" >> .k8s.env
    kubectl exec -it -n $K8S_NS $CLI_ORG2 -- bash -c "k8scripts/02_org2join.sh"
}

function k8sbuildCC {

    cd $HL_CFG_PATH/k8s/chaincode/packaging
    #k8sSEDrepl
    cp org1.connection.json connection.json
    rm -f code.tar.gz
    tar cfz code.tar.gz connection.json
    tar cfz marbles-org1.tgz code.tar.gz metadata.json

    cp org2.connection.json connection.json
    rm -f code.tar.gz
    tar cfz code.tar.gz connection.json
    tar cfz marbles-org2.tgz code.tar.gz metadata.json


    cd $HL_CFG_PATH/k8s/chaincode
    docker build -t chaincode/marbles:1.0 .

    minikube cache list | grep "chaincode/marbles:1.0"
    if [ $? -eq 0 ] ; then
        minikube cache reload
    else
        minikube cache add chaincode/marbles:1.0
    fi
    cd $HL_CFG_PATH
}

function k8sCCinstall () {

    #Do Install the Chaincode in Peer containers
    kubectl exec -it -n $K8S_NS $CLI_ORG1 -- bash -c "k8scripts/01a_org1ccinstall.sh"
    export CHAINCODE_CCID_ORG_1=$(cat $HL_CFG_PATH/k8s/k8scripts/.packageid.env)
    echo " Org1 CCID :   $CHAINCODE_CCID_ORG_1 "
    cd $HL_CFG_PATH
    sed -i -e "s/{CHAINCODE_CCID_ORG_1}/$CHAINCODE_CCID_ORG_1/g" ./k8s/chaincode/k8s/org1-chaincode-deployment.yaml

    echo "switching to Org2..."
    sleep 10

    kubectl exec -it -n $K8S_NS $CLI_ORG2 -- bash -c "k8scripts/02a_org2ccinstall.sh"
    export CHAINCODE_CCID_ORG_2=$(cat $HL_CFG_PATH/k8s/k8scripts/.packageid.env)
    echo " Org2 CCID :   $CHAINCODE_CCID_ORG_2 "
    sed -i -e "s/{CHAINCODE_CCID_ORG_2}/$CHAINCODE_CCID_ORG_2/g" ./k8s/chaincode/k8s/org2-chaincode-deployment.yaml


}

function k8sCCstart() {
    echo " By this time you installed the CC on both peer orgs, before executing buildCC, "
    echo "starting CC containers... take time to boot"
    kubectl create -f k8s/chaincode/k8s || true
    sleep 20
    kubectl get pods -n $K8S_NS
    sleep 15
    kubectl exec -it -n $K8S_NS $CLI_ORG1 -- bash -c "k8scripts/04_invoke.sh"
    kubectl exec -it -n $K8S_NS $CLI_ORG2 -- bash -c "k8scripts/05_query.sh"
    kubectl get pods -n $K8S_NS

}

function k8sstop() {
    cd $HL_CFG_PATH
    
    kubectl delete -f k8s/chaincode/k8s/ || true
    kubectl delete -f k8s/org2/ || true 
    kubectl delete -f k8s/org1/ || true
    kubectl delete -f k8s/orderer-service/ || true
    kubectl delete -f k8s/explorer/ || true
    sleep 1
    kubectl delete ns $K8S_NS || true
    kubectl get pods -n $K8S_NS 
    #rm -rf  /home/ravi/storage/*
    ls -R /home/ravi/storage/

}

function k8sexplr() {

    cp -r crypto-config/*  explorer/examples/net1/crypto/
    kubectl create -f k8s/k8sexplorer/
    sleep 10 && kubectl get pods -n $K8S_NS
}

echo -e $YCOLOR"You can ctrl^C now if you already generated and updated homedir path."$NONE
k8shomedir