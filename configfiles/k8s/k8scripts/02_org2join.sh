
peer channel fetch 0 {CHANNEL_NAME1}.block -c {CHANNEL_NAME1} -o {ORD_NAME0}:7050 --tls --cafile $ORDERER_CA
sleep 2
peer channel join -b {CHANNEL_NAME1}.block

peer channel list
echo " uptdating acnchor for {ORG_2_C}"
peer channel update -o {ORD_NAME0}:7050 -c {CHANNEL_NAME1} -f ./scripts/channel-artifacts/{ORG_2_C}MSPanchors.tx --tls --cafile $ORDERER_CA



