source scripts/.c.env
source scripts/.hlc.env
echo -e $PCOLOR"Install chaincode on {PEER_NAME0}.{ORG_2}..."$NONE
export CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/{ORG_2}.{DOMAIN_NAME}/peers/{PEER_NAME0}.{ORG_2}.{DOMAIN_NAME}/tls/ca.crt
export CORE_PEER_TLS_KEY_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/{ORG_1}.{DOMAIN_NAME}/peers/{PEER_NAME0}.{ORG_1}.{DOMAIN_NAME}/tls/server.key
export CORE_PEER_LOCALMSPID={ORG_2_C}MSP
export CORE_VM_ENDPOINT=unix:///host/var/run/docker.sock
export CORE_PEER_TLS_CERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/{ORG_1}.{DOMAIN_NAME}/peers/{PEER_NAME0}.{ORG_1}.{DOMAIN_NAME}/tls/server.crt
export CORE_PEER_TLS_ENABLED=true
export CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/{ORG_2}.{DOMAIN_NAME}/users/Admin@{ORG_2}.{DOMAIN_NAME}/msp
export CORE_PEER_ID={CLI_NAME}
export CORE_PEER_ADDRESS={PEER_NAME0}.{ORG_2}.{DOMAIN_NAME}:9051
if [ "$IMAGE_TAG" == "2.2.0" ]; 
then 
source ./scripts/8a_lccpackageinstall2.0.sh
lcpkinstall20

else
peer chaincode install -n sacc -v 1.0 -l golang -p github.com/chaincode/sacc/
#peer chaincode install signedccpack.out


fi

echo -e $PCOLOR"Installing chaincode on {PEER_NAME1}.{ORG_2}..."$NONE
export CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/{ORG_2}.{DOMAIN_NAME}/peers/{PEER_NAME0}.{ORG_2}.{DOMAIN_NAME}/tls/ca.crt
export CORE_PEER_TLS_KEY_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/{ORG_1}.{DOMAIN_NAME}/peers/{PEER_NAME0}.{ORG_1}.{DOMAIN_NAME}/tls/server.key
export CORE_PEER_LOCALMSPID={ORG_2_C}MSP
export CORE_VM_ENDPOINT=unix:///host/var/run/docker.sock
export CORE_PEER_TLS_CERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/{ORG_1}.{DOMAIN_NAME}/peers/{PEER_NAME0}.{ORG_1}.{DOMAIN_NAME}/tls/server.crt
export CORE_PEER_TLS_ENABLED=true
export CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/{ORG_2}.{DOMAIN_NAME}/users/Admin@{ORG_2}.{DOMAIN_NAME}/msp
export CORE_PEER_ID={CLI_NAME}
export CORE_PEER_ADDRESS={PEER_NAME1}.{ORG_2}.{DOMAIN_NAME}:10051
if [ "$IMAGE_TAG" == "2.2.0" ]; 
then 
source ./scripts/8a_lccpackageinstall2.0.sh
lcpkinstall20

echo -e $PCOLOR"Querying lifecycle CC install on {ORG_2} "$NONE
peer lifecycle chaincode queryinstalled
else
#peer chaincode install -n sacc -v 1.0 -l golang -p github.com/chaincode/chaincode_example02/go/
peer chaincode install -n sacc -v 1.0 -l golang -p github.com/chaincode/sacc/
#peer chaincode install signedccpack.out
fi

#peer chaincode package -n mycc -p github.com/chaincode/chaincode_example02/go/ -v 1 -s -S -i "AND('Org1.admin','Org2.admin')" ccpack.out
#peer chaincode signpackage ccpack.out signedccpack.out
#peer chaincode install signedccpack.out
#peer chaincode instantiate -o orderer.example.com:7050 --tls --cafile $ORDERER_CA -C channel1 -n mycc -v 1.0 -c '{"Args":["init","a", "100", "b","200"]}' -P "AND ('Org1MSP.peer','Org2MSP.peer')"