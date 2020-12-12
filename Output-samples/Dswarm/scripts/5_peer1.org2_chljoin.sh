source scripts/.c.env
echo -e $PCOLOR"Joining the peer1.org2 to mychannel ..."$NONE
#set -x
CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.dstest.com/peers/peer0.org2.dstest.com/tls/ca.crt
CORE_PEER_TLS_KEY_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.dstest.com/peers/peer0.org1.dstest.com/tls/server.key
CORE_PEER_LOCALMSPID=Org2MSP
CORE_VM_ENDPOINT=unix:///host/var/run/docker.sock
CORE_PEER_TLS_CERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.dstest.com/peers/peer0.org1.dstest.com/tls/server.crt
CORE_PEER_TLS_ENABLED=true
CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.dstest.com/users/Admin@org2.dstest.com/msp
CORE_PEER_ID=
CORE_PEER_ADDRESS=peer1.org2.dstest.com:10051

peer channel join -b mychannel.block
