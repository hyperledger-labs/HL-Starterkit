#!/bin/bash
#Created by : ravinayag@gmail.com | Ravi Vasagam

source scripts/.c.env
source scripts/.hlc.env

cd ../
ln -s /etc/hyperledger/fabric config
cd peer
export PATH=${PWD}/../bin:$PATH

export HL_CFG_PATH=$PWD/../config/
cp /tmp/orderer /usr/local/bin/



export CORE_PEER_TLS_ENABLED=true
export CORE_PEER_LOCALMSPID="Org1MSP"
export CORE_PEER_TLS_ROOTCERT_FILE=${PWD}/crypto/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt
export CORE_PEER_MSPCONFIGPATH=${PWD}/crypto/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp
export CORE_PEER_ADDRESS=peer0.org1.example.com:7051


echo -e $PCOLOR" Initiating the contract "$NONE
peer chaincode invoke -o orderer0.example.com:7050 --ordererTLSHostnameOverride orderer0.example.com \
--tls --cafile ${PWD}/crypto/ordererOrganizations/example.com/orderers/orderer0.example.com/msp/tlscacerts/tlsca.example.com-cert.pem -C mychannel -n assetbasic \
--peerAddresses peer0.org1.example.com:7051 --tlsRootCertFiles ${PWD}/crypto/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt \
--peerAddresses peer0.org2.example.com:9051 --tlsRootCertFiles ${PWD}/crypto/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/ca.crt \
-c '{"function":"InitLedger","Args":[]}'



echo -e $PCOLOR" Transfering the asset name from org1"$NONE

peer chaincode invoke -o orderer0.example.com:7050 --ordererTLSHostnameOverride orderer0.example.com \
--tls --cafile ${PWD}/crypto/ordererOrganizations/example.com/orderers/orderer0.example.com/msp/tlscacerts/tlsca.example.com-cert.pem -C mychannel -n assetbasic \
--peerAddresses peer0.org1.example.com:7051 --tlsRootCertFiles ${PWD}/crypto/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt \
--peerAddresses peer0.org2.example.com:9051 --tlsRootCertFiles ${PWD}/crypto/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/ca.crt \
-c '{"function":"TransferAsset","Args":["asset6","Christopher"]}'


export CORE_PEER_TLS_ENABLED=true
export CORE_PEER_LOCALMSPID="Org2MSP"
export CORE_PEER_TLS_ROOTCERT_FILE=${PWD}/crypto-config/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/ca.crt
export CORE_PEER_MSPCONFIGPATH=${PWD}/crypto-config/peerOrganizations/org2.example.com/users/Admin@org2.example.com/msp
export CORE_PEER_ADDRESS=localhost:9051

echo -e $PCOLOR" querying the asset6 from org2"$NONE
peer chaincode query -C mychannel -n assetbasic -c '{"Args":["ReadAsset","asset6"]}'