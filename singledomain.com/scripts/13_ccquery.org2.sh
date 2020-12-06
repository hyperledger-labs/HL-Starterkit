source scripts/.c.env
source scripts/.hlc.env
echo -e $PCOLOR"Querying chaincode on p1.org2..."$NONE
export CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.singledomain.com/peers/p0.org2.singledomain.com/tls/ca.crt
export CORE_PEER_TLS_KEY_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.singledomain.com/peers/p0.org1.singledomain.com/tls/server.key
export CORE_PEER_LOCALMSPID=Org2MSP
export CORE_VM_ENDPOINT=unix:///host/var/run/docker.sock
export CORE_PEER_TLS_CERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.singledomain.com/peers/p0.org1.singledomain.com/tls/server.crt
export CORE_PEER_TLS_ENABLED=true
export CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.singledomain.com/users/Admin@org2.singledomain.com/msp
export CORE_PEER_ID=
export CORE_PEER_ADDRESS=p1.org2.singledomain.com:10051
##===================== Querying on peer1.org2 on channel 'mychannel2'... =====================
echo -e $PCOLOR"Attempting to Query p0.org2 ...3 secs"$NONE
sleep 5
if [  $IMAGE_TAG == 2.0.0 ] ||  [  $IMAGE_TAG == 2.1.0  ] || [  $IMAGE_TAG == 2.2.0  ]; 
then 
peer chaincode query -C mychannel -n mycc -c '{"Args":["get","name"]}'
else
peer chaincode query -C mychannel -n sacc -c '{"Args":["query","a"]}'
fi 
