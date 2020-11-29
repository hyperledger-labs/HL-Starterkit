
peer channel create -o {ORD_NAME0}:7050 -c mychannel -f ./scripts/channel-artifacts/mychannel.tx --tls true --cafile $ORDERER_CA
sleep 2
peer channel join -b mychannel.block

echo "listing the channel"
peer channel list

echo " uptdating acnchor org1"
peer channel update -o {ORD_NAME0}:7050 -c mychannel -f ./scripts/channel-artifacts/Org1MSPanchors.tx --tls --cafile $ORDERER_CA





#peer chaincode invoke -o orderer0:7050 --isInit --tls true --cafile $ORDERER_CA -C mychannel -n marbles --peerAddresses peer0-org1:7051 --tlsRootCertFiles /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1/peers/peer0-org1/tls/ca.crt --peerAddresses peer0-org2:7051 --tlsRootCertFiles /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2/peers/peer0-org2/tls/ca.crt -c '{"Args":["initMarble","marble1","blue","35","tom"]}' --waitForEvent 
#peer chaincode invoke -o orderer0:7050  --tls true --cafile $ORDERER_CA -C mychannel -n marbles --peerAddresses peer0-org1:7051 --tlsRootCertFiles /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1/peers/peer0-org1/tls/ca.crt --peerAddresses peer0-org2:7051 --tlsRootCertFiles /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2/peers/peer0-org2/tls/ca.crt -c '{"Args":["initMarble","marble2","red","50","tom"]}'