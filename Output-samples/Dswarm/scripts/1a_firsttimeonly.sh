#!/bin/bash
source .c.env
echo -e $PCOLOR">>> Generating org artifacts"$NONE
cryptogen generate --config=./crypto-config.yaml

echo ""
echo -e $PCOLOR">>> Starting  genesis block Generation"$NONE
export `cat ./.hlc.env | grep ORD_TYPE`
echo "ORD_TYPE="$ORD_TYPE
set +x
if [ "$ORD_TYPE" == "SOLO" ]; then
  echo -e $PCOLOR">>> Generating SOLO genesis block"$NONE
  configtxgen -profile TwoOrgsOrdererGenesis -channelID syschannel -outputBlock ./channel-artifacts/genesis.block
elif [ "$ORD_TYPE" == "RAFT" ]; then
  echo -e $PCOLOR">>> Generating RAFT genesis block"$NONE
  configtxgen -profile TwoOrgsOrdererGenesis -channelID syschannel -outputBlock ./channel-artifacts/genesis.block
else
  set +x
  echo -e $RCOLOR"unrecognized CONSESUS_TYPE='$ORD_TYPE'. exiting"$NONE
  exit 1
fi
res=$?

echo ""
echo -e $PCOLOR">>> Generating  a public channeltx config for consortium "$NONE
configtxgen -profile TwoOrgsChannel -outputCreateChannelTx ./channel-artifacts/mychannel.tx -channelID mychannel
echo ""

function addchlorg() {
    source ./.hlc.env
    for ((i=1; i<= $ORGCNT; i++));
        do
        if [ $ORGCNT -ge 1 ];  then 
            echo -e $PCOLOR">>> Creating a Anchor peer channel config ORG_$i "$NONE
            eval printf '%s' "\${ORG_${i}_C}" | ( read ORC ; echo $ORC |configtxgen -profile TwoOrgsChannel -outputAnchorPeersUpdate ./channel-artifacts/${ORC^}MSPanchors.tx -channelID mychannel -asOrg ${ORC^}MSP ;)
        else
            echo "There is an error creating Anchor channel,  pls check configtx/crypto-config file"
        fi
    done

}
addchlorg

