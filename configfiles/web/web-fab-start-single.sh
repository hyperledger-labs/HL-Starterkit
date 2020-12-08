source .env
source .hlc.env
source .c.env


echo "Ensure at this time you downloaded fabric-samples, binaries and Fabric-images, 
      If not please download the prereq script and  run "FbinImage" from your home folder."
echo " Note : If fabric version 1.4.3 and couchDB version is 0.4.15, then please run this command : DBimagechg"
echo  " Execute with below commands in sequence"
echo -e $GRCOLOR "ex :  \n DBimagechg(optional) \n shfstartfabnet \n shfCHLcreate \n shfPeerConnect  \n shfexplorer \n shfstop" $NONE


function checkDIRpath () {
    P=$PWD
    if [[ $P =~ "fabric-samples" ]] ; then 
    echo "Found fabric-samples folder from your current path \n
    Checking prereq status "
    source 01_prereqs.sh
    precheck
    echo "If any of prereq's are NULL value"
    echo "Please run prereq scripts in following order or you can do manuall install for missing component."
    echo -e $GRCOLOR "ex : source 01_prereqs.sh \n prereq14 \n precheck \n   " $NONE
    else 
    echo "Fabric-samples folder not found"
    echo " Please run prereq scripts in following order"
    echo -e $GRCOLOR "ex :  source 01_prereqs.sh \n prereq14 \n FbinImage \n precheck \n" $NONE
    
    fi; 
}
checkDIRpath


cd $HL_CFG_PATH/
cp -r ../asset-transfer* ../chaincode/    ## Copying sample to chaincode folder
export `cat .hlc.env | grep IMAGE_TAG`


function shfreplKeys () {

    echo "running keys replacements"
    
    ORG1KEY="$(ls crypto-config/peerOrganizations/$ORG_1.$DOMAIN_NAME/ca/ | grep 'sk$')"
    sed -i -e "s/{ORG1-CA-KEY}/$ORG1KEY/g" ./base/ca-base.yaml

    ORG1TLSKEY="$(ls crypto-config/peerOrganizations/$ORG_1.$DOMAIN_NAME/tlsca/ | grep 'sk$')"
    sed -i -e "s/{ORG1-TLSCA-KEY}/$ORG1TLSKEY/g" ./base/ca-base.yaml

    ORG2KEY="$(ls crypto-config/peerOrganizations/$ORG_2.$DOMAIN_NAME/ca/ | grep 'sk$')"
    sed -i -e "s/{ORG2-CA-KEY}/$ORG2KEY/g" ./base/ca-base.yaml
    
    ORG2TLSKEY="$(ls crypto-config/peerOrganizations/$ORG_2.$DOMAIN_NAME/tlsca/ | grep 'sk$')"
    sed -i -e "s/{ORG2-TLSCA-KEY}/$ORG2TLSKEY/g" ./base/ca-base.yaml

}

function shfstartfabnet () {
    
    if [ "$ORD_TYPE" == "SOLO"  ]; then
      echo "running ./scripts/1a_firsttimeonly.sh"
      rm -rf crypto-config
      mkdir -p channel-artifacts
      ./scripts/1a_firsttimeonly.sh
      shfreplKeys
      echo -e $GRCOLOR" `figlet Starting Fabric`"$NONE
      echo -e $GRCOLO" Starting with SOLO Orderer "$NONE
      docker-compose -f docker-compose-cli.yaml up -d
      sleep 15 
    elif [ "$ORD_TYPE" == "RAFT" ]; then
      echo "running ./scripts/1a_firsttimeonly.sh"
      rm -rf crypto-config
      mkdir -p channel-artifacts
      ./scripts/1a_firsttimeonly.sh
      shfreplKeys
      echo -e $GRCOLOR" `figlet Starting Fabric`"$NONE
      echo -e $GRCOLO" Starting with RAFT Orderer "$NONE
      docker-compose -f docker-compose-cli.yaml -f docker-compose-orderer-etcraft.yaml up -d
      sleep 15 
    else echo ""
    fi
    sleep 5 
    docker ps -a

}

function shfstop () {
  docker-compose -f docker-compose-cli.yaml -f docker-compose-orderer-etcraft.yaml down -v 
  docker-compose -f explorer/docker-compose-explorer.yml down -v
  docker stop $(docker ps -qa)
  docker image rm $(docker image ls | grep -E 'mycc|dev' | awk '{print $3}')
  docker volume prune -f
  docker network prune -f
  docker ps -a
  docker image ls  | grep -E 'mycc|dev'
}

function shfCHLcreate () {
  
  export CLI_NAME="$(docker ps --format='{{.Names}}' | grep cli)"
  echo "CLI_NAME=$CLI_NAME" >> .hlc.env
  ./scripts/2_channelcrte.sh

}



function shfPeerConnect () {
    
    sleep 1
    docker exec $CLI_NAME bash ./scripts/2a_peer0.org1_chljoin.sh
    sleep 3
    
    docker exec $CLI_NAME bash ./scripts/3_peer1.org1_chljoin.sh
    sleep 2

    docker exec $CLI_NAME bash ./scripts/4_peer0.org2_chljoin.sh
    sleep 1
  
    docker exec $CLI_NAME bash ./scripts/5_peer1.org2_chljoin.sh
    sleep 1

    docker exec $CLI_NAME bash ./scripts/6_anchorpeerorg1.sh
    sleep 2

    docker exec $CLI_NAME bash ./scripts/7_anchorpeerorg2.sh
    sleep 2

    docker exec $CLI_NAME bash ./scripts/8_ccinstallpeer0.org1.sh
    sleep 2

    docker exec $CLI_NAME bash ./scripts/9_ccinstallpeer0.org2.sh
    sleep 2
    
    if [[ $IMAGE_TAG != @(2.0.0|2.1.0|2.2.0) ]];
    then 
        docker tag hyperledger/fabric-ccenv:1.4.3 hyperledger/fabric-ccenv:latest   #Bug Fix

        docker exec $CLI_NAME bash ./scripts/10_ccinstantiate.org2.sh
        sleep 2

        docker exec $CLI_NAME bash ./scripts/11_ccquery.org1.sh
        sleep 1

        docker exec $CLI_NAME bash ./scripts/12_ccinvoketransfer.sh
        sleep 3

        docker exec $CLI_NAME bash ./scripts/13_ccquery.org2.sh
    else 
        echo "...skiping to fab 2.0"
        docker tag hyperledger/fabric-ccenv:2.2 hyperledger/fabric-ccenv:latest    ## Bug fix in 2.2
        sleep 2
        docker exec $CLI_NAME bash ./scripts/9a_lcccapprovefab2.0.sh
        sleep 2
        docker exec $CLI_NAME bash ./scripts/10a_lccc-commitfab2.0.sh

    fi
    echo ">>>>>  Peerconnect done with two org setup   <<<<< "
}

function DBimagechg (){
    source .env
    #source .hlc.env
    export `cat .hlc.env | grep DBIMAGE_TAG`
    if [ $DBIMAGE_TAG == 0.4.15 ];then
    docker pull hyperledger/fabric-couchdb:0.4.15
    docker tag hyperledger/fabric-couchdb:0.4.15 couchdb:0.4.15
    #sed -i -e "s/COUCHDB_USER=admin/COUCHDB_USER=/g" $HL_CFG_PATH/docker-compose-cli.yaml
    #sed -i -e "s/COUCHDB_PASSWORD=password/COUCHDB_PASSWORD=/g" $HL_CFG_PATH/docker-compose-cli.yaml
    fi
}


function shfexplorer (){
    
    cp -r crypto-config/*  explorer/examples/net1/crypto/
    EXPORG1KEY="$(ls crypto-config/peerOrganizations/$ORG_1.$DOMAIN_NAME/users/Admin@$ORG_1.$DOMAIN_NAME/msp/keystore/ | grep 'sk$')"
    sed -i -e "s/{ORG1-MSP-KEY}/$EXPORG1KEY/g" ./explorer/examples/net1/connection-profile/first-network.json
    docker-compose -f explorer/docker-compose-explorer.yml up -d

}