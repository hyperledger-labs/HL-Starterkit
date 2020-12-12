
peer channel create -o orderer0:7050 -c mychannel -f ./scripts/channel-artifacts/mychannel.tx --tls true --cafile $ORDERER_CA
sleep 2
peer channel join -b mychannel.block

echo "listing the channel"
peer channel list

echo " uptdating acnchor Myorg1"
peer channel update -o orderer0:7050 -c mychannel -f ./scripts/channel-artifacts/Myorg1MSPanchors.tx --tls --cafile $ORDERER_CA




