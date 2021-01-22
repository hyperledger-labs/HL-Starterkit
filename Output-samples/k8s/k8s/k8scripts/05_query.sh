echo  "  initiating ......"

source k8scripts/.hlc.env
if [ -z $SAMPLE_CC ] ; then
export CC_LABLNAME="marbles"
else
export CC_LABLNAME="${SAMPLE_CC,,}"
fi
export PEER_CONN_PARMS="--peerAddresses peer0-myorg1:7051 --tlsRootCertFiles /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/myorg1/peers/peer0-myorg1/tls/ca.crt"
export PEER_CONN_PARMS1="--peerAddresses peer0-myorg2:7051 --tlsRootCertFiles /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/myorg2/peers/peer0-myorg2/tls/ca.crt"
sleep 3

echo ""
echo  -e $PCOLOR "  Querying specific transaction asset from myorg2 "$NONE
echo ""

peer chaincode query -C mychannel -n  $CC_LABLNAME -c '{"Args":["readMarble","marble1"]}'
sleep 2

echo ""
sleep 3
echo -e $PCOLOR" Second invoke ..... from myorg2, Invoke transaction by creating a new Marble "$NONE
echo ""
peer chaincode invoke -o orderer0:7050  --tls true --cafile $ORDERER_CA -C mychannel -n  $CC_LABLNAME  $PEER_CONN_PARMS $PEER_CONN_PARMS1  -c '{"Args":["initMarble","marble2","pink","1000","Jerry"]}' --waitForEvent

sleep 5
echo -e $PCOLOR " Querying the asset from myorg2" $NONE
echo ""
peer chaincode query -C mychannel -n  $CC_LABLNAME -c '{"Args":["readMarble","marble2"]}'
sleep 2



#### FABCAR TASKS #####
#peer chaincode query -C mychannel -n  $CC_LABLNAME -c '{"Args":["queryCar","CAR0"]}' 
#peer chaincode query -C mychannel -n  $CC_LABLNAME -c '{"Args":["readMarble","Battery-Car"]}'