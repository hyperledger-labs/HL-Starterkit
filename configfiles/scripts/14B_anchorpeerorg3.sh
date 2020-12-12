#!/bin/bash
#Created by : ravinayag@gmail.com | Ravi Vasagam

source scripts/.c.env
echo -e $PCOLOR"Making the {PEER_NAME0}.{ORG_3} as AnchorPeer for {ORG_3} to {CHANNEL_NAME1} ..."$NONE

#set -x
CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/{ORG_3}.{DOMAIN_NAME}/peers/{PEER_NAME0}.{ORG_3}.{DOMAIN_NAME}/tls/ca.crt
CORE_PEER_TLS_KEY_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/{ORG_1}.{DOMAIN_NAME}/peers/{PEER_NAME0}.{ORG_1}.{DOMAIN_NAME}/tls/server.key
CORE_PEER_LOCALMSPID={ORG_3_C}MSP
CORE_VM_ENDPOINT=unix:///host/var/run/docker.sock
CORE_PEER_TLS_CERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/{ORG_1}.{DOMAIN_NAME}/peers/{PEER_NAME0}.{ORG_1}.{DOMAIN_NAME}/tls/server.crt
CORE_PEER_TLS_ENABLED=true
CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/{ORG_3}.{DOMAIN_NAME}/users/Admin@{ORG_3}.{DOMAIN_NAME}/msp
CORE_PEER_ID={CLI_NAME}
CORE_PEER_ADDRESS={PEER_NAME0}.{ORG_3}.{DOMAIN_NAME}:11051
ORDERER_CA=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/{DOMAIN_NAME}/orderers/{ORD_NAME0}.{DOMAIN_NAME}/msp/tlscacerts/tlsca.{DOMAIN_NAME}-cert.pem
#CHANNEL_NAME=mychannel2
peer channel update -o {ORD_NAME0}.{DOMAIN_NAME}:7050 -c {CHANNEL_NAME1} -f ./channel-artifacts/{ORG_3_C}MSPanchors.tx --tls $CORE_PEER_TLS_ENABLED --cafile $ORDERER_CA
