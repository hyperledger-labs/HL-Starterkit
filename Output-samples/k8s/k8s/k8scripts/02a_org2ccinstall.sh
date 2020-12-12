echo "installing marbles"

source k8scripts/.hlc.env
if [ -z $SAMPLE_CC ] ; then
export CC_LABLNAME="marbles"
else
export CC_LABLNAME="${SAMPLE_CC,,}"
fi
echo $CC_LABLNAME

export PEER_CONN_PARMS="--peerAddresses peer0-myorg1:7051 --tlsRootCertFiles /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/myorg1/peers/peer0-myorg1/tls/ca.crt"
export PEER_CONN_PARMS1="--peerAddresses peer0-myorg2:7051 --tlsRootCertFiles /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/myorg2/peers/peer0-myorg2/tls/ca.crt"

peer lifecycle chaincode install /opt/gopath/src/github.com/marbles/packaging/marbles-org2.tgz

sleep 3
export PACKAGE_ID=$(peer lifecycle chaincode queryinstalled | sed -n "/marbles/{s/^Package ID: //; s/, Label:.*$//; p;}")
echo $PACKAGE_ID > k8scripts/.packageid.env
sleep 1
echo " approving my org"
peer lifecycle chaincode approveformyorg --channelID mychannel --name $CC_LABLNAME --version 1.0 --init-required --package-id $PACKAGE_ID  --sequence 1 -o orderer0:7050 --tls --cafile $ORDERER_CA


echo " commiting "
peer lifecycle chaincode commit -o orderer0:7050 --channelID mychannel --name $CC_LABLNAME --version 1.0 --sequence 1 --init-required --tls true --cafile $ORDERER_CA $PEER_CONN_PARMS $PEER_CONN_PARMS1

echo " checking readiness"
sleep 2
peer lifecycle chaincode querycommitted --channelID mychannel --name $CC_LABLNAME 