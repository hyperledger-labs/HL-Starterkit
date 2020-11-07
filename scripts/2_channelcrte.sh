export ORDERER_CA=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/example.com/orderers/orderer0.example.com/msp/tlscacerts/tlsca.example.com-cert.pem
#export CHANNEL_NAME1=$CHANNEL_NAME1
export CORE_PEER_TLS_ENABLED=true

docker exec $CLI_NAME peer channel create -o orderer0.example.com:7050 -c mychannel -f ./channel-artifacts/mychannel.tx --tls $CORE_TLS_ENABLED --cafile $ORDERER_CA

