#!/bin/bash
#Created by : ravinayag@gmail.com | Ravi Vasagam

source scripts/.c.env
echo -e $PCOLOR"Joining the {PEER_NAME0}.{ORG_1} to {CHANNEL_NAME1} ..."$NONE
#set -x
export CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/{ORG_1}.{DOMAIN_NAME}/peers/{PEER_NAME0}.{ORG_1}.{DOMAIN_NAME}/tls/ca.crt
export CORE_PEER_TLS_KEY_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/{ORG_1}.{DOMAIN_NAME}/peers/{PEER_NAME0}.{ORG_1}.{DOMAIN_NAME}/tls/server.key
export CORE_PEER_LOCALMSPID={ORG_1_C}MSP
export CORE_VM_ENDPOINT=unix:///host/var/run/docker.sock
export CORE_PEER_TLS_CERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/{ORG_1}.{DOMAIN_NAME}/peers/{PEER_NAME0}.{ORG_1}.{DOMAIN_NAME}/tls/server.crt
export CORE_PEER_TLS_ENABLED=true
export CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/{ORG_1}.{DOMAIN_NAME}/users/Admin@{ORG_1}.{DOMAIN_NAME}/msp
export CORE_PEER_ID={CLI_NAME}
export CORE_PEER_ADDRESS={PEER_NAME0}.{ORG_1}.{DOMAIN_NAME}:7051

peer channel join -b {CHANNEL_NAME1}.block

