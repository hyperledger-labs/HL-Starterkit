source scripts/.c.env
echo -e $PCOLOR"Querying chaincode on {PEER_NAME1}.{ORG_3}..."$NONE
export CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/{ORG_3}.{DOMAIN_NAME}/peers/{PEER_NAME0}.{ORG_3}.{DOMAIN_NAME}/tls/ca.crt
export CORE_PEER_TLS_KEY_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/{ORG_1}.{DOMAIN_NAME}/peers/{PEER_NAME0}.{ORG_1}.{DOMAIN_NAME}/tls/server.key
export CORE_PEER_LOCALMSPID={ORG_3_C}MSP
export CORE_VM_ENDPOINT=unix:///host/var/run/docker.sock
export CORE_PEER_TLS_CERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/{ORG_1}.{DOMAIN_NAME}/peers/{PEER_NAME0}.{ORG_1}.{DOMAIN_NAME}/tls/server.crt
export CORE_PEER_TLS_ENABLED=true
export CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/{ORG_3}.{DOMAIN_NAME}/users/Admin@{ORG_3}.{DOMAIN_NAME}/msp
export CORE_PEER_ID={CLI_NAME}
export CORE_PEER_ADDRESS={PEER_NAME1}.{ORG_3}.{DOMAIN_NAME}:12051
##===================== Querying on peer1.org2 on channel 'mychannel2'... =====================
echo -e $PCOLOR"Attempting to Query {PEER_NAME0}.{ORG_3} ...3 secs"$NONE
peer chaincode query -C {CHANNEL_NAME1} -n mycc -c '{"Args":["query","a"]}'

