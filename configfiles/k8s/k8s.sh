#!/bin/bash

source .env
source ./.hlc.env
echo > ./.k8s.env

source ./.k8s.env



function k8sORDcheck  () {
    if [ $ORDCOUNT -lt 2 ] ; then
            for ((i=1; i<= 2; i++))   
            do
                echo "Since Orderer hosts < 3, Collecting requirements..."
                read -p "Give your Orderer name(default: Orderer$i) : " ORD_NAME
                if [ -z $ORD_NAME ];
                then 
                    echo  "Taking default : orderer$i"
                    echo "ORD_NAME$i=orderer$i" >> .hlc.env
                    export ORD_NAME$i="orderer$i"
                    ORD=orderer$i
                    echo "ORD_NAME${i}_C=${ORD^}" >> .hlc.env
                    export ORD_NAME${i}_C="${ORD^}" 
                else 
                    echo "Given Name :  $ORD_NAME"
                    echo "ORD_NAME$i=$ORD_NAME" >> .hlc.env
                    export ORD_NAME$i=$ORD_NAME
                    echo "ORD_NAME${i}_C="${ORD_NAME^}" " >> .hlc.env

                fi;
            done
    fi
}

function k8sCAcheck  () {
    if [ $CACOUNT -lt 2 ] ; then
        for ((i=2; i<= 2; i++))   
            do
                echo " Since CA's < 3, Collecting requirements..."
                read -p "Give your CA name(default: ca$i) : " CA_ORG
                if [ -z $CA_ORG ];
                then 
                    echo  "Taking default : ca$i"
                    echo "CA_ORG$i=ca$i" >> .hlc.env
                    export CA_ORG$i="ca$i"
                else 
                    echo "Given Name :  $CA_ORG"
                    echo "CA_ORG$i=$CA_ORG" >> .hlc.env
                    export CA_ORG$i=$CA_ORG

                fi;
        done
    fi
}

function k8sNS() {

                read -p "Give your namespace for K8s Cluster (default: hlfk8s) : " K8S_NS
                if [ -z $K8S_NS ]; then
                    echo  "Taking default : hlfk8s"
                    echo "K8S_NS=hlfk8s" >> .k8s.env
                    export K8S_NS=hlfk8s
                else 
                    echo "Given Name :  ${K8S_NS,,}"
                    echo "K8S_NS=${K8S_NS,,}" >> .k8s.env
                    export K8S_NS=${K8S_NS,,}

                fi;
}



function verifyDir() {
    cd $HL_CFG_PATH
    if [ ! -d ./k8s ]; then
        mkdir -p ./k8s/orderer-service
        mkdir -p ./k8s/org1
        mkdir -p ./k8s/org2
        mkdir -p ./k8s/buildpack
        mkdir -p ./k8s/chaincode
        mkdir -p ./k8s/k8sexplorer

    fi
}

function k8sCPfiles() {
    echo "changing to source dir.."
    cd $HL_CFG_PATH/configfiles/k8s 
    sleep 2

    cp orderer-service/orderer0-deployment-src.yaml ../../k8s/orderer-service/orderer0-deployment.yaml
    cp orderer-service/orderer0-svc-src.yaml ../../k8s/orderer-service/orderer0-svc.yaml
    cp orderer-service/orderer1-deployment-src.yaml ../../k8s/orderer-service/orderer1-deployment.yaml
    cp orderer-service/orderer1-svc-src.yaml ../../k8s/orderer-service/orderer1-svc.yaml
    cp orderer-service/orderer2-deployment-src.yaml ../../k8s/orderer-service/orderer2-deployment.yaml
    cp orderer-service/orderer2-svc-src.yaml ../../k8s/orderer-service/orderer2-svc.yaml


    cp org1/builders-config-src.yaml ../../k8s/org1/builders-config.yaml
    cp org1/org1-ca-deployment-src.yaml ../../k8s/org1/org1-ca-deployment.yaml
    cp org1/org1-ca-svc-src.yaml ../../k8s/org1/org1-ca-svc.yaml
    cp org1/org1-cli-deployment-src.yaml ../../k8s/org1/org1-cli-deployment.yaml
    cp org1/org1-peer0-deployment-src.yaml ../../k8s/org1/org1-peer0-deployment.yaml
    cp org1/org1-peer0-svc-src.yaml ../../k8s/org1/org1-peer0-svc.yaml
    

    cp org2/org2-ca-deployment-src.yaml ../../k8s/org2/org2-ca-deployment.yaml
    cp org2/org2-ca-svc-src.yaml ../../k8s/org2/org2-ca-svc.yaml
    cp org2/org2-cli-deployment-src.yaml ../../k8s/org2/org2-cli-deployment.yaml
    cp org2/org2-peer0-deployment-src.yaml ../../k8s/org2/org2-peer0-deployment.yaml
    cp org2/org2-peer0-svc-src.yaml ../../k8s/org2/org2-peer0-svc.yaml
    if [ $HLENV != WEB ];then
    rsync -a k8scripts ../../k8s/
    rsync -a buildpack ../../k8s/
    rsync -a chaincode ../../k8s/
    rsync -a explorer ../../k8s/k8sexplorer
    else 
    cp -r k8scripts ../../k8s/
    cp -r buildpack ../../k8s/
    cp -r chaincode ../../k8s/
    cp -r explorer ../../k8s/k8sexplorer
    fi

}


function k8sSEDrepl () {
    source $HL_CFG_PATH/.hlc.env
    source $HL_CFG_PATH/.k8s.env
    for file in *.yaml *.json *.sh;
        do   
        if [[ ! -f "$file" ]];   then    
         continue     
        fi
        echo "$file"   
        sed -i -e "s/{DOMAIN_NAME}/$DOMAIN_NAME/g" $file  
        sed -i -e "s/{K8S_NS}/$K8S_NS/g" $file
        sed -i -e "s/{ORG_1}/$ORG_1/g" $file
        sed -i -e "s/{ORG_1_C}/$ORG_1_C/g" $file
        sed -i -e "s/{CA_ORG1}/$CA_ORG1/g" $file
        sed -i -e "s/{ORD_NAME0}/$ORD_NAME0/g" $file
        sed -i -e "s/{ORD_NAME0_C}/$ORD_NAME0_C/g" $file
        sed -i -e "s/{IMAGE_TAG}/$IMAGE_TAG/g" $file
        sed -i -e "s/{ORD_NAME0}/$ORD_NAME0/g" $file
        sed -i -e "s/{CAIMAGE_TAG}/$CAIMAGE_TAG/g" $file
        sed -i -e "s/{PEER_NAME0}/$PEER_NAME0/g" $file
        sed -i -e "s/{PEER_NAME1}/$PEER_NAME1/g" $file
        sed -i -e "s/{CAIMAGE_TAG}/$CAIMAGE_TAG/g" $file
        sed -i -e "s/{ORG_2}/$ORG_2/g" $file
        sed -i -e "s/{ORG_2_C}/$ORG_2_C/g" $file
        sed -i -e "s/{CA_ORG2}/$CA_ORG2/g" $file
        sed -i -e "s/{ORD_NAME1}/$ORD_NAME1/g" $file
        sed -i -e "s/{ORD_NAME2}/$ORD_NAME2/g" $file
        sed -i -e "s/{CHANNEL_NAME1}/$CHANNEL_NAME1/g" $file
        
    done
}

function k8sCONFTXCRYPTO () {
    cd $HL_CFG_PATH
    cp configfiles/k8s/k8configtx_v20.org.yaml k8s/configtx.yaml
    cp configfiles/k8s/k8crypto-config.orgsrc.yaml k8s/crypto-config.yaml
    sed -i -e "s/{ORDTYP}/etcdraft/g" k8s/configtx.yaml
    sed -i -e "s/{CHLCAP1}/$CHLCAP1/g" k8s/configtx.yaml
    sed -i -e "s/{ORDCAP1}/$ORDCAP1/g" k8s/configtx.yaml
    sed -i -e "s/{APPCAP1}/$APPCAP1/g" k8s/configtx.yaml
    cd $HL_CFG_PATH/k8s
    k8sSEDrepl
    cp configtx.yaml $HL_CFG_PATH/
    cp crypto-config.yaml $HL_CFG_PATH/

}



function k8sSEDreplexe () {
    cd $HL_CFG_PATH/k8s/org1
    k8sSEDrepl
    cd $HL_CFG_PATH/k8s/org2
    k8sSEDrepl
    cd $HL_CFG_PATH/k8s/orderer-service
    k8sSEDrepl
    cd $HL_CFG_PATH/k8s/chaincode/k8s/
    k8sSEDrepl
    cd $HL_CFG_PATH/k8s/chaincode/packaging/
    k8sSEDrepl
    cd $HL_CFG_PATH/k8s/k8scripts/
    k8sSEDrepl

}

function CleanCreateCrypto () {
    cd $HL_CFG_PATH
    rm -rf crypto-config
    ./scripts/1a_firsttimeonly.sh
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
    echo "starting CC containers..take time to boot"
    kubectl create -f k8s/chaincode/k8s || true
    sleep 20
    kubectl get pods -n $K8S_NS
    sleep 15
    kubectl exec -it -n $K8S_NS $CLI_ORG1 -- bash -c "k8scripts/04_invoke.sh"
    echo " Switching to org2"
    kubectl exec -it -n $K8S_NS $CLI_ORG2 -- bash -c "k8scripts/05_query.sh"
    kubectl get pods -n $K8S_NS
    echo -e $GCOLOR"You have done, Great job."$NONE

}


function k8sexplorer() {
    cp configfiles/k8s/explorer/first-network-org.json  $HL_CFG_PATH/k8s/k8sexplorer/
    cp configfiles/k8s/explorer/explorer-deployment-src.yaml  $HL_CFG_PATH/k8s/k8sexplorer/explorer-deployment.yaml
    cp configfiles/k8s/explorer/explorer-svc-src.yaml  $HL_CFG_PATH/k8s/k8sexplorer/explorer-svc.yaml
    cp configfiles/k8s/explorer/explorerdb-deployment-src.yaml  $HL_CFG_PATH/k8s/k8sexplorer/explorerdb-deployment.yaml
    cp configfiles/k8s/explorer/explorerdb-svc-src.yaml  $HL_CFG_PATH/k8s/k8sexplorer/explorerdb-svc.yaml

    cd $HL_CFG_PATH/k8s/k8sexplorer
    k8sSEDrepl
    mkdir -p $HL_CFG_PATH/explorer/examples/net1/connection-profile
    cp first-network-org.json  $HL_CFG_PATH/explorer/examples/net1/connection-profile/.
    mv first-network-org.json  $HL_CFG_PATH/k8s/
    cd $HL_CFG_PATH
    if [ $HLENV != WEB ];then
    cp -r crypto-config/*  explorer/examples/net1/crypto/
    kubectl create -f k8s/explorer/
    sleep 10 && kubectl get pods -n $K8S_NS
    else echo ""
    fi
}


# Note the the chaincode/buildpack directory should be copied to the destination


function k8sstop() {
    cd $HL_CFG_PATH
    
    kubectl delete -f k8s/chaincode/k8s/ || true
    kubectl delete -f k8s/org2/ || true 
    kubectl delete -f k8s/org1/ || true
    kubectl delete -f k8s/orderer-service/ || true
    kubectl delete -f k8s/explorer/ || true
    sleep 1
    #kubectl delete ns $K8S_NS || true
    kubectl get pods -n $K8S_NS 
    #rm -rf  /home/ravi/storage/*
    ls -R /home/ravi/storage/

}

function k8Status () {
    minikube status
    echo " "
    kubectl get all -n $K8S_NS 
}


function k8shomedir () {
    echo -e $BCOLOR"If you not aware, you can skip for now"$NONE
    read -p "Provide your working dir PATH. It should be FULLPATH :" hmedir
    

    for file in k8s/*; 
    do 
    echo "$file"
    sed -i -e "s/{HOME_DIR_PATH}/$hmedir/g" $file
    done

}