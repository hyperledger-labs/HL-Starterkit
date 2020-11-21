#!/bin/bash


#set -x 
source .env
source .c.env
source .hlc.env
export COMPOSE_PROJECT_NAME=automation
##############  Explorer Config ###############
function explorerConfig() {
    cp ./configfiles/explorer/docker-compose-explorer-org.yml ./explorer/docker-compose-explorer.yml
    cp ./configfiles/explorer/first-network-org.json  ./explorer/examples/net1/connection-profile/first-network.json

    sed -i -e "s/{DOMAIN_NAME}/$DOMAIN_NAME/g" ./explorer/docker-compose-explorer.yml

    sed -i -e "s/{PEER_NAME0}/$PEER_NAME0/g" ./explorer/examples/net1/connection-profile/first-network.json
    sed -i -e "s/{DOMAIN_NAME}/$DOMAIN_NAME/g" ./explorer/examples/net1/connection-profile/first-network.json
    sed -i -e "s/{ORG_1_C}/$ORG_1_C/g" ./explorer/examples/net1/connection-profile/first-network.json
    sed -i -e "s/{ORG_1}/$ORG_1/g" ./explorer/examples/net1/connection-profile/first-network.json
    sed -i -e "s/{CHANNEL_NAME1}/$CHANNEL_NAME1/g" ./explorer/examples/net1/connection-profile/first-network.json


    EXPORG1KEY="$(ls crypto-config/peerOrganizations/$ORG_1.$DOMAIN_NAME/users/Admin@$ORG_1.$DOMAIN_NAME/msp/keystore/ | grep 'sk$')"
    sed -i -e "s/{ORG1-MSP-KEY}/$EXPORG1KEY/g" ./explorer/examples/net1/connection-profile/first-network.json
}

function startexplore() { 
    echo -e $GRCOLOR" `figlet starting explorer`"$NONE

    rm -rf ./explorer/examples/net1/crypto/*
    cp -r ./crypto-config/* ./explorer/examples/net1/crypto/

    cd explorer && docker-compose -f docker-compose-explorer.yml up -d
    pwd
    docker ps -a  | grep explorer
    echo
    echo
    echo -e $GRCOLOR " Docker explorer can access from http://yourserverip:8090 "$NONE
    echo

}


