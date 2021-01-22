echo "installing marbles"
source k8scripts/.hlc.env
if [ -z $SAMPLE_CC ] ; then
export CC_LABLNAME="marbles"
else
export CC_LABLNAME="${SAMPLE_CC,,}"
fi
echo $CC_LABLNAME
peer lifecycle chaincode install /opt/gopath/src/github.com/marbles/packaging/marbles-org1.tgz

sleep 3

export PACKAGE_ID=$(peer lifecycle chaincode queryinstalled | sed -n "/marbles/{s/^Package ID: //; s/, Label:.*$//; p;}")
echo $PACKAGE_ID > k8scripts/.packageid.env
sleep 1
echo " approving my org"
peer lifecycle chaincode approveformyorg --channelID mychannel --name $CC_LABLNAME --version 1.0 --init-required --package-id $PACKAGE_ID --sequence 1 -o orderer0:7050 --tls --cafile $ORDERER_CA 


echo " checking readiness"
sleep 2
peer lifecycle chaincode checkcommitreadiness --channelID mychannel --name $CC_LABLNAME --version 1.0 --init-required --sequence 1 -o orderer0:7050 --tls --cafile $ORDERER_CA 
