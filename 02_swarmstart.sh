#!/bin/bash
source .c.env
echo " "
echo " "
echo -e $GCOLOR"########  Starting custom script for Docker Swarm Network Configuration ##########"$NONE
echo " "
echo " "
#cp ./configfiles/swarm-scripts/swarm-org.env ./.swarm.env
function swarmCopyFiles () { 
    echo -e $PCOLOR"#### Coping the files"$NONE
    sleep 1
    rm -rf swarm/org1 swarm/org2
    mkdir -p swarm/org1 swarm/org2
    cp ./configfiles/swarm-scripts/docker-compose-swarm-orderer-org.yaml ./swarm/org1/docker-compose-swarm-orderer.yaml
    cp ./configfiles/swarm-scripts/docker-compose-swarm-peer-org.yaml ./swarm/org1/docker-compose-swarm-peer.yaml
    cp ./configfiles/swarm-scripts/docker-compose-swarm-services-org.yaml ./swarm/org1/docker-compose-swarm-services.yaml

    cp ./configfiles/swarm-scripts/docker-compose-swarm-org2-peer-org.yaml ./swarm/org2/docker-compose-swarm-org2-peer.yaml
    cp ./configfiles/swarm-scripts/docker-compose-swarm-org2-services-org.yaml ./swarm/org2/docker-compose-swarm-org2-services.yaml
}


function swarmchconfig () {
    set +x
    source .hlc.env
    echo -e $PCOLOR"#### Updating custom configuration files"$NONE
    sleep 1
    #echo $DOMAIN_NAME

    sed -i -e "s/{DOMAIN_NAME}/$DOMAIN_NAME/g" ./swarm/org1/docker-compose-swarm-orderer.yaml
    sed -i -e "s/{DOMAIN_NAME}/$DOMAIN_NAME/g" ./swarm/org1/docker-compose-swarm-peer.yaml
    sed -i -e "s/{DOMAIN_NAME}/$DOMAIN_NAME/g" ./swarm/org1/docker-compose-swarm-services.yaml

    sed -i -e "s/{ORD_NAME0}/$ORD_NAME0/g" ./swarm/org1/docker-compose-swarm-orderer.yaml
    sed -i -e "s/{ORD_NAME0_C}/$ORD_NAME0_C/g" ./swarm/org1/docker-compose-swarm-orderer.yaml

    sed -i -e "s/{ORG_1_C}/$ORG_1_C/g" ./swarm/org1/docker-compose-swarm-peer.yaml
    sed -i -e "s/{ORG_1}/$ORG_1/g" ./swarm/org1/docker-compose-swarm-peer.yaml
    sed -i -e "s/{PEER_NAME0}/$PEER_NAME0/g" ./swarm/org1/docker-compose-swarm-peer.yaml
    sed -i -e "s/{PEER_NAME1}/$PEER_NAME1/g" ./swarm/org1/docker-compose-swarm-peer.yaml
    sed -i -e "s/{PEER_NAME2}/$PEER_NAME2/g" ./swarm/org1/docker-compose-swarm-peer.yaml

    sed -i -e "s/{PEER_NAME0}/$PEER_NAME0/g" ./swarm/org1/docker-compose-swarm-services.yaml
    sed -i -e "s/{ORG_1_C}/$ORG_1_C/g" ./swarm/org1/docker-compose-swarm-services.yaml

    sed -i -e "s/{CA_ORG1}/$CA_ORG1/g" ./swarm/org1/docker-compose-swarm-services.yaml
    sed -i -e "s/{ORG_1}/$ORG_1/g" ./swarm/org1/docker-compose-swarm-services.yaml


    sed -i -e "s/{DOMAIN_NAME}/$DOMAIN_NAME/g" ./swarm/org2/docker-compose-swarm-org2-peer.yaml
    sed -i -e "s/{DOMAIN_NAME}/$DOMAIN_NAME/g" ./swarm/org2/docker-compose-swarm-org2-services.yaml
    sed -i -e "s/{ORG_2_C}/$ORG_2_C/g" ./swarm/org2/docker-compose-swarm-org2-peer.yaml
    sed -i -e "s/{ORG_2}/$ORG_2/g" ./swarm/org2/docker-compose-swarm-org2-peer.yaml

    sed -i -e "s/{PEER_NAME0}/$PEER_NAME0/g" ./swarm/org2/docker-compose-swarm-org2-peer.yaml
    sed -i -e "s/{PEER_NAME1}/$PEER_NAME1/g" ./swarm/org2/docker-compose-swarm-org2-peer.yaml
    sed -i -e "s/{PEER_NAME2}/$PEER_NAME2/g" ./swarm/org2/docker-compose-swarm-org2-peer.yaml

    sed -i -e "s/{PEER_NAME0}/$PEER_NAME0/g" ./swarm/org2/docker-compose-swarm-org2-services.yaml
    sed -i -e "s/{ORG_2_C}/$ORG_2_C/g" ./swarm/org2/docker-compose-swarm-org2-services.yaml
    sed -i -e "s/{ORG_2}/$ORG_2/g" ./swarm/org2/docker-compose-swarm-org2-services.yaml
    sed -i -e "s/{CA_ORG2}/$CA_ORG2/g" ./swarm/org2/docker-compose-swarm-org2-services.yaml

}

function swarmreplKeys() {
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

function swarmHost() {
    echo -e $PCOLOR"#### Collecting the Host inforation for Swarm Setup "$NONE
    set +x
    touch .swarm-var.env
    
    echo -e "By default Orderer & Org1 will use same host, hence host & login details for swarm setup and file copy"
    read -p "Give your ORG_1 Hostname :" ORG1_HOSTNAME
    #if [ -z $ORG_2 ];then echo  "Taking default"; ORG_2="org2"; else ORG_2="$ORG_2"; fi;
    echo $ORG1_HOSTNAME
    
    
    ping -q -c2 $ORG1_HOSTNAME > /dev/null
    
    #ping -q -c2 $i > /dev/null
    if [ $? -eq 0 ] ;
    then
        echo -e  $GRCOLOR">>> $ORG1_HOSTNAME Pingable"$NONE 
        echo "ORG1_HOSTNAME=$ORG1_HOSTNAME" > .swarm-var.env
    else 
        echo -e $RCOLOR">>> $ORG1_HOSTNAME Not Pingable"$NONE
        read -p "Give your ORG_1 IPAddress :" ORG1_IPADDRESS
        ping -q -c2 $ORG1_IPADDRESS > /dev/null
        if [ $? -eq 0 ] 
        then 
            echo -e $GRCOLOR">>> $ORG1_IPADDRESS Pingable"$NONE
            echo "ORG1_IPADDRESS=$ORG1_IPADDRESS" > .swarm-var.env
        else
            echo -e $RCOLOR">>> $ORG1_IPADDRESS Not Pingable, Contact SYSADMIN or Check your DNS or Network Configuration"
        fi
    
    fi
    

    echo 
    echo
    read -p "Give your ORG_2 Hostname :" ORG2_HOSTNAME
    #if [ -z $ORG_2 ];then echo  "Taking default"; ORG_2="org2"; else ORG_2="$ORG_2"; fi;
    echo $ORG2_HOSTNAME

    ping -q -c2 $ORG2_HOSTNAME > /dev/null
    
    if [ $? -eq 0 ] 
    then
        echo -e  $GRCOLOR">>> $ORG2_HOSTNAME Pingable"$NONE 
        echo "ORG2_HOSTNAME=$ORG2_HOSTNAME" >> .swarm-var.env
    else
        echo -e $RCOLOR">>> $ORG2_HOSTNAME Not Pingable"$NONE
        read -p "Give your ORG_2 IPAddress :" ORG2_IPADDRESS   
        ping -q -c2 $ORG2_IPADDRESS > /dev/null
        if [ $? -eq 0 ] 
        then 
            echo -e $GRCOLOR">>> $ORG2_IPADDRESS Pingable"$NONE
            echo "ORG2_IPADDRESS=$ORG2_IPADDRESS" >> .swarm-var.env
        else
            echo -e $RCOLOR">>> $ORG2_IPADDRESS Not Pingable, Contact SYSADMIN or Check your DNS or Network Configuration"
        fi
    fi
   
    
}



function swarmhostupdte () {
    echo -e $PCOLOR"#### Updating Hostinformation for  Swarm Setup "$NONE
    set +x
    echo "SWARM_NET=fabcar_net" >> .swarm-var.env
    source .swarm-var.env

    sleep 2

    sed -i -e "s/{SWARM_NET}/$SWARM_NET/g" ./swarm/org2/docker-compose-swarm-org2-services.yaml
    sed -i -e "s/{SWARM_NET}/$SWARM_NET/g" ./swarm/org2/docker-compose-swarm-org2-peer.yaml
    sed -i -e "s/{SWARM_NET}/$SWARM_NET/g" ./swarm/org1/docker-compose-swarm-services.yaml
    sed -i -e "s/{SWARM_NET}/$SWARM_NET/g" ./swarm/org1/docker-compose-swarm-peer.yaml
    sed -i -e "s/{SWARM_NET}/$SWARM_NET/g" ./swarm/org1/docker-compose-swarm-orderer.yaml

    if [ -z $ORG1_HOSTNAME ]; then 
        sed -i -e "s/{ORG1_HOSTNAME}/$ORG1_IPADDRESS/g" ./swarm/org1/docker-compose-swarm-services.yaml
        sed -i -e "s/{ORG1_HOSTNAME}/$ORG1_IPADDRESS/g" ./swarm/org1/docker-compose-swarm-peer.yaml
        sed -i -e "s/{ORG1_HOSTNAME}/$ORG1_IPADDRESS/g" ./swarm/org1/docker-compose-swarm-orderer.yaml
    else
    sed -i -e "s/{ORG1_HOSTNAME}/$ORG1_HOSTNAME/g" ./swarm/org1/docker-compose-swarm-services.yaml
    sed -i -e "s/{ORG1_HOSTNAME}/$ORG1_HOSTNAME/g" ./swarm/org1/docker-compose-swarm-peer.yaml
    sed -i -e "s/{ORG1_HOSTNAME}/$ORG1_HOSTNAME/g" ./swarm/org1/docker-compose-swarm-orderer.yaml
    fi

    if [ -z $ORG2_HOSTNAME ]; then 
    sed -i -e "s/{ORG2_HOSTNAME}/$ORG2_IPADDRESS/g" ./swarm/org2/docker-compose-swarm-org2-peer.yaml
    sed -i -e "s/{ORG2_HOSTNAME}/$ORG2_IPADDRESS/g" ./swarm/org2/docker-compose-swarm-org2-services.yaml
    else
    sed -i -e "s/{ORG2_HOSTNAME}/$ORG2_HOSTNAME/g" ./swarm/org2/docker-compose-swarm-org2-peer.yaml
    sed -i -e "s/{ORG2_HOSTNAME}/$ORG2_HOSTNAME/g" ./swarm/org2/docker-compose-swarm-org2-services.yaml
    fi


    

}


function dswarmInit() {
    echo -e $PCOLOR"#### Initialising the Docker Swarm 1"$NONE
    echo
    sleep 1
    # init swarm (need for service command); if not created
    docker swarm leave -f  2> /dev/null
    docker node ls 2> /dev/null #| grep "Leader"
    if [ $? -ne 0 ]; then
        docker swarm init --advertise-addr ens33 > /dev/null 2>&1
    fi
    # get join token
    SWARM_TOKEN=$(docker swarm join-token -q worker)

    # get Swarm master IP (Docker for Mac xhyve VM IP)
    SWARM_MASTER=$(docker info --format "{{.Swarm.NodeAddr}}")
    echo "Swarm master IP: ${SWARM_MASTER}"
    echo -e $BLCOLOR"#### Joining the Host: $ORG2_HOSTNAME to Docker swarm Network "$NONE
    echo
    echo -e $BLCOLOR">>>>> provide the username for remote host: $ORG2_HOSTNAME "$NONE
    read -p "Username for $ORG2_HOSTNAME:" user1
    echo "userone=$user1" >> .swarm-var.env
    
    cat .swarm-var.env | grep ORG2_IPADDRESS
    if [ $? -eq 0 ]; then
        ssh $user1@$ORG2_IPADDRESS docker swarm join --token $SWARM_TOKEN ${SWARM_MASTER}:2377
    else
        ssh $user1@$ORG2_HOSTNAME docker swarm join --token $SWARM_TOKEN ${SWARM_MASTER}:2377
    fi
}
#dswarmInit

##### Copying the files for Dockerswarm to second node
function swarmscp() {
    echo -e $PCOLOR"#### Transfering the Crypro artifacts to $ORG2_HOSTNAME for Sync swarm Network "
    echo -e $PCOLOR"#### Considering the  below"
    echo -e $PCOLOR"####      1, The Pre requestie installed i.e Docker, Fabric binary, Images, go, etc."
    echo -e $PCOLOR"####      2, Following the same folder structure in remote host. i.e. ~/fabric-samples/"$NONE 
    
    echo
    set +x
    #set -o nounset -o pipefail -o errexit
    #set -o allexport
    
    source .swarm-var.env
    #set -o allexport

    if [ ! -n $ORG2_HOSTNAME ] || [ ! -n $ORG2_IPADDRESS ] ; then  
        echo -e $RCOLOR"Fix the Host 2 network and rerun the script0 "$NONE
    else 
        echo -e $PCOLOR"##### Initialising the Docker Swarm ######"$NONE
        echo
        sleep 1
        # init swarm (need for service command); if not created
        echo -e $YCOLOR"Cleaning if any previous installs of docker swarm network from current node..."$NONE
        docker swarm leave -f  2> /dev/null
        sleep 1
        NETi=`echo -e $BCOLOR"Provide a Network Interface name  for swarm initialize :"$NONE`
        read -p "$NETi" NETi1
        echo "netifone=$NETi1" >> .swarm-var.env
        docker node ls 2> /dev/null #| grep "Leader"
        if [ $? -ne 0 ]; then
            docker swarm init --advertise-addr $NETi1 > /dev/null 2>&1
            echo -e $PCOLOR"Docker Swarm Network Initialised"$NONE
            docker node ls 
        fi
        # get join token
        SWARM_TOKEN=$(docker swarm join-token -q worker)
#
        # get Swarm master IP (Docker for Mac xhyve VM IP)
        SWARM_MASTER=$(docker info --format "{{.Swarm.NodeAddr}}")
        echo "Swarm master IP: ${SWARM_MASTER}"
        echo -e $PCOLOR"#### Joining the Host: $ORG2_HOSTNAME to Docker swarm Network "$NONE
        echo
        echo -e $PCOLOR">>>>> provide the username for remote host, ensure the user has admin rights: $ORG2_HOSTNAME "$NONE
        read -p "Provide a Username for host : $ORG2_HOSTNAME to login:" user1
        echo "userone=$user1" >> .swarm-var.env
        echo -e $YCOLOR"Cleaning if any previous installs of swarm network in org $ORG2_HOSTNAME"$NONE
        #set -x
        cat .swarm-var.env | grep ORG2_IPADDRESS
        if [ $? -eq 0 ]; then
            #ssh $user1@$ORG2_IPADDRESS docker swarm leave -f   # Hash this line if its same host
            #ssh $user1@$ORG2_IPADDRESS docker swarm join --token $SWARM_TOKEN ${SWARM_MASTER}:2377
            echo
            echo
            echo -e $PCOLOR"Now Provide password for node joining"$NONE
            
            ssh $user1@$ORG2_IPADDRESS docker swarm join --token $SWARM_TOKEN ${SWARM_MASTER}:2377
            echo
            echo -e $BLCOLOR" >>> Copying the artifacts files to $ORG2_IPADDRESS "$NONE
            scp -r channel-artifacts $user1@$ORG2_IPADDRESS:~/fabric-samples/HLF_Automation/ #> /dev/null 2>&1
            if [ $? -eq 1 ]; then
            FOLD=`echo -e $BCOLOR"Enter the full path on the remote host  to copying the files ex:/home/user/fabric-samples/HL-Automation :"$NONE`
            read -p "$FOLD" FOLDER1
            ssh $user1@$ORG2_IPADDRESS mkdir -p $FOLDER1
            echo -e $BLCOLOR" >>> Copying the artifacts files to $ORG2_IPADDRESS "$NONE
            scp -r channel-artifacts $user1@$ORG2_IPADDRESS:$FOLDER1
            echo -e $BLCOLOR" >>> Copying the cryptogen files to $ORG2_IPADDRESS "$NONE
            scp -r crypto-config $user1@$ORG2_IPADDRESS:$FOLDER1
            fi
            #echo -e $BLCOLOR" >>> Copying the cryptogen files to $ORG2_IPADDRESS "$NONE
            #scp -r crypto-config $user1@$ORG2_IPADDRESS:~/fabric-samples/HLF_Automation/ #> /dev/null 2>&1
        else
            #ssh $user1@$ORG2_HOSTNAME docker swarm leave -f # Hash this line if its same host
            ssh $user1@$ORG2_HOSTNAME docker swarm join --token $SWARM_TOKEN ${SWARM_MASTER}:2377
            echo
            echo
            echo "Now Provide password for node joining"
            ssh $user1@$ORG2_HOSTNAME docker swarm join --token $SWARM_TOKEN ${SWARM_MASTER}:2377
            echo
            echo -e $BLCOLOR" >>> Copying the artifacts files to $ORG2_HOSTNAME "$NONE
            scp -r channel-artifacts $user1@$ORG2_HOSTNAME:~/fabric-samples/HLF_Automation/ #> /dev/null 2>&1
            if [ $? -eq 1 ]; then

            read -p "Enter the full path on the remote host  to copying the files ex:/home/user/fabric-samples/HL-Automation " FOLDER1
            ssh $user1@$ORG2_HOSTNAME mkdir -p $FOLDER1
            echo -e $BLCOLOR" >>> Copying the artifacts files to $ORG2_HOSTNAME "$NONE
            scp -r channel-artifacts $user1@$ORG2_HOSTNAME:$FOLDER1
            echo -e $BLCOLOR" >>> Copying the cryptogen files to $ORG2_HOSTNAME "$NONE
            scp -r crypto-config $user1@$ORG2_HOSTNAME:$FOLDER1 #> /dev/null 2>&1
            fi

        fi
        sleep 1
        

        
    fi

}


## run the stack deploy

function swarmDeploy () {
    
    if [ ! -n $ORG2_HOSTNAME ] || [ ! -n $ORG2_IPADDRESS ]
    then  
        echo -e $RCOLOR"Fix the Host 2 network and rerun the script "$NONE
         
    else 
        echo -e $PCOLOR"#### Starting Docker Stack Deploy"$NONE 
        #set -a && . .hlc.env && set +a && docker stack deploy........ #manually to start.
        source .swarm.env
        source .swarm-var.env
        docker network create --attachable --driver overlay fabcar_net
        docker node ls  

        docker stack deploy -c "$ORDERER_COMPOSE_PATH" hlf_orderer

        docker stack deploy -c "$SERVICE_ORG1_COMPOSE_PATH" hlf_services
        docker stack deploy -c "$PEER_ORG1_COMPOSE_PATH" hlf_peer

        docker stack deploy -c "$SERVICE_ORG2_COMPOSE_PATH" hlf_services
        docker stack deploy -c "$PEER_ORG2_COMPOSE_PATH" hlf_peer

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

