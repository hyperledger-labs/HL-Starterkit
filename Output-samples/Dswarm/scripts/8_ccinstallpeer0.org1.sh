source scripts/.c.env
source scripts/.hlc.env
echo -e $PCOLOR"Installing chaincode on peer0.org1..."$NONE
export CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.dstest.com/peers/peer0.org1.dstest.com/tls/ca.crt
export CORE_PEER_TLS_KEY_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.dstest.com/peers/peer0.org1.dstest.com/tls/server.key
export CORE_PEER_LOCALMSPID=Org1MSP
export CORE_VM_ENDPOINT=unix:///host/var/run/docker.sock
export CORE_PEER_TLS_CERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.dstest.com/peers/peer0.org1.dstest.com/tls/server.crt
export CORE_PEER_TLS_ENABLED=true
export CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.dstest.com/users/Admin@org1.dstest.com/msp
export CORE_PEER_ID=
export CORE_PEER_ADDRESS=peer0.org1.dstest.com:7051
export ORDERER_CA=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/dstest.com/orderers/orderer0.dstest.com/msp/tlscacerts/tlsca.dstest.com-cert.pem

#go get github.com/hyperledger/fabric-chaincode-go/shim
#go get github.com/hyperledger/fabric-protos-go/peer
#peer chaincode install -n mycc -v 1.0 -l golang -p github.com/chaincode/chaincode_example02/go/
#peer chaincode install -n sacc -v 1.0 -l golang -p github.com/chaincode/sacc/
if [  $IMAGE_TAG == 2.0.0 ] ||  [  $IMAGE_TAG == 2.1.0  ] || [  $IMAGE_TAG == 2.2.0  ]; 
then 
source ./scripts/8a_lccpackageinstall2.0.sh
lcpackage20
lcpkinstall20
else
    cd /opt/gopath/src/github.com/chaincode/sacc/
    go get github.com/hyperledger/fabric-chaincode-go/shim
    go get github.com/hyperledger/fabric-protos-go/peer
    
    #go build
    cd /opt/gopath/src/github.com/hyperledger/fabric/peer

    peer chaincode install -n sacc -v 1.0 -l golang -p github.com/chaincode/sacc/
    #peer chaincode package -n mycc -p github.com/chaincode/chaincode_example02/go -v 1.0 -l golang -s -S  ccpack.out -i "OR ('Org1MSP.peer','Org2MSP.peer')"
    #peer chaincode signpackage ccpack.out signedccpack.out
    #peer chaincode install signedccpack.out
fi


echo -e $PCOLOR"Installing chaincode on peer1.org1..."$NONE
export CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.dstest.com/peers/peer1.org1.dstest.com/tls/ca.crt
export CORE_PEER_TLS_KEY_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.dstest.com/peers/peer1.org1.dstest.com/tls/server.key
export CORE_PEER_LOCALMSPID=Org1MSP
export CORE_VM_ENDPOINT=unix:///host/var/run/docker.sock
export CORE_PEER_TLS_CERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.dstest.com/peers/peer1.org1.dstest.com/tls/server.crt
export CORE_PEER_TLS_ENABLED=true
export CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.dstest.com/users/Admin@org1.dstest.com/msp
export CORE_PEER_ID=
export CORE_PEER_ADDRESS=peer1.org1.dstest.com:8051
export ORDERER_CA=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/dstest.com/orderers/orderer0.dstest.com/msp/tlscacerts/tlsca.dstest.com-cert.pem

if [  $IMAGE_TAG == 2.0.0 ] ||  [  $IMAGE_TAG == 2.1.0  ] || [  $IMAGE_TAG == 2.2.0  ]; 
then 
source ./scripts/8a_lccpackageinstall2.0.sh
lcpkinstall20

echo -e $PCOLOR"Querying lifecycle CC install on org1"$NONE
peer lifecycle chaincode queryinstalled
else
peer chaincode install -n sacc -v 1.0 -l golang -p github.com/chaincode/sacc/
#peer chaincode install signedccpack.out
fi




