#!/bin/bash
source scripts/.c.env
echo -e $PCOLOR"Joining the p1.org1 to mychannel ..."$NONE
#set -x
export CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.singledomain.com/peers/p0.org1.singledomain.com/tls/ca.crt
export CORE_PEER_TLS_KEY_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.singledomain.com/peers/p0.org1.singledomain.com/tls/server.key
export CORE_PEER_LOCALMSPID=Org1MSP
export CORE_VM_ENDPOINT=unix:///host/var/run/docker.sock
export CORE_PEER_TLS_CERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.singledomain.com/peers/p0.org1.singledomain.com/tls/server.crt
export CORE_PEER_TLS_ENABLED=true
export CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.singledomain.com/users/Admin@org1.singledomain.com/msp
export CORE_PEER_ID=
export CORE_PEER_ADDRESS=p1.org1.singledomain.com:8051
#echo $CORE_PEER_ADDRESS
#echo $CORE_PEER_LOCALMSPID

#CHANNEL_NAME=mychannel2
peer channel join -b mychannel.block
