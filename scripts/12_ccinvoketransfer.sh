source scripts/.c.env
echo -e $PCOLOR"Sending invoke transaction on peer0.org1 peer0...."$NONE
export CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.mydom.com/peers/peer0.org1.mydom.com/tls/ca.crt
export CORE_PEER_TLS_KEY_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.mydom.com/peers/peer0.org1.mydom.com/tls/server.key
export CORE_PEER_LOCALMSPID=Org1MSP
export CORE_VM_ENDPOINT=unix:///host/var/run/docker.sock
export CORE_PEER_TLS_CERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.mydom.com/peers/peer0.org1.mydom.com/tls/server.crt
export CORE_PEER_TLS_ENABLED=true
export CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.mydom.com/users/Admin@org1.mydom.com/msp
export CORE_PEER_ID=
export CORE_PEER_ADDRESS=peer0.org1.mydom.com:7051

export CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/.mydom.com/peers/peer0..mydom.com/tls/ca.crt
export CORE_PEER_TLS_KEY_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.mydom.com/peers/peer0.org1.mydom.com/tls/server.key
export CORE_PEER_LOCALMSPID=MSP
export CORE_VM_ENDPOINT=unix:///host/var/run/docker.sock
export CORE_PEER_TLS_CERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.mydom.com/peers/peer0.org1.mydom.com/tls/server.crt
export CORE_PEER_TLS_ENABLED=true
export CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/.mydom.com/users/Admin@.mydom.com/msp
export CORE_PEER_ID=
export CORE_PEER_ADDRESS=peer0..mydom.com:9051


export ORDERER_CA=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/mydom.com/orderers/orderer0.mydom.com/msp/tlscacerts/tlsca.mydom.com-cert.pem
export PEER0_ORG1_CA=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.mydom.com/peers/peer0.org1.mydom.com/tls/ca.crt
export PEER0_ORG2_CA=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/.mydom.com/peers/peer0..mydom.com/tls/ca.crt

if [ "$IMAGE_TAG" == "2.2.0"  ]; 
then 
peer chaincode invoke -o orderer0.mydom.com:7050 --tls true --cafile $ORDERER_CA  -C mychannel -n sacc --peerAddresses peer0.org1.mydom.com:7051 --tlsRootCertFiles $PEER0_ORG1_CA  --peerAddresses peer0..mydom.com:9051 --tlsRootCertFiles $PEER0_ORG2_CA -c '{"Args":["set","name","Peter"]}'
else
peer chaincode invoke -o orderer0.mydom.com:7050 --tls true --cafile $ORDERER_CA  -C mychannel -n sacc --peerAddresses peer0.org1.mydom.com:7051 --tlsRootCertFiles $PEER0_ORG1_CA  --peerAddresses peer0..mydom.com:9051 --tlsRootCertFiles $PEER0_ORG2_CA -c '{"Args":["set","a","10"]}'
fi



#peer chaincode invoke -o orderer.mydom.com:7050 --tls true --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/mydom.com/orderers/orderer.mydom.com/msp/tlscacerts/tlsca.mydom.com-cert.pem -C mychannel2 -n mycc --peerAddresses peer0.org1.mydom.com:7051 --tlsRootCertFiles /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.mydom.com/peers/peer0.org1.mydom.com/tls/ca.crt --peerAddresses peer0..mydom.com:9051 --tlsRootCertFiles /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/.mydom.com/peers/peer0..mydom.com/tls/ca.crt -c '{"Args":["invoke","a","b","10"]}'
