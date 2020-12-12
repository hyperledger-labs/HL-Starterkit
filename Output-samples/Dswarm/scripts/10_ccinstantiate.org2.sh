source scripts/.c.env
source scripts/.hlc.env
echo -e $PCOLOR"Instantiating chaincode on peer0.org2..."$NONE
export CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.dstest.com/peers/peer0.org2.dstest.com/tls/ca.crt
export CORE_PEER_TLS_KEY_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.dstest.com/peers/peer0.org1.dstest.com/tls/server.key
export CORE_PEER_LOCALMSPID=Org2MSP
export CORE_VM_ENDPOINT=unix:///host/var/run/docker.sock
export CORE_PEER_TLS_CERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.dstest.com/peers/peer0.org1.dstest.com/tls/server.crt
export CORE_PEER_TLS_ENABLED=true
export CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.dstest.com/users/Admin@org2.dstest.com/msp
export CORE_PEER_ID=
export CORE_PEER_ADDRESS=peer0.org2.dstest.com:9051
export ORDERER_CA=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/dstest.com/orderers/orderer0.dstest.com/msp/tlscacerts/tlsca.dstest.com-cert.pem

if [  $IMAGE_TAG == 2.0.0 ] ||  [  $IMAGE_TAG == 2.1.0  ] || [  $IMAGE_TAG == 2.2.0  ]; 
then 
peer chaincode instantiate -o orderer0.dstest.com:7050 --tls --cafile $ORDERER_CA -C mychannel -n sacc -v 1.0 -l golang -c '{"Args":["name","ravi"]}' -P "AND ('Org1MSP.peer','Org2MSP.peer')"
else
peer chaincode instantiate -o orderer0.dstest.com:7050 --tls true --cafile $ORDERER_CA -C mychannel -n sacc -l golang -v 1.0 -c '{"Args":["a","100"]}' -P 'AND ('\''Org1MSP.peer'\'','\''Org2MSP.peer'\'')'
#peer chaincode instantiate -o orderer0.dstest.com:7050 --tls --cafile $ORDERER_CA -C mychannel -n mycc -l golang -v 1.0  -c '{"Args":["init","a", "500", "b","700"]}' -P "OR('Org1MSP.peer','Org2MSP.peer')"
fi