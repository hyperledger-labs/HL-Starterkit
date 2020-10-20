source .c.env
echo -e $PCOLOR">>> Generating org artifacts"$NONE
cryptogen generate --config=./crypto-config.yaml

echo ""
echo -e $PCOLOR">>> Starting  genesis block Generation"$NONE
#configtxgen -profile TwoOrgsOrdererGenesis -channelID {SYS_CHANNEL} -outputBlock ./channel-artifacts/genesis.block
#configtxgen -profile SampleMultiNodeEtcdRaft -channelID {SYS_CHANNEL} -outputBlock ./channel-artifacts/genesis.block


export `cat ./.hlc.env | grep ORD_TYPE`
echo "ORD_TYPE="$ORD_TYPE
set +x
if [ "$ORD_TYPE" == "SOLO" ]; then
  echo -e $PCOLOR">>> Generating SOLO genesis block"$NONE
  configtxgen -profile TwoOrgsOrdererGenesis -channelID {SYS_CHANNEL} -outputBlock ./channel-artifacts/genesis.block
elif [ "$ORD_TYPE" == "RAFT" ]; then
  echo -e $PCOLOR">>> Generating RAFT genesis block"$NONE
  configtxgen -profile SampleMultiNodeEtcdRaft -channelID {SYS_CHANNEL} -outputBlock ./channel-artifacts/genesis.block
else
  set +x
  echo -e $RCOLOR"unrecognized CONSESUS_TYPE='$ORD_TYPE'. exiting"$NONE
  exit 1
fi
res=$?


echo ""
echo -e $PCOLOR">>> Generating  a public channeltx config for consortium "$NONE
configtxgen -profile TwoOrgsChannel -outputCreateChannelTx ./channel-artifacts/{CHANNEL_NAME1}.tx -channelID {CHANNEL_NAME1}
echo ""
#echo -e $PCOLOR">>> Creating a Anchor peer channel config Org1"$NONE
#configtxgen -profile TwoOrgsChannel -outputAnchorPeersUpdate ./channel-artifacts/{ORG_1_C}MSPanchors.tx -channelID {CHANNEL_NAME1} -asOrg {ORG_1_C}MSP
echo ""
#echo -e $PCOLOR">>> Creating a Anchor peer channel config Org2"$NONE
#configtxgen -profile TwoOrgsChannel -outputAnchorPeersUpdate ./channel-artifacts/{ORG_2_C}MSPanchors.tx -channelID {CHANNEL_NAME1} -asOrg {ORG_2_C}MSP


function addchlorg() {
    #export `cat .hlc.env | grep ORGCNT`
    source ./.hlc.env

    for ((i=1; i<= $ORGCNT; i++));
        do
        if [ $ORGCNT -ge 1 ];  then 
            
            echo -e $PCOLOR">>> Creating a Anchor peer channel config ORG_$i "$NONE
            eval printf '%s' "\${ORG_${i}_C}" | ( read ORC ; echo $ORC |configtxgen -profile TwoOrgsChannel -outputAnchorPeersUpdate ./channel-artifacts/${ORC^}MSPanchors.tx -channelID {CHANNEL_NAME1} -asOrg ${ORC^}MSP ;)
            #eval printf '%s' "\${ORG_${i}_C}" | ( read ORC ; echo $ORC | sed -i -e "s/{ORG_${i}_C}/${ORC^}/g" ./docker-compose-cli.yaml ;)
            #eval printf '%s' "\${ORG_${i}}" | ( read ORC ; echo $ORC | sed -i -e "s/{ORG_$i}/$ORC/g" ./docker-compose-cli.yaml ;)
        else
            echo "there is an error pls check out"
        fi
    done

}

addchlorg

