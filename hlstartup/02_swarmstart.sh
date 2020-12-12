#!/bin/bash
#Created by : ravinayag@gmail.com | Ravi Vasagam

source .c.env
echo " "
echo " "
echo -e $GCOLOR"########  Starting custom script for Docker Swarm Network Configuration ##########"$NONE
echo " "
echo " "

REMOT_HOME_DIR_PATH="/home/user1/fabric-samples/dockstest"


################################# Docker Swarm files ##############################3333

function swarmStart() {
    source .hlc.env
    cp ./configfiles/swarm-scripts/swarm-src.env ./.swarm.env
    echo "CHANNEL_NAME1=$CHANNEL_NAME1" >> .swarm.env
    echo "SYS_CHANNEL=$SYS_CHANNEL" >> .swarm.env
}


function swarmCopyFiles () { 
    
    echo -e $PCOLOR"#### Coping the files"$NONE
    sleep 1
    cd $HL_CFG_PATH/
    rm -rf $HL_CFG_PATH/swarm/*
    mkdir -p $HL_CFG_PATH/swarm/org1 $HL_CFG_PATH/swarm/org2
    cp ./configfiles/swarm-scripts/docker-compose-swarm-orderer-src.yaml ./swarm/org1/docker-compose-swarm-orderer.yaml
    cp ./configfiles/swarm-scripts/docker-compose-swarm-peer-src.yaml ./swarm/org1/docker-compose-swarm-peer.yaml
    cp ./configfiles/swarm-scripts/docker-compose-swarm-services-src.yaml ./swarm/org1/docker-compose-swarm-services.yaml

    cp ./configfiles/swarm-scripts/docker-compose-swarm-org2-peer-src.yaml ./swarm/org2/docker-compose-swarm-org2-peer.yaml
    cp ./configfiles/swarm-scripts/docker-compose-swarm-org2-services-src.yaml ./swarm/org2/docker-compose-swarm-org2-services.yaml
}


function swarmSEDconfig () {
    set +x
    source .hlc.env
    echo -e $PCOLOR"#### Updating custom configuration files"$NONE
    sleep 1
    #echo $DOMAIN_NAME
    cd $HL_CFG_PATH/swarm  
    for file in org1/* org2/*
    do
        sed -i -e "s/{DOMAIN_NAME}/$DOMAIN_NAME/g" $file
        sed -i -e "s/{ORD_NAME0_C}/$ORD_NAME0_C/g" $file
        sed -i -e "s/{ORD_NAME0}/$ORD_NAME0/g" $file
        sed -i -e "s/{PEER_NAME0}/$PEER_NAME0/g" $file
        sed -i -e "s/{PEER_NAME1}/$PEER_NAME1/g" $file
        sed -i -e "s/{PEER_NAME2}/$PEER_NAME2/g" $file
        sed -i -e "s/{ORG_1_C}/$ORG_1_C/g" $file
        sed -i -e "s/{ORG_1}/$ORG_1/g" $file

        sed -i -e "s/{CA_ORG1}/$CA_ORG1/g" $file
        sed -i -e "s/{ORG_1}/$ORG_1/g" $file

        sed -i -e "s/{ORG_2_C}/$ORG_2_C/g" $file
        sed -i -e "s/{ORG_2}/$ORG_2/g" $file
        sed -i -e "s/{CA_ORG2}/$CA_ORG2/g" $file
    done

}

function swarmreplKeys() {
    #########  Replacing KEY values for Docker swarm configs
    cd $HL_CFG_PATH
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
    cd $HL_CFG_PATH/
    #set +x
    #touch .swarm-var.env
    
    echo -e "By default Orderer & Org1 will deploy on First host, hence  host & login details need for swarm setup"
    read -p "Give your ORG_1 Hostname :" ORG1_HOSTNAME
    #if [ -z $ORG_2 ];then echo  "Taking default"; ORG_2="org2"; else ORG_2="$ORG_2"; fi;
    echo $ORG1_HOSTNAME

    if [ $HLENV != "WEB" ];then
        ping -q -c2 $ORG1_HOSTNAME > /dev/null
        #ping -q -c2 $i > /dev/null
        if [ $? -eq 0 ] ;then
            echo -e  $GRCOLOR">>> $ORG1_HOSTNAME Pingable"$NONE 
            echo "ORG1_HOSTNAME=$ORG1_HOSTNAME" >> .swarm.env
        else 
            echo -e $RCOLOR">>> $ORG1_HOSTNAME Not Pingable"$NONE

            read -p "Give your ORG_1 IPAddress :" ORG1_IPADDRESS
            ping -q -c2 $ORG1_IPADDRESS > /dev/null
            if [ $? -eq 0 ] ;then 
                echo -e $GRCOLOR">>> $ORG1_IPADDRESS Pingable"$NONE
                echo "ORG1_IPADDRESS=$ORG1_IPADDRESS" >> .swarm.env
            else
                echo -e $RCOLOR">>> $ORG1_IPADDRESS Not Pingable, Contact SYSADMIN or Check your DNS or Network Configuration"
            fi
        fi
    else
    
    echo "ORG1_HOSTNAME=$ORG1_HOSTNAME" >> .swarm.env
    read -p "Give your ORG_1 IPAddress :" ORG1_IPADDRESS
    echo "ORG1_IPADDRESS=$ORG1_IPADDRESS" >> .swarm.env
    fi

    echo 
    echo
    read -p "Give your ORG_2 Hostname :" ORG2_HOSTNAME
    echo $ORG2_HOSTNAME
    if [ $HLENV != "WEB" ];then
        ping -q -c2 $ORG2_HOSTNAME > /dev/null

        if [ $? -eq 0 ] ; then
            echo -e  $GRCOLOR">>> $ORG2_HOSTNAME Pingable"$NONE 
            echo "ORG2_HOSTNAME=$ORG2_HOSTNAME" >> .swarm.env
        else
            echo -e $RCOLOR">>> $ORG2_HOSTNAME Not Pingable"$NONE
            read -p "Give your ORG_2 IPAddress :" ORG2_IPADDRESS   
            ping -q -c2 $ORG2_IPADDRESS > /dev/null
            if [ $? -eq 0 ] ; then 
                echo -e $GRCOLOR">>> $ORG2_IPADDRESS Pingable"$NONE
                echo "ORG2_IPADDRESS=$ORG2_IPADDRESS" >> .swarm.env
            else
                echo -e $RCOLOR">>> $ORG2_IPADDRESS Not Pingable, Contact SYSADMIN or Check your DNS or Network Configuration"
            fi
        fi
    else
    echo "ORG2_HOSTNAME=$ORG2_HOSTNAME" >> .swarm.env
    read -p "Give your ORG_2 IPAddress :" ORG2_IPADDRESS
    echo "ORG2_IPADDRESS=$ORG2_IPADDRESS" >> .swarm.env
    fi
}

function swarmHostCond () {

    while true 
    do 
        echo -e $PCOLOR"#### Collecting the Host information for Swarm Setup (2 Hosts) "$NONE
        echo -e $RCOLOR "Note:  If not having Hostname details ready, You can skip now but you must have to update the .env file later \n to execute successfully" $NONE
        read -r -p "Confirm [Y/n] " yn
        case $yn in
            [[yY] | [yY][Ee][Ss] )
            swarmHost
            break
            ;;
            [nN] | [n|N][O|o] )
            echo "..skiping Host information"
            echo -e $RCOLOR "Remember, you not having Hostname/ipaddress now,You have to update the .env file later \n to execute sucessfully" $NONE
            #read -p "Give your ORG_1 Hostname :" ORG1_HOSTNAME
            #read -p "Give your ORG_1 IPAddress :" ORG1_IPADDRESS
            echo "ORG1_HOSTNAME=$ORG1_HOSTNAME" >> .swarm.env
            echo "ORG1_IPADDRESS=$ORG1_IPADDRESS" >> .swarm.env

            #read -p "Give your ORG_2 Hostname :" ORG2_HOSTNAME
            #read -p "Give your ORG_2 IPAddress :" ORG2_IPADDRESS
            echo "ORG2_HOSTNAME=$ORG2_HOSTNAME" >> .swarm.env
            echo "ORG2_IPADDRESS=$ORG2_IPADDRESS" >> .swarm.env
            break
            ;;
            *) echo "Invalid input"
            #exit 
            #break
            #exit 1
            ;;
        esac
    done
}



function swarmhostupdte () {
    cd $HL_CFG_PATH/
    echo -e $PCOLOR"#### Update Swarm network Setup "$NONE
    set +x
    read -p "Provide Docker SWARM-Network Name  :" SWARM_NET
    if [ -z $SWARM_NET ];then echo  "Taking default"; SWARM_NET="dswarm_net"; else SWARM_NET="$SWARM_NET"; fi;  
    echo $SWARM_NET
    echo "SWARM_NET=$SWARM_NET" >> .swarm.env
    source .swarm.env

    sleep 1
    if [ $HLENV != "WEB" ];then
        
        if [ -z $ORG1_HOSTNAME ]; then 
            for file in ./swarm/org1/*
            do
            sed -i -e "s/{SWARM_NET}/$SWARM_NET/g" $file
            sed -i -e "s/{ORG1_HOSTNAME}/$ORG1_IPADDRESS/g" $file
            done
        else
            for file in ./swarm/org1/*
            do sed -i -e "s/{ORG1_HOSTNAME}/$ORG1_HOSTNAME/g" $file 
            done
        fi
        ## for Org2
        if [ -z $ORG2_HOSTNAME ]; then 
            for file in ./swarm/org2/*
            do 
            sed -i -e "s/{SWARM_NET}/$SWARM_NET/g" $file
            sed -i -e "s/{ORG2_HOSTNAME}/$ORG2_IPADDRESS/g" $file
            done
        else
            for file in ./swarm/org2/*
            do sed -i -e "s/{ORG2_HOSTNAME}/$ORG2_HOSTNAME/g" $file
            done
        fi
    else 
        for file in ./swarm/org1/* ./swarm/org2/*
            do 
            sed -i -e "s/{SWARM_NET}/$SWARM_NET/g" $file
            sed -i -e "s/{ORG1_HOSTNAME}/$ORG1_HOSTNAME/g" $file 
            sed -i -e "s/{ORG2_HOSTNAME}/$ORG2_HOSTNAME/g" $file
        done
    fi

}


function dswarmInit() {
    echo -e $PCOLOR"#### Initialising the Docker Swarm on host 1"$NONE
    echo
    sleep 1
    echo -e $YCOLOR"Cleaning if any previous installs of docker swarm network from current node..."$NONE
    docker swarm leave -f  2> /dev/null
    sleep 1
    DNETi=`(ip route | grep default | sed -e "s/^.*dev.//" -e "s/.proto.*//")`
    NETi=`echo -e $BCOLOR"Provide a Network Interface name to initiate Swarm Network :"$NONE`
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
    echo -e $BLCOLOR"#### Joining the Host: $ORG2_HOSTNAME to Docker swarm Network "$NONE
    echo
    echo -e $PCOLOR">>>>> provide the username for Remote host2, ensure the user has admin rights: $ORG2_HOSTNAME "$NONE
    read -p "Provide a Username for host: $ORG2_HOSTNAME to login:" user1
    echo "userone=$user1" >> .swarm.env
    echo -e $YCOLOR"Cleaning if any previous installs of swarm network in host: $ORG2_HOSTNAME"$NONE
    if [ $ORG1_HOSTNAME == $ORG2_HOSTNAME ]; then
        echo "Since the both hosts are same,skipping Swam Join on second node."
    else 
        ssh $user1@$ORG2_HOSTNAME docker swarm leave -f #Hash this line if its same host
    fi
    sleep 2
    # Connecting 2nd host
    if [ $ORG1_IPADDRESS != $ORG2_IPADDRESS ]; then
        ssh $user1@$ORG2_IPADDRESS docker swarm join --token $SWARM_TOKEN ${SWARM_MASTER}:2377
    else
        echo "Since the both hosts are same,skipping Swam Join on second node."
    fi
}


##### Copying the files for Dockerswarm to second node
function swarmHostscp() {

    source .swarm.env
    echo -e $PCOLOR"#### Transfering the Crypro artifacts to $ORG2_HOSTNAME for Sync swarm Network "
    echo -e $PCOLOR"#### Considering the  below"
    echo -e $PCOLOR"####      1, The Pre requestie installed i.e Docker, Fabric binary, Images, go, etc."
    echo -e $PCOLOR"####      2, Following the same folder structure in remote host. i.e. ~/fabric-samples/"$NONE 
    #set +x
    #set -o nounset -o pipefail -o errexit
    #set -o allexport

    if [ $HLENV != "WEB" ];then
        if [ ! -n $ORG2_HOSTNAME ] || [ ! -n $ORG2_IPADDRESS ] ; then  
            echo -e $RCOLOR"Fix the Host 2 network and rerun the script0 "$NONE
        else 
            # echo -e $PCOLOR"##### Initialising the Docker Swarm ######"$NONE
            # echo
            # sleep 1
            # # init swarm (need for service command); if not created
            # echo -e $YCOLOR"Cleaning if any previous installs of docker swarm network from current node..."$NONE
            # docker swarm leave -f  2> /dev/null
            # sleep 1
            # DNETi=`(ip route | grep default | sed -e "s/^.*dev.//" -e "s/.proto.*//")`
            # NETi=`echo -e $BCOLOR"Provide a Network Interface name to initiate Swarm Network :"$NONE`
            # echo "Interface name is required if the  system has multiple Network interfaces, else will take default interface"
            # read -p "$NETi" NETi1
            # if [ -z $NETi1 ];then echo  "Taking default"; NETi1="$DNETi"; else NETi1="$NETi1"; fi;
            # echo $NETi1
            # echo "netIFone=$NETi1" >> .swarm.env


            # docker node ls 2> /dev/null #| grep "Leader"
            # if [ $? -ne 0 ]; then
            #     docker swarm init --advertise-addr $NETi1 > /dev/null 2>&1
            #     echo -e $PCOLOR"Docker Swarm Network Initialised"$NONE
            #     docker node ls 
            # fi

            # # get join token
            # SWARM_TOKEN=$(docker swarm join-token -q worker)

            # # get Swarm master IP (Docker for Mac xhyve VM IP)
            # SWARM_MASTER=$(docker info --format "{{.Swarm.NodeAddr}}")
            # echo "Swarm master IP: ${SWARM_MASTER}"
            # echo -e $PCOLOR"#### Joining the Host: $ORG2_HOSTNAME to Docker swarm Network "$NONE
            # echo
            # echo -e $PCOLOR">>>>> provide the username for Remote host2, ensure the user has admin rights: $ORG2_HOSTNAME "$NONE
            # read -p "Provide a Username for host: $ORG2_HOSTNAME to login:" user1
            # echo "userone=$user1" >> .swarm.env
            # echo -e $YCOLOR"Cleaning if any previous installs of swarm network in host: $ORG2_HOSTNAME"$NONE
            # #set -x
            if [ $ORG1_HOSTNAME == $ORG2_HOSTNAME ]; then
                    #ssh $user1@$ORG2_HOSTNAME docker swarm leave -f # Hash this line if its same host
                    #ssh $user1@$ORG2_HOSTNAME docker swarm join --token $SWARM_TOKEN ${SWARM_MASTER}:2377
                    echo
                    echo
                    #echo "Now Provide password for  host 2 joining"
                    #ssh $user1@$ORG2_HOSTNAME docker swarm join --token $SWARM_TOKEN ${SWARM_MASTER}:2377
                    echo
                    sleep 2
                    echo -e $BLCOLOR" >>> Copying the artifacts/cryptogen  files to $ORG2_HOSTNAME "$NONE
                    #scp -r channel-artifacts $user1@$ORG2_HOSTNAME:~/fabric-samples/HLF_Automation/ #> /dev/null 2>&1
                    #if [ $? -eq 1 ]; then
                        FOLD=`echo -e $BCOLOR"Enter the full path on the remote host  to copying the files ex:/home/user/fabric-samples/HL-Automation :"$NONE`
                        read -p "$FOLD" REMOT_HOME_DIR_PATH
                        echo "REMOT_HOME_DIR_PATH=$REMOT_HOME_DIR_PATH" >> .swarm.env
                        ssh $user1@$ORG2_HOSTNAME mkdir -p $REMOT_HOME_DIR_PATH
                        echo "Directory path created, enter password again for copying files.."
                        scp -r channel-artifacts crypto-config $user1@$ORG2_HOSTNAME:$REMOT_HOME_DIR_PATH

                    #fi
            else
                cat .swarm.env | grep ORG2_IPADDRESS
                if [ $? -eq 0 ]; then
                #ssh $user1@$ORG2_IPADDRESS docker swarm leave -f   # Hash this line if its same host
                #ssh $user1@$ORG2_IPADDRESS docker swarm join --token $SWARM_TOKEN ${SWARM_MASTER}:2377
                # echo
                # echo
                #echo -e $PCOLOR"Now Provide password for user name $user1 on  host2: $ORG2_HOSTNAME to join the SWARM network"$NONE
                #ssh $user1@$ORG2_IPADDRESS docker swarm join --token $SWARM_TOKEN ${SWARM_MASTER}:2377
                #echo
                #echo -e $BLCOLOR" >>> Copying the artifacts files to $ORG2_IPADDRESS "$NONE
                #scp -r channel-artifacts $user1@$ORG2_IPADDRESS:$REMOT_HOME_DIR_PATH #> /dev/null 2>&1
                #if [ $? -eq 1 ]; then
                FOLD=`echo -e $BCOLOR"Enter the full path on the remote host  to copying the files ex:/home/user/fabric-samples/HL-Automation :"$NONE`
                read -p "$FOLD" REMOT_HOME_DIR_PATH
                echo "REMOT_HOME_DIR_PATH=$REMOT_HOME_DIR_PATH" >> .swarm.env
                ssh $user1@$ORG2_IPADDRESS mkdir -p $REMOT_HOME_DIR_PATH
                echo "Directory path created, enter password again for copying files.."
                echo -e $BLCOLOR" >>> Copying the artifacts/cryptogen files to $ORG2_IPADDRESS "$NONE
                scp -r channel-artifacts crypto-config $user1@$ORG2_IPADDRESS:$REMOT_HOME_DIR_PATH
                #fi
                #echo -e $BLCOLOR" >>> Copying the cryptogen files to $ORG2_IPADDRESS "$NONE
                #scp -r crypto-config $user1@$ORG2_IPADDRESS:~/fabric-samples/HLF_Automation/ #> /dev/null 2>&1
                fi
            fi
            sleep 1
        fi
    else 
        echo "this is not web"
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
        #source .swarm-var.env
        docker network create --attachable --driver overlay $SWARM_NET
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


function dswarmCAcheck  () {
    if [ $CACOUNT -lt 2 ] ; then
        for ((i=2; i<= 2; i++))   
            do
                echo " Since CA's < 3, Collecting requirements..."
                read -p "Give your CA name(default: ca$i) : " CA_ORG
                if [ -z $CA_ORG ];
                then 
                    echo  "Taking default : ca$i"
                    echo "CA_ORG$i=ca$i" >> .hlc.env
                    export CA_ORG$i="ca$i"
                else 
                    echo "Given Name :  $CA_ORG"
                    echo "CA_ORG$i=$CA_ORG" >> .hlc.env
                    export CA_ORG$i=$CA_ORG

                fi;
        done
    fi
}

