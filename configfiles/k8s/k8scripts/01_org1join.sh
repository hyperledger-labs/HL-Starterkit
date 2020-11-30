
peer channel create -o {ORD_NAME0}:7050 -c {CHANNEL_NAME1} -f ./scripts/channel-artifacts/{CHANNEL_NAME1}.tx --tls true --cafile $ORDERER_CA
sleep 2
peer channel join -b {CHANNEL_NAME1}.block

echo "listing the channel"
peer channel list

echo " uptdating acnchor {ORG_1_C}"
peer channel update -o {ORD_NAME0}:7050 -c {CHANNEL_NAME1} -f ./scripts/channel-artifacts/{ORG_1_C}MSPanchors.tx --tls --cafile $ORDERER_CA




