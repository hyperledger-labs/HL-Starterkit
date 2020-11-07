source scripts/.c.env
source scripts/.c.env
echo -e $PCOLOR"Instantiating chaincode on peer0...."$NONE
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

if [ "$IMAGE_TAG" == "2.2.0"  ]; 
then 
peer chaincode instantiate -o orderer0.mydom.com:7050 --tls --cafile $ORDERER_CA -C mychannel -n sacc -v 1.0 -l golang -c '{"Args":["name","ravi"]}' -P "AND ('Org1MSP.peer','MSP.peer')"
else
peer chaincode instantiate -o orderer0.mydom.com:7050 --tls true --cafile $ORDERER_CA -C mychannel -n sacc -l golang -v 1.0 -c '{"Args":["a","100"]}' -P 'AND ('\''Org1MSP.peer'\'','\''MSP.peer'\'')'
#peer chaincode instantiate -o orderer0.mydom.com:7050 --tls --cafile $ORDERER_CA -C mychannel -n mycc -l golang -v 1.0  -c '{"Args":["init","a", "500", "b","700"]}' -P "OR('Org1MSP.peer','MSP.peer')"
fi