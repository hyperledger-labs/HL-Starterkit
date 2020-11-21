echo "installing marbles"
peer lifecycle chaincode install /opt/gopath/src/github.com/marbles/packaging/marbles-org2.tgz

sleep 3
export PACKAGE_ID=$(peer lifecycle chaincode queryinstalled | sed -n "/marbles/{s/^Package ID: //; s/, Label:.*$//; p;}")
echo $PACKAGE_ID > k8scripts/.packageid.env
sleep 1
echo " approving my org"
peer lifecycle chaincode approveformyorg --channelID mychannel --name marbles --version 1.0 --init-required --package-id $PACKAGE_ID  --sequence 1 -o {ORD_NAME0}:7050 --tls --cafile $ORDERER_CA


echo " commiting "
peer lifecycle chaincode commit -o {ORD_NAME0}:7050 --channelID mychannel --name marbles --version 1.0 --sequence 1 --init-required --tls true --cafile $ORDERER_CA --peerAddresses peer0-org1:7051 --tlsRootCertFiles /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1/peers/peer0-org1/tls/ca.crt --peerAddresses peer0-org2:7051 --tlsRootCertFiles $CORE_PEER_TLS_ROOTCERT_FILE

echo " checking readiness"
sleep 2
peer lifecycle chaincode querycommitted --channelID mychannel --name marbles 