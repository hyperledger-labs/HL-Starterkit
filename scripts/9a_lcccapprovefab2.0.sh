
source scripts/.c.env
source scripts/.hlc.env
echo -e $PCOLOR"Approving CC for org1 from peer0..."$NONE
export CC_LABLNAME="${SAMPLE_CC,,}"
echo $CC_LABLNAME

function pkgapproval() {
    if [ $SAMPLE_CC == "ASSETTRANSFER" ]; then 
    export PACKAGE_ID=$(peer lifecycle chaincode queryinstalled | sed -n "/$CC_LABLNAME/{s/^Package ID: //; s/, Label:.*$//; p;}")
    peer lifecycle chaincode approveformyorg -o orderer0.example.com:7050  --tls --cafile $ORDERER_CA --channelID mychannel --signature-policy "OR('Org1MSP.peer', 'Org2MSP.peer')" --name $CC_LABLNAME --version 1.0 --package-id ${PACKAGE_ID} --sequence 1

    elif [ $SAMPLE_CC == "SACC" ];then
    export PACKAGE_ID=$(peer lifecycle chaincode queryinstalled | sed -n "/$CC_LABLNAME/{s/^Package ID: //; s/, Label:.*$//; p;}")
    peer lifecycle chaincode approveformyorg -o orderer0.example.com:7050  --tls --cafile $ORDERER_CA --channelID mychannel --signature-policy "OR('Org1MSP.peer', 'Org2MSP.peer')" --name $CC_LABLNAME --version 1.0 --package-id ${PACKAGE_ID} --sequence 1
    
    elif [ $SAMPLE_CC == "ABSTORE" ]; then
    export PACKAGE_ID=$(peer lifecycle chaincode queryinstalled | sed -n "/$CC_LABLNAME/{s/^Package ID: //; s/, Label:.*$//; p;}")
    peer lifecycle chaincode approveformyorg -o orderer0.example.com:7050  --tls --cafile $ORDERER_CA --channelID mychannel --signature-policy "OR('Org1MSP.peer', 'Org2MSP.peer')" --name $CC_LABLNAME --version 1.0 --package-id ${PACKAGE_ID} --sequence 1
    
    elif [ $SAMPLE_CC == "ABAC" ]; then
    export PACKAGE_ID=$(peer lifecycle chaincode queryinstalled | sed -n "/$CC_LABLNAME/{s/^Package ID: //; s/, Label:.*$//; p;}")
    peer lifecycle chaincode approveformyorg -o orderer0.example.com:7050  --tls --cafile $ORDERER_CA --channelID mychannel --signature-policy "OR('Org1MSP.peer', 'Org2MSP.peer')" --name $CC_LABLNAME --version 1.0 --package-id ${PACKAGE_ID} --sequence 1
    
    elif [ $SAMPLE_CC == "FABCAR" ]; then
    export PACKAGE_ID=$(peer lifecycle chaincode queryinstalled | sed -n "/$CC_LABLNAME/{s/^Package ID: //; s/, Label:.*$//; p;}")
    peer lifecycle chaincode approveformyorg -o orderer0.example.com:7050  --tls --cafile $ORDERER_CA --channelID mychannel --signature-policy "OR('Org1MSP.peer', 'Org2MSP.peer')" --name $CC_LABLNAME --version 1.0 --package-id ${PACKAGE_ID} --sequence 1
    
    else 
    echo -e $COLOR"Unknown package for approval"$NONE

    fi

}

export CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt
export CORE_PEER_TLS_KEY_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/server.key
export CORE_PEER_LOCALMSPID=Org1MSP
export CORE_VM_ENDPOINT=unix:///host/var/run/docker.sock
export CORE_PEER_TLS_CERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/server.crt
export CORE_PEER_TLS_ENABLED=true
export CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp
export CORE_PEER_ID=
export CORE_PEER_ADDRESS=peer0.org1.example.com:7051
export ORDERER_CA=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/example.com/orderers/orderer0.example.com/msp/tlscacerts/tlsca.example.com-cert.pem

pkgapproval


echo -e $PCOLOR"Approving CC for org2 from peer0..."$NONE
export CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/ca.crt
export CORE_PEER_TLS_KEY_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/server.key
export CORE_PEER_LOCALMSPID=Org2MSP
export CORE_VM_ENDPOINT=unix:///host/var/run/docker.sock
export CORE_PEER_TLS_CERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/server.crt
export CORE_PEER_TLS_ENABLED=true
export CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.example.com/users/Admin@org2.example.com/msp
export CORE_PEER_ID=
export CORE_PEER_ADDRESS=peer0.org2.example.com:9051
export ORDERER_CA=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/example.com/orderers/orderer0.example.com/msp/tlscacerts/tlsca.example.com-cert.pem


pkgapproval


sleep 1
echo ""
echo -e $PCOLOR"Checkking the chaincode readiness for commit, ensure both orgs : org1, org2 are true status..."$NONE
peer lifecycle chaincode checkcommitreadiness --channelID mychannel --name $CC_LABLNAME --version 1.0 --signature-policy "OR('Org1MSP.peer', 'Org2MSP.peer')" --sequence 1 --output json
