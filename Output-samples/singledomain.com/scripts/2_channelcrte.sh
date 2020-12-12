export ORDERER_CA=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/singledomain.com/orderers/orderer0.singledomain.com/msp/tlscacerts/tlsca.singledomain.com-cert.pem
#export CHANNEL_NAME1=$CHANNEL_NAME1
export CORE_PEER_TLS_ENABLED=true

docker exec $CLI_NAME peer channel create -o orderer0.singledomain.com:7050 -c mychannel -f ./channel-artifacts/mychannel.tx --tls $CORE_TLS_ENABLED --cafile $ORDERER_CA

