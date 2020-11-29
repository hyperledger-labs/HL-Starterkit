
peer channel fetch 0 mychannel.block -c mychannel -o {ORD_NAME0}:7050 --tls --cafile $ORDERER_CA
sleep 2
peer channel join -b mychannel.block

peer channel list
echo " uptdating acnchor for org2"
peer channel update -o {ORD_NAME0}:7050 -c mychannel -f ./scripts/channel-artifacts/Org2MSPanchors.tx --tls --cafile $ORDERER_CA



#peer lifecycle chaincode checkcommitreadiness --channelID mychannel --name marbles --version 1.0 --init-required --sequence 1 -o -orderer0:7050 --tls --cafile $ORDERER_CA 

### Before invoke ensure you started the exernal chaincode.
#peer chaincode invoke -o orderer0:7050 --isInit --tls true --cafile $ORDERER_CA -C mychannel -n marbles --peerAddresses peer0-org1:7051 --tlsRootCertFiles /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1/peers/peer0-org1/tls/ca.crt --peerAddresses peer0-org2:7051 --tlsRootCertFiles /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2/peers/peer0-org2/tls/ca.crt -c '{"Args":["initMarble","marble1","blue","35","tom"]}' --waitForEvent  
#peer chaincode invoke -o orderer0.example.com:7050 --tls --cafile $ORDERER_CA -C mychannel -n $CC_LABLNAME $PEER_CONN_PARMS $PEER_CONN_PARMS1 -c '{"function":"InitLedger","Args":[]}'
