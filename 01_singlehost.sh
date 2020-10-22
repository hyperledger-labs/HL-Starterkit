#!/bin/bash

function Fabsinglehost () {
    source .hlc.env 
    #source .c.env
    set +x
    echo  -e $BCOLOR"##################################################################"$NONE
    ######### Start Fabric Nodes ########
    #COMPOSE_PROJECT_NAME=automation

    echo " <<<<<<<<     Starting Fabric nodes by 2 org with 2 peers  >>>>>>>>>> "
    #echo $ORG_1_C , $ORG_2_C
    #echo $SYS_CHANNEL , $CHANNEL_NAME1
    docker swarm leave -f 2> /dev/null
    docker swarm leave -f 2> /dev/null | grep "not part of a swarm"
    sleep 1
    #docker node ls 2> /dev/null #| grep "Leader"
    if [ $? -eq 0 ]; 
    then 
      echo -e $GRCOLOR" `figlet Starting Fabric`"$NONE
      if [ "$ORD_TYPE" == "SOLO"  ]; then
        echo -e $GRCOLO" Starting SOLO Orderer "$NONE
        docker-compose -f docker-compose-cli.yaml up -d
        sleep 5 
      elif [ "$ORD_TYPE" == "RAFT" ]; then
        echo -e $GRCOLO" Starting RAFT Orderer "$NONE
        docker-compose -f docker-compose-cli.yaml -f docker-compose-orderer-etcraft.yaml up -d
        sleep 15 
      fi

    #docker-compose -f docker-compose-cli.yaml up -d

    sleep 10 
    fi

}



function fabsinhost() {
    export `cat ./.hlc.env | grep CONT`
    echo "CONT="$CONT
    if [ "$CONT" == "SINGLE" ]; then
      #Fabsinglehost  ### REM for public test
      #docker ps -a ### REM for public test
      #export CLI_NAME="$(docker ps --format='{{.Names}}' | grep cli)" ### REM for public test
      echo "CLI_NAME=$CLI_NAME" >> .hlc.env
      . 03_HLFpeernetconnect.sh
      chlcreate
      peernetconnect

    elif [ "$CONT" == "DSWARM" ]; then
      echo "Dockerswarm setup completed"
    else
      #set +x
      echo -e $RCOLOR"un recoganised CONTAINER Selection='$CONT'. exiting"$NONE
      exit 1
    fi
    res=$?
    #echo $res

}