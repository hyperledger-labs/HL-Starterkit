#!/bin/bash
#Created by : ravinayag@gmail.com | Ravi Vasagam
export ORDERER_CA=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/{DOMAIN_NAME}/orderers/{ORD_NAME0}.{DOMAIN_NAME}/msp/tlscacerts/tlsca.{DOMAIN_NAME}-cert.pem
#export CHANNEL_NAME1=$CHANNEL_NAME1
export CORE_PEER_TLS_ENABLED=true

docker exec $CLI_NAME peer channel create -o {ORD_NAME0}.{DOMAIN_NAME}:7050 -c {CHANNEL_NAME1} -f ./channel-artifacts/{CHANNEL_NAME1}.tx --tls $CORE_TLS_ENABLED --cafile $ORDERER_CA

