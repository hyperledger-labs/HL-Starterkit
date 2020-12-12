#!/bin/bash
#Created by : ravinayag@gmail.com | Ravi Vasagam

source scripts/.c.env
source scripts/.hlc.env
echo -e $PCOLOR"Approving CC for {ORG_1} from {PEER_NAME0}..."$NONE
export CC_LABLNAME="${SAMPLE_CC,,}"
echo $CC_LABLNAME

function pkgapproval() {
    if [ $SAMPLE_CC == "ASSETTRANSFER" ]; then 
    export PACKAGE_ID=$(peer lifecycle chaincode queryinstalled | sed -n "/$CC_LABLNAME/{s/^Package ID: //; s/, Label:.*$//; p;}")
    peer lifecycle chaincode approveformyorg -o {ORD_NAME0}.{DOMAIN_NAME}:7050  --tls --cafile $ORDERER_CA --channelID {CHANNEL_NAME1} --signature-policy "OR('{ORG_1_C}MSP.peer', '{ORG_2_C}MSP.peer')" --name $CC_LABLNAME --version 1.0 --package-id ${PACKAGE_ID} --sequence 1

    elif [ $SAMPLE_CC == "SACC" ];then
    export PACKAGE_ID=$(peer lifecycle chaincode queryinstalled | sed -n "/$CC_LABLNAME/{s/^Package ID: //; s/, Label:.*$//; p;}")
    peer lifecycle chaincode approveformyorg -o {ORD_NAME0}.{DOMAIN_NAME}:7050  --tls --cafile $ORDERER_CA --channelID {CHANNEL_NAME1} --signature-policy "OR('{ORG_1_C}MSP.peer', '{ORG_2_C}MSP.peer')" --name $CC_LABLNAME --version 1.0 --package-id ${PACKAGE_ID} --sequence 1
    
    elif [ $SAMPLE_CC == "ABSTORE" ]; then
    export PACKAGE_ID=$(peer lifecycle chaincode queryinstalled | sed -n "/$CC_LABLNAME/{s/^Package ID: //; s/, Label:.*$//; p;}")
    peer lifecycle chaincode approveformyorg -o {ORD_NAME0}.{DOMAIN_NAME}:7050  --tls --cafile $ORDERER_CA --channelID {CHANNEL_NAME1} --signature-policy "OR('{ORG_1_C}MSP.peer', '{ORG_2_C}MSP.peer')" --name $CC_LABLNAME --version 1.0 --package-id ${PACKAGE_ID} --sequence 1
    
    elif [ $SAMPLE_CC == "ABAC" ]; then
    export PACKAGE_ID=$(peer lifecycle chaincode queryinstalled | sed -n "/$CC_LABLNAME/{s/^Package ID: //; s/, Label:.*$//; p;}")
    peer lifecycle chaincode approveformyorg -o {ORD_NAME0}.{DOMAIN_NAME}:7050  --tls --cafile $ORDERER_CA --channelID {CHANNEL_NAME1} --signature-policy "OR('{ORG_1_C}MSP.peer', '{ORG_2_C}MSP.peer')" --name $CC_LABLNAME --version 1.0 --package-id ${PACKAGE_ID} --sequence 1
    
    elif [ $SAMPLE_CC == "FABCAR" ]; then
    export PACKAGE_ID=$(peer lifecycle chaincode queryinstalled | sed -n "/$CC_LABLNAME/{s/^Package ID: //; s/, Label:.*$//; p;}")
    peer lifecycle chaincode approveformyorg -o {ORD_NAME0}.{DOMAIN_NAME}:7050  --tls --cafile $ORDERER_CA --channelID {CHANNEL_NAME1} --signature-policy "OR('{ORG_1_C}MSP.peer', '{ORG_2_C}MSP.peer')" --name $CC_LABLNAME --version 1.0 --package-id ${PACKAGE_ID} --sequence 1
  
    elif [ $SAMPLE_CC == "MARBLES" ]; then
    export PACKAGE_ID=$(peer lifecycle chaincode queryinstalled | sed -n "/$CC_LABLNAME/{s/^Package ID: //; s/, Label:.*$//; p;}")
    peer lifecycle chaincode approveformyorg -o {ORD_NAME0}.{DOMAIN_NAME}:7050  --tls --cafile $ORDERER_CA --channelID {CHANNEL_NAME1} --signature-policy "OR('{ORG_1_C}MSP.peer', '{ORG_2_C}MSP.peer')" --name $CC_LABLNAME --version 1.0 --package-id ${PACKAGE_ID} --sequence 1
      
    else 
    echo -e $COLOR"Unknown package for approval"$NONE

    fi

}

export CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/{ORG_1}.{DOMAIN_NAME}/peers/{PEER_NAME0}.{ORG_1}.{DOMAIN_NAME}/tls/ca.crt
export CORE_PEER_TLS_KEY_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/{ORG_1}.{DOMAIN_NAME}/peers/{PEER_NAME0}.{ORG_1}.{DOMAIN_NAME}/tls/server.key
export CORE_PEER_LOCALMSPID={ORG_1_C}MSP
export CORE_VM_ENDPOINT=unix:///host/var/run/docker.sock
export CORE_PEER_TLS_CERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/{ORG_1}.{DOMAIN_NAME}/peers/{PEER_NAME0}.{ORG_1}.{DOMAIN_NAME}/tls/server.crt
export CORE_PEER_TLS_ENABLED=true
export CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/{ORG_1}.{DOMAIN_NAME}/users/Admin@{ORG_1}.{DOMAIN_NAME}/msp
export CORE_PEER_ID={CLI_NAME}
export CORE_PEER_ADDRESS={PEER_NAME0}.{ORG_1}.{DOMAIN_NAME}:7051
export ORDERER_CA=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/{DOMAIN_NAME}/orderers/{ORD_NAME0}.{DOMAIN_NAME}/msp/tlscacerts/tlsca.{DOMAIN_NAME}-cert.pem

pkgapproval


echo -e $PCOLOR"Approving CC for {ORG_2} from {PEER_NAME0}..."$NONE
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


pkgapproval


sleep 1
echo ""
echo -e $PCOLOR"Checkking the chaincode readiness for commit, ensure both orgs : {ORG_1}, {ORG_2} are true status..."$NONE
peer lifecycle chaincode checkcommitreadiness --channelID {CHANNEL_NAME1} --name $CC_LABLNAME --version 1.0 --signature-policy "OR('{ORG_1_C}MSP.peer', '{ORG_2_C}MSP.peer')" --sequence 1 --output json
