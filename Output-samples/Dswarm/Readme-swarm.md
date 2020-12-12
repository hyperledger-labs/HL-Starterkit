###############################################
#Please run this below

#$ source Readme-k8s.md
###############################################








source .env
source .c.env
source .hlc.env
source .swarm.env

echo
echo -e $COLOR "Kindly make note before starting DockerSwarm deployments "$NONE
echo -e $BLCOLOR" Ensure you installed prereqs on 2nd host, if not installed, you have run on single node with SAME Host name & SAME IP Address"$NONE
echo -e $YCOLOR" As prerequestie for 2 Node DockerSwarm Setup, you need to install prereq and download the binaries and images on remote node(host2)  "$NONE

echo ""

echo  " Execute with below commands in sequence"
echo -e $GRCOLOR "ex :  \n dswarmstart \n dswarmInit \n dswarmDeploy \n dswarmCHLcreate \n dswarmPeerConnect \n dswarmexplorer \n dswarmStop " $NONE






export CLI_NAME="$(docker ps --format='{{.Names}}' | grep _cli)"

function dswarmstart () {
    export `cat .hlc.env | grep ORD_TYPE`
    if [ "$ORD_TYPE" == "SOLO"  ]; then
      echo "running ./scripts/1a_firsttimeonly.sh"
      rm -rf crypto-config
      mkdir -p channel-artifacts
      ./scripts/1a_firsttimeonly.sh
      dswarmreplKeys
      echo -e $GRCOLOR" `figlet Starting Fabric - SWARM`"$NONE
      echo -e $GRCOLO" Starting with SOLO Orderer "$NONE
    fi

}

function dswarmreplKeys() {
    #########  Replacing KEY values for Docker swarm configs
    
    echo -e $PCOLOR"#### Updating SK Keys"$NONE
    sleep 1
    set +x
    ORG1KEY="$(ls crypto-config/peerOrganizations/$ORG_1.$DOMAIN_NAME/ca/ | grep 'sk$')"
    sed -i -e "s/{ORG1-CA-KEY}/$ORG1KEY/g" ./swarm/org1/docker-compose-swarm-services.yaml
    ORG1TLSKEY="$(ls crypto-config/peerOrganizations/$ORG_1.$DOMAIN_NAME/tlsca/ | grep 'sk$')"
    sed -i -e "s/{ORG1-TLSCA-KEY}/$ORG1TLSKEY/g" ./swarm/org1/docker-compose-swarm-services.yaml


    ORG2KEY="$(ls crypto-config/peerOrganizations/$ORG_2.$DOMAIN_NAME/ca/ | grep 'sk$')"
    sed -i -e "s/{ORG2-CA-KEY}/$ORG2KEY/g" ./swarm/org2/docker-compose-swarm-org2-services.yaml
    ORG2TLSKEY="$(ls crypto-config/peerOrganizations/$ORG_2.$DOMAIN_NAME/tlsca/ | grep 'sk$')"
    sed -i -e "s/{ORG2-TLSCA-KEY}/$ORG2TLSKEY/g" ./swarm/org2/docker-compose-swarm-org2-services.yaml


}





function dswarmscp() {
    echo -e $PCOLOR"#### Transfering the Crypro artifacts to $ORG2_HOSTNAME for Sync swarm Network "
    echo -e $PCOLOR"#### Considering the  below"
    echo -e $PCOLOR"####      1, The Pre requestie installed i.e Docker, Fabric binary, Images, go, etc."
    echo -e $PCOLOR"####      2, Following the same folder structure in remote host. i.e. ~/fabric-samples/"$NONE 
    
    echo

    source .swarm.env 
            echo -e $LBCOLOR " >>> Copying the artifacts/cryptogen  files to $ORG2_HOSTNAME " $NONE
            FOLD=`echo -e $BCOLOR"Enter the full path on the remote host  to copying the files ex:/home/user/fabric-samples/HL-Automation :"$NONE`
            read -p "$FOLD" REMOT_HOME_DIR_PATH
            echo "REMOT_HOME_DIR_PATH=$REMOT_HOME_DIR_PATH" >> .swarm.env

            if [ $ORG1_HOSTNAME != $ORG2_HOSTNAME ]; then
                    echo "Connecting with Hostname..."
                    ssh $user1@$ORG2_HOSTNAME mkdir -p $REMOT_HOME_DIR_PATH
                    echo "Directory path created, enter password again for copying files.."
                    scp -r channel-artifacts crypto-config $user1@$ORG2_HOSTNAME:$REMOT_HOME_DIR_PATH
            else
                echo "..skipping Remote filecopy on second node, Since the both hosts names are same"
                echo "Do Not execute IPAddress step" > /tmp/dnd
            fi

            Connecting by IP address
            cat /tmp/dnd | grep 'Do Not execute IPAddress step' &> /dev/null
            if [ $? == 0 ]; then
               echo "..skipping Remote filecopy on second nodem, Since the both host IPs are same,"
            else
                echo "Connecting with ipaddress..."
                ssh $user1@$ORG2_IPADDRESS mkdir -p $REMOT_HOME_DIR_PATH
                echo "Directory path created, enter password again for copying files.."
                scp -r channel-artifacts crypto-config $user1@$ORG2_IPADDRESS:$REMOT_HOME_DIR_PATH     
            fi
            
            #if [ $ORG1_IPADDRESS != $ORG2_IPADDRESS ]; then
            #            ssh $user1@$ORG2_IPADDRESS mkdir -p $REMOT_HOME_DIR_PATH
            #            echo "Directory path created, enter password again for copying files.."
            #            scp -r channel-artifacts crypto-config $user1@$ORG2_IPADDRESS:$REMOT_HOME_DIR_PATH
            #else
            #    echo "..skipping Swam Join on second node, Since the both host IPs are same,"
            #fi

            sleep 1        
}


function dswarmInit() {
    echo -e $PCOLOR"#### Initialising the Docker Swarm on host 1"$NONE
    echo
    sleep 1
    echo -e $YCOLOR"Cleaning if any previous installs of docker swarm network from current node..."$NONE
    docker swarm leave -f  2> /dev/null
    sleep 1
    export DNETi=`ip route | grep default | sed -e "s/^.*dev.//" -e "s/.proto.*//"`
    export NETi=`echo -e $BCOLOR"Provide a Network Interface name to initiate Swarm Network :"$NONE`
    echo "Interface name is required if the  system has multiple Network interfaces, else will take default interface"
    read -p "$NETi" NETi1
    if [ -z $NETi1 ];then echo  "Taking default"; NETi1="$DNETi"; else NETi1="$NETi1"; fi;
    echo $NETi1
    echo "netIFone=$NETi1" >> .swarm.env

    docker node ls 2> /dev/null #| grep "Leader"
    if [ $? -ne 0 ]; then
        docker swarm init --advertise-addr $NETi1 > /dev/null 2>&1
        echo -e $PCOLOR"Docker Swarm Network Initialised"$NONE
        docker node ls 
    fi

    # Get token to join
    SWARM_TOKEN=$(docker swarm join-token -q worker)

    # Get Swarm master IP 
    SWARM_MASTER=$(docker info --format "{{.Swarm.NodeAddr}}")
    echo "Swarm master IP: ${SWARM_MASTER}"
    echo
    # cleaning on 2nd host
    echo -e $LBCOLOR"#### Joining the Host: $ORG2_HOSTNAME to Docker swarm Network "$NONE
    echo
    echo -e $PCOLOR">>>>> provide the username for Remote host2, ensure the user has admin rights: $ORG2_HOSTNAME "$NONE
    read -p "Provide a Username for host: $ORG2_HOSTNAME to login:" user1
    echo "userone=$user1" >> .swarm.env
    echo -e $YCOLOR"Cleaning if any previous installs of swarm network in host: $ORG2_HOSTNAME"$NONE
    if [ $ORG1_HOSTNAME == $ORG2_HOSTNAME ]; then
        echo "..skipping Swam Join on second node,Since the both hosts names are same."
    else
        echo "Connecting with Hostname..."
        ssh $user1@$ORG2_HOSTNAME docker swarm leave -f #Hash this line if its same host
        if [ $? != 0 ]; then ssh $user1@$ORG2_IPADDRESS docker swarm leave -f; fi
    fi
    sleep 2
    # Connecting 2nd host
    if [ $ORG1_IPADDRESS != $ORG2_IPADDRESS ]; then
        echo "Connecting with ipaddress..."
        ssh $user1@$ORG2_IPADDRESS docker swarm join --token $SWARM_TOKEN ${SWARM_MASTER}:2377
    else
        echo "..skipping Swam Join on second node, Since the both host IPs are same."
    fi
    dswarmscp
}

function dswarmDBimagechg (){
    #source .env
    #source .hlc.env
    export `cat .hlc.env | grep DBIMAGE_TAG`
    if [ $DBIMAGE_TAG == 0.4.15 ];then
    docker pull hyperledger/fabric-couchdb:0.4.15
    docker tag hyperledger/fabric-couchdb:0.4.15 couchdb:0.4.15
    #sed -i -e "s/COUCHDB_USER=admin/COUCHDB_USER=/g" $HL_CFG_PATH/docker-compose-cli.yaml
    #sed -i -e "s/COUCHDB_PASSWORD=password/COUCHDB_PASSWORD=/g" $HL_CFG_PATH/docker-compose-cli.yaml
    fi
}



function dswarmDeploy () {
    dswarmDBimagechg
    export `cat .hlc.env | grep IMAGE_TAG`
    if [ ! -n $ORG2_HOSTNAME ] || [ ! -n $ORG2_IPADDRESS ]
    then  
        echo -e $RCOLOR"Fix the Host 2 network and rerun the script "$NONE
         
    else 
        echo -e $PCOLOR"#### Starting Docker Stack Deploy"$NONE 
        #set -a && . .hlc.env && set +a && docker stack deploy........ #manually to start.
        source .swarm.env
        #source .swarm-var.env
        docker network create --attachable --driver overlay $SWARM_NET
        docker node ls  

        docker stack deploy -c ./swarm/org1/docker-compose-swarm-orderer.yaml hlf_orderer

        docker stack deploy -c swarm/org1/docker-compose-swarm-services.yaml hlf_services
        docker stack deploy -c swarm/org1/docker-compose-swarm-peer.yaml hlf_peer

        docker stack deploy -c swarm/org2/docker-compose-swarm-org2-services.yaml hlf_services
        docker stack deploy -c swarm/org2/docker-compose-swarm-org2-peer.yaml hlf_peer

        echo -e $BLCOLOR">>> listing the services"$NONE
        sleep 7
        docker service ls
        sleep 3
        docker stack ps hlf_services
        sleep 3
        export CLI_NAME="$(docker ps --format='{{.Names}}' | grep _cli)"
        echo "CLI_NAME=$CLI_NAME" >> .hlc.env
    fi
}


function dswarmStop () {

    docker stack rm hlf_services
    docker stack rm hlf_peer
    docker stack rm hlf_orderer
    

}


function dswarmCHLcreate () {
  
  export CLI_NAME="$(docker ps --format='{{.Names}}' | grep cli)"
  echo "CLI_NAME=$CLI_NAME" >> .hlc.env
  ./scripts/2_channelcrte.sh

}



function dswarmPeerConnect () {
    
    sleep 1
    docker exec $CLI_NAME bash ./scripts/2a_peer0.org1_chljoin.sh
    sleep 3
    
    docker exec $CLI_NAME bash ./scripts/3_peer1.org1_chljoin.sh
    sleep 2

    docker exec $CLI_NAME bash ./scripts/4_peer0.org2_chljoin.sh
    sleep 1
  
    docker exec $CLI_NAME bash ./scripts/5_peer1.org2_chljoin.sh
    sleep 1

    docker exec $CLI_NAME bash ./scripts/6_anchorpeerorg1.sh
    sleep 2

    docker exec $CLI_NAME bash ./scripts/7_anchorpeerorg2.sh
    sleep 2

    docker exec $CLI_NAME bash ./scripts/8_ccinstallpeer0.org1.sh
    sleep 2

    docker exec $CLI_NAME bash ./scripts/9_ccinstallpeer0.org2.sh
    sleep 2
    
    if [[ $IMAGE_TAG != @(2.0.0|2.1.0|2.2.0) ]];
    then 
        docker tag hyperledger/fabric-ccenv:1.4.3 hyperledger/fabric-ccenv:latest   #Bug Fix

        docker exec $CLI_NAME bash ./scripts/10_ccinstantiate.org2.sh
        sleep 2

        docker exec $CLI_NAME bash ./scripts/11_ccquery.org1.sh
        sleep 1

        docker exec $CLI_NAME bash ./scripts/12_ccinvoketransfer.sh
        sleep 3

        docker exec $CLI_NAME bash ./scripts/13_ccquery.org2.sh
    else 
        echo "...skiping to fab 2.0"
        docker tag hyperledger/fabric-ccenv:2.2 hyperledger/fabric-ccenv:latest    ## Bug fix in 2.2
        sleep 2
        docker exec $CLI_NAME bash ./scripts/9a_lcccapprovefab2.0.sh
        sleep 2
        docker exec $CLI_NAME bash ./scripts/10a_lccc-commitfab2.0.sh

    fi
    echo ">>>>>  Peerconnect done with two org setup   <<<<< "
}




function dswarmexplorer () {
    source .swarm.env
    mkdir -p explorer/wallet
    
    sed -i -e "s/{ORG1_HOSTNAME}/$ORG1_HOSTNAME/g" ./explorer/docker-compose-explorer.yml
    cp -r crypto-config/*  explorer/examples/net1/crypto/
    EXPORG1KEY="$(ls crypto-config/peerOrganizations/$ORG_1.$DOMAIN_NAME/users/Admin@$ORG_1.$DOMAIN_NAME/msp/keystore/ | grep 'sk$')"
    sed -i -e "s/{ORG1-MSP-KEY}/$EXPORG1KEY/g" ./explorer/examples/net1/connection-profile/first-network.json
    docker stack deploy -c ./explorer/docker-compose-explorer.yml hlf_services

}