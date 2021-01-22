source scripts/.c.env
source scripts/.hlc.env
echo -e $PCOLOR"Sending invoke transaction on p0.org1 p0.org2..."$NONE
export CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.singledomain.com/peers/p0.org1.singledomain.com/tls/ca.crt
export CORE_PEER_TLS_KEY_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.singledomain.com/peers/p0.org1.singledomain.com/tls/server.key
export CORE_PEER_LOCALMSPID=Org1MSP
export CORE_VM_ENDPOINT=unix:///host/var/run/docker.sock
export CORE_PEER_TLS_CERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.singledomain.com/peers/p0.org1.singledomain.com/tls/server.crt
export CORE_PEER_TLS_ENABLED=true
export CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.singledomain.com/users/Admin@org1.singledomain.com/msp
export CORE_PEER_ID=
export CORE_PEER_ADDRESS=p0.org1.singledomain.com:7051

export CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.singledomain.com/peers/p0.org2.singledomain.com/tls/ca.crt
export CORE_PEER_TLS_KEY_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.singledomain.com/peers/p0.org1.singledomain.com/tls/server.key
export CORE_PEER_LOCALMSPID=Org2MSP
export CORE_VM_ENDPOINT=unix:///host/var/run/docker.sock
export CORE_PEER_TLS_CERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.singledomain.com/peers/p0.org1.singledomain.com/tls/server.crt
export CORE_PEER_TLS_ENABLED=true
export CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.singledomain.com/users/Admin@org2.singledomain.com/msp
export CORE_PEER_ID=
export CORE_PEER_ADDRESS=p0.org2.singledomain.com:9051


export ORDERER_CA=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/singledomain.com/orderers/orderer0.singledomain.com/msp/tlscacerts/tlsca.singledomain.com-cert.pem
export PEER0_ORG1_CA=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.singledomain.com/peers/p0.org1.singledomain.com/tls/ca.crt
export PEER0_ORG2_CA=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.singledomain.com/peers/p0.org2.singledomain.com/tls/ca.crt

if [  $IMAGE_TAG == 2.0.0 ] ||  [  $IMAGE_TAG == 2.1.0  ] || [  $IMAGE_TAG == 2.2.0  ]; 
then 
peer chaincode invoke -o orderer0.singledomain.com:7050 --tls true --cafile $ORDERER_CA  -C mychannel -n sacc --peerAddresses p0.org1.singledomain.com:7051 --tlsRootCertFiles $PEER0_ORG1_CA  --peerAddresses p0.org2.singledomain.com:9051 --tlsRootCertFiles $PEER0_ORG2_CA -c '{"Args":["set","name","Peter"]}'
else
peer chaincode invoke -o orderer0.singledomain.com:7050 --tls true --cafile $ORDERER_CA  -C mychannel -n sacc --peerAddresses p0.org1.singledomain.com:7051 --tlsRootCertFiles $PEER0_ORG1_CA  --peerAddresses p0.org2.singledomain.com:9051 --tlsRootCertFiles $PEER0_ORG2_CA -c '{"Args":["set","a","10"]}'
fi



#peer chaincode invoke -o orderer.singledomain.com:7050 --tls true --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/singledomain.com/orderers/orderer.singledomain.com/msp/tlscacerts/tlsca.singledomain.com-cert.pem -C mychannel2 -n mycc --peerAddresses p0.org1.singledomain.com:7051 --tlsRootCertFiles /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.singledomain.com/peers/p0.org1.singledomain.com/tls/ca.crt --peerAddresses p0.org2.singledomain.com:9051 --tlsRootCertFiles /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.singledomain.com/peers/p0.org2.singledomain.com/tls/ca.crt -c '{"Args":["invoke","a","b","10"]}'
