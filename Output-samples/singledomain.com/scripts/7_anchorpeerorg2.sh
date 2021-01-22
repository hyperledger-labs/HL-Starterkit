source scripts/.c.env
echo -e $PCOLOR"Making the p0.org2 as AnchorPeer for org2 to mychannel ..."$NONE

#set -x
CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.singledomain.com/peers/p0.org2.singledomain.com/tls/ca.crt
CORE_PEER_TLS_KEY_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.singledomain.com/peers/p0.org1.singledomain.com/tls/server.key
CORE_PEER_LOCALMSPID=Org2MSP
CORE_VM_ENDPOINT=unix:///host/var/run/docker.sock
CORE_PEER_TLS_CERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.singledomain.com/peers/p0.org1.singledomain.com/tls/server.crt
CORE_PEER_TLS_ENABLED=true
CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.singledomain.com/users/Admin@org2.singledomain.com/msp
CORE_PEER_ID=
CORE_PEER_ADDRESS=p0.org2.singledomain.com:9051
ORDERER_CA=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/singledomain.com/orderers/orderer0.singledomain.com/msp/tlscacerts/tlsca.singledomain.com-cert.pem
#CHANNEL_NAME=mychannel2
peer channel update -o orderer0.singledomain.com:7050 -c mychannel -f ./channel-artifacts/Org2MSPanchors.tx --tls $CORE_PEER_TLS_ENABLED --cafile $ORDERER_CA
