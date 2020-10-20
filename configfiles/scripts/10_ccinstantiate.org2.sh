source scripts/.c.env
source scripts/.c.env
echo -e $PCOLOR"Instantiating chaincode on {PEER_NAME0}.{ORG_2}..."$NONE
export CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/{ORG_2}.{DOMAIN_NAME}/peers/{PEER_NAME0}.{ORG_2}.{DOMAIN_NAME}/tls/ca.crt
export CORE_PEER_TLS_KEY_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/{ORG_1}.{DOMAIN_NAME}/peers/{PEER_NAME0}.{ORG_1}.{DOMAIN_NAME}/tls/server.key
export CORE_PEER_LOCALMSPID={ORG_2_C}MSP
export CORE_VM_ENDPOINT=unix:///host/var/run/docker.sock
export CORE_PEER_TLS_CERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/{ORG_1}.{DOMAIN_NAME}/peers/{PEER_NAME0}.{ORG_1}.{DOMAIN_NAME}/tls/server.crt
export CORE_PEER_TLS_ENABLED=true
export CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/{ORG_2}.{DOMAIN_NAME}/users/Admin@{ORG_2}.{DOMAIN_NAME}/msp
export CORE_PEER_ID={CLI_NAME}
export CORE_PEER_ADDRESS={PEER_NAME0}.{ORG_2}.{DOMAIN_NAME}:9051
export ORDERER_CA=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/{DOMAIN_NAME}/orderers/{ORD_NAME0}.{DOMAIN_NAME}/msp/tlscacerts/tlsca.{DOMAIN_NAME}-cert.pem

if [ "$IMAGE_TAG" == "2.2.0"  ]; 
then 
peer chaincode instantiate -o {ORD_NAME0}.{DOMAIN_NAME}:7050 --tls --cafile $ORDERER_CA -C {CHANNEL_NAME1} -n sacc -v 1.0 -l golang -c '{"Args":["name","ravi"]}' -P "AND ('{ORG_1_C}MSP.peer','{ORG_2_C}MSP.peer')"
else
peer chaincode instantiate -o {ORD_NAME0}.{DOMAIN_NAME}:7050 --tls true --cafile $ORDERER_CA -C {CHANNEL_NAME1} -n sacc -l golang -v 1.0 -c '{"Args":["a","100"]}' -P 'AND ('\''{ORG_1_C}MSP.peer'\'','\''{ORG_2_C}MSP.peer'\'')'
#peer chaincode instantiate -o {ORD_NAME0}.{DOMAIN_NAME}:7050 --tls --cafile $ORDERER_CA -C {CHANNEL_NAME1} -n mycc -l golang -v 1.0  -c '{"Args":["init","a", "500", "b","700"]}' -P "OR('{ORG_1_C}MSP.peer','{ORG_2_C}MSP.peer')"
fi