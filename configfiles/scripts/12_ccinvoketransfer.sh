source scripts/.c.env
echo -e $PCOLOR"Sending invoke transaction on {PEER_NAME0}.{ORG_1} {PEER_NAME0}.{ORG_2}..."$NONE
export CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/{ORG_1}.{DOMAIN_NAME}/peers/{PEER_NAME0}.{ORG_1}.{DOMAIN_NAME}/tls/ca.crt
export CORE_PEER_TLS_KEY_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/{ORG_1}.{DOMAIN_NAME}/peers/{PEER_NAME0}.{ORG_1}.{DOMAIN_NAME}/tls/server.key
export CORE_PEER_LOCALMSPID={ORG_1_C}MSP
export CORE_VM_ENDPOINT=unix:///host/var/run/docker.sock
export CORE_PEER_TLS_CERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/{ORG_1}.{DOMAIN_NAME}/peers/{PEER_NAME0}.{ORG_1}.{DOMAIN_NAME}/tls/server.crt
export CORE_PEER_TLS_ENABLED=true
export CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/{ORG_1}.{DOMAIN_NAME}/users/Admin@{ORG_1}.{DOMAIN_NAME}/msp
export CORE_PEER_ID={CLI_NAME}
export CORE_PEER_ADDRESS={PEER_NAME0}.{ORG_1}.{DOMAIN_NAME}:7051

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
export PEER0_ORG1_CA=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/{ORG_1}.{DOMAIN_NAME}/peers/{PEER_NAME0}.{ORG_1}.{DOMAIN_NAME}/tls/ca.crt
export PEER0_ORG2_CA=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/{ORG_2}.{DOMAIN_NAME}/peers/{PEER_NAME0}.{ORG_2}.{DOMAIN_NAME}/tls/ca.crt

if [[ $IMAGE_TAG == @(2.0.0|2.1.0|2.2.0) ]]; 
then 
peer chaincode invoke -o {ORD_NAME0}.{DOMAIN_NAME}:7050 --tls true --cafile $ORDERER_CA  -C {CHANNEL_NAME1} -n sacc --peerAddresses {PEER_NAME0}.{ORG_1}.{DOMAIN_NAME}:7051 --tlsRootCertFiles $PEER0_ORG1_CA  --peerAddresses {PEER_NAME0}.{ORG_2}.{DOMAIN_NAME}:9051 --tlsRootCertFiles $PEER0_ORG2_CA -c '{"Args":["set","name","Peter"]}'
else
peer chaincode invoke -o {ORD_NAME0}.{DOMAIN_NAME}:7050 --tls true --cafile $ORDERER_CA  -C {CHANNEL_NAME1} -n sacc --peerAddresses {PEER_NAME0}.{ORG_1}.{DOMAIN_NAME}:7051 --tlsRootCertFiles $PEER0_ORG1_CA  --peerAddresses {PEER_NAME0}.{ORG_2}.{DOMAIN_NAME}:9051 --tlsRootCertFiles $PEER0_ORG2_CA -c '{"Args":["set","a","10"]}'
fi



#peer chaincode invoke -o orderer.{DOMAIN_NAME}:7050 --tls true --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/{DOMAIN_NAME}/orderers/orderer.{DOMAIN_NAME}/msp/tlscacerts/tlsca.{DOMAIN_NAME}-cert.pem -C mychannel2 -n mycc --peerAddresses {PEER_NAME0}.{ORG_1}.{DOMAIN_NAME}:7051 --tlsRootCertFiles /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/{ORG_1}.{DOMAIN_NAME}/peers/{PEER_NAME0}.{ORG_1}.{DOMAIN_NAME}/tls/ca.crt --peerAddresses {PEER_NAME0}.{ORG_2}.{DOMAIN_NAME}:9051 --tlsRootCertFiles /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/{ORG_2}.{DOMAIN_NAME}/peers/{PEER_NAME0}.{ORG_2}.{DOMAIN_NAME}/tls/ca.crt -c '{"Args":["invoke","a","b","10"]}'
