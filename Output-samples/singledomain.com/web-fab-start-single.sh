source .env
source .hlc.env
source .c.env

export `cat .hlc.env | grep IMAGE_TAG`

echo "Ensure at this time you downloaded fabric-samples, binaries and Fabric-images, 
  If not please download the prereq script and  run "FbinImage" from your home folder."



cd $HL_CFG_PATH/

cp -r ../asset-transfer* ../chaincode/    ## Copying sample to chaincode folder



function replKeys () {

    source .hlc.env
    echo "running keys replacements"
    if [ $HLENV != "WEB" ];then 
    ORG1KEY="$(ls crypto-config/peerOrganizations/$ORG_1.$DOMAIN_NAME/ca/ | grep 'sk$')"
    sed -i -e "s/{ORG1-CA-KEY}/$ORG1KEY/g" ./base/ca-base.yaml


    ORG1TLSKEY="$(ls crypto-config/peerOrganizations/$ORG_1.$DOMAIN_NAME/tlsca/ | grep 'sk$')"
    sed -i -e "s/{ORG1-TLSCA-KEY}/$ORG1TLSKEY/g" ./base/ca-base.yaml

    ORG2KEY="$(ls crypto-config/peerOrganizations/$ORG_2.$DOMAIN_NAME/ca/ | grep 'sk$')"
    sed -i -e "s/{ORG2-CA-KEY}/$ORG2KEY/g" ./base/ca-base.yaml
    

    ORG2TLSKEY="$(ls crypto-config/peerOrganizations/$ORG_2.$DOMAIN_NAME/tlsca/ | grep 'sk$')"
    sed -i -e "s/{ORG2-TLSCA-KEY}/$ORG2TLSKEY/g" ./base/ca-base.yaml
    else echo ""
    fi
}


echo -e $GRCOLOR" `figlet Starting Fabric`"$NONE
if [ "$ORD_TYPE" == "SOLO"  ]; then
  echo running ./scripts/1a_firsttimeonly.sh
  rm -rf crypto-config
  mkdir -p channel-artifacts
  ./scripts/1a_firsttimeonly.sh
  replKeys
  echo -e $GRCOLO" Starting with SOLO Orderer "$NONE
  docker-compose -f docker-compose-cli.yaml up -d
  sleep 5 
elif [ "$ORD_TYPE" == "RAFT" ]; then
  echo -e $GRCOLO" Starting with RAFT Orderer "$NONE
  echo running ./scripts/1a_firsttimeonly.sh
  rm -rf crypto-config
  mkdir -p channel-artifacts
  ./scripts/1a_firsttimeonly.sh
  replKeys
  docker-compose -f docker-compose-cli.yaml -f docker-compose-orderer-etcraft.yaml up -d
  sleep 15 
else echo ""
fi
sleep 10 

docker ps -a
export CLI_NAME="$(docker ps --format='{{.Names}}' | grep cli)"
echo "CLI_NAME=$CLI_NAME" >> .hlc.env
./scripts/2_channelcrte.sh


function peernetconnect() {
    source .hlc.env
    

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
        docker exec $CLI_NAME bash ./scripts/9a_lcccapprovefab2.0.sh

        docker exec $CLI_NAME bash ./scripts/10a_lccc-commitfab2.0.sh


    fi
    echo ">>>>>  Peerconnect done with two org setup   <<<<< "
}

peernetconnect