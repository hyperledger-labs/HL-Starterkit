echo  "  initiating ......"

source k8scripts/.hlc.env
if [ -z $SAMPLE_CC ] ; then
export CC_LABLNAME="marbles"
else
export CC_LABLNAME="${SAMPLE_CC,,}"
fi
export PEER_CONN_PARMS="--peerAddresses {PEER_NAME0}-{ORG_1}:7051 --tlsRootCertFiles /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/{ORG_1}/peers/{PEER_NAME0}-{ORG_1}/tls/ca.crt"
export PEER_CONN_PARMS1="--peerAddresses {PEER_NAME0}-{ORG_2}:7051 --tlsRootCertFiles /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/{ORG_2}/peers/{PEER_NAME0}-{ORG_2}/tls/ca.crt"
sleep 3

echo ""
echo  -e $PCOLOR "  Querying specific transaction asset from {ORG_2} "$NONE
echo ""

peer chaincode query -C {CHANNEL_NAME1} -n  $CC_LABLNAME -c '{"Args":["readMarble","marble1"]}'
sleep 2

echo ""
sleep 3
echo -e $PCOLOR" Second invoke ..... from {ORG_2}, Invoke transaction by creating a new Marble "$NONE
echo ""
peer chaincode invoke -o {ORD_NAME0}:7050  --tls true --cafile $ORDERER_CA -C {CHANNEL_NAME1} -n  $CC_LABLNAME  $PEER_CONN_PARMS $PEER_CONN_PARMS1  -c '{"Args":["initMarble","marble2","pink","1000","Jerry"]}' --waitForEvent

sleep 5
echo -e $PCOLOR " Querying the asset from {ORG_2}" $NONE
echo ""
peer chaincode query -C {CHANNEL_NAME1} -n  $CC_LABLNAME -c '{"Args":["readMarble","marble2"]}'
sleep 2



#### FABCAR TASKS #####
#peer chaincode query -C {CHANNEL_NAME1} -n  $CC_LABLNAME -c '{"Args":["queryCar","CAR0"]}' 
#peer chaincode query -C {CHANNEL_NAME1} -n  $CC_LABLNAME -c '{"Args":["readMarble","Battery-Car"]}'