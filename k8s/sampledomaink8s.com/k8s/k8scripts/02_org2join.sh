
peer channel fetch 0 mychannel.block -c mychannel -o orderer0:7050 --tls --cafile $ORDERER_CA
sleep 2
peer channel join -b mychannel.block

peer channel list
echo " uptdating acnchor for Myorg2"
peer channel update -o orderer0:7050 -c mychannel -f ./scripts/channel-artifacts/Myorg2MSPanchors.tx --tls --cafile $ORDERER_CA



