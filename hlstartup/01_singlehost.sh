#!/bin/bash

function Fabsinglehost () {
    
    source .env
    source .hlc.env 
    source .c.env
    echo $HL_CFG_PATH
    cd $HL_CFG_PATH
    set +x
    echo  -e $BCOLOR"##################################################################"$NONE
    ######### Start Fabric Nodes ########
    COMPOSE_PROJECT_NAME=automation

    echo " <<<<<<<<     Starting Fabric nodes by 2 org with 2 peers  >>>>>>>>>> "
    if [ $CONT == DSWARM ]; then 
    docker swarm leave -f 2> /dev/null
    docker swarm leave -f 2> /dev/null | grep "not part of a swarm"
    sleep 1
    fi
    #docker node ls 2> /dev/null #| grep "Leader"
    source $HL_CFG_PATH/bugfix.sh
    DBimagechg
    if [ $HLENV != WEB ];then
    #if [ $? -eq 0 ]; then
    echo -e $GRCOLOR" `figlet Starting Fabric`"$NONE
      if [ "$ORD_TYPE" == "SOLO"  ]; then
        echo -e $GRCOLO" Starting with SOLO Orderer "$NONE
        docker-compose -f docker-compose-cli.yaml up -d
        sleep 5 
      elif [ "$ORD_TYPE" == "RAFT" ]; then
        echo -e $GRCOLO" Starting with RAFT Orderer "$NONE
        docker-compose -f docker-compose-cli.yaml -f docker-compose-orderer-etcraft.yaml up -d
        sleep 15 
      else echo "Skipping local fabric start and generatiing the configurations..."
      fi

    sleep 10 
    fi

}



function fabsinhost() {
    source .env
    export `cat ./.hlc.env | grep CONT`
    echo "CONT="$CONT
    #set +x
    if [ "$CONT" == "SINGLE" ]; then
      Fabsinglehost
      docker ps -a
      export CLI_NAME="$(docker ps --format='{{.Names}}' | grep cli)"
      echo "CLI_NAME=$CLI_NAME" >> .hlc.env
      source $HL_CFG_PATH/hlstartup/03_HLFpeernetconnect.sh
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



function network_start () {
    source .env
    source .hlc.env
    export `cat .hlc.env | grep IMAGE_TAG`
    if [[ $IMAGE_TAG == @(1.4.3|1.4.4|1.4.5|1.4.6) ]];  then
        source $HL_CFG_PATH/hlstartup/01_singlehost.sh
        fabsinhost
    elif [[ $IMAGE_TAG == @(2.0.0|2.1.0|2.2.0) ]]; then
        source $HL_CFG_PATH/hlstartup/01_singlehost.sh
        fabsinhost
    else echo "Invalid Image selection, Not Applicable to run on selected version "
    fi
}