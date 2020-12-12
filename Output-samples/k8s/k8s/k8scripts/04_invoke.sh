source k8scripts/.hlc.env
source k8scripts/.c.env

if [ -z $SAMPLE_CC ] ; then
export CC_LABLNAME="marbles"
else
export CC_LABLNAME="${SAMPLE_CC,,}"
fi
echo -e $PCOLOR "  Initiating ......" $NONE

echo $CC_LABLNAME

export PEER_CONN_PARMS="--peerAddresses peer0-myorg1:7051 --tlsRootCertFiles /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/myorg1/peers/peer0-myorg1/tls/ca.crt"
export PEER_CONN_PARMS1="--peerAddresses peer0-myorg2:7051 --tlsRootCertFiles /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/myorg2/peers/peer0-myorg2/tls/ca.crt"
sleep 5
echo -e $PCOLOR" Initiating by marbles myorg1 "$NONE
peer chaincode invoke -o orderer0:7050 --isInit --tls true --cafile $ORDERER_CA -C mychannel  -n  $CC_LABLNAME $PEER_CONN_PARMS $PEER_CONN_PARMS1 -c '{"Args":["initMarble","marble1","blue","35","tom"]}'
sleep 5
echo -e $PCOLOR" Invoking for marbles -myorg1 "$NONE

echo ""
peer chaincode invoke -o orderer0:7050 --tls true --cafile $ORDERER_CA -C mychannel  -n  $CC_LABLNAME $PEER_CONN_PARMS $PEER_CONN_PARMS1 -c '{"Args":["initMarble","marble1","blue","35","tom"]}'
echo ""
sleep 5
echo -e $PCOLOR "  Querying the asset from myorg1"$NONE
echo ""
peer chaincode query -C mychannel -n  $CC_LABLNAME -c '{"Args":["readMarble","marble1"]}'



#### FABCAR TASKS #####
#echo -e $PCOLOR"Invoke transaction by creating a new FABCAR from myorg1 "$NONE
#peer chaincode invoke -o orderer0:7050 --tls --cafile $ORDERER_CA -C mychannel -n $CC_LABLNAME $PEER_CONN_PARMS $PEER_CONN_PARMS1 -c  '{"function": "createCar","Args":["Battery-Car", "Tesla", "A100", "Bright-Red", "vinayag"]}'

# echo ""
# #echo  "  Querying all asset "
# echo ""
# sleep 5
# #peer chaincode query -C mychannel -n  $CC_LABLNAME -c '{"Args":["queryCar","CAR0"]}' 
# echo ""

# sleep 3


