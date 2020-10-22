#!/bin/bash
source .c.env
echo " "
echo " "


function selBCNet() {
    echo -e $GCOLOR"########  Starting custom script for Distributed Network Configuration ##########"$NONE
    echo " "
    echo " "
    #BCNET = "Please make a selection => " ; export BCNET
    echo -e $BCOLOR"Which BC Network you would like to choose..?"$NONE
    PS3="Enter your choice (must be a above number): "
    select BCNET in Hyperledger-Fabric Hyperledger-Besu Hyperledger-Sawtooth  Explorer Pre-requisties exit #
    do
       case $BCNET in
          #Hyperledger-Fabric | Hyperledger-Besu | Hyperledger-Sawtooth) 
          Hyperledger-Fabric)
             echo "Go to fabric"
             BCNET=HLF
             echo "BCNET=HLF" > .hlc.env
             HLFver
             echo ""
             echo ""
             break
          ;;
          Hyperledger-Besu)
             echo "Go to besu"
             echo -e $BCOLOR" Development Work in Progress "$NONE
             BCNET=HLB
             break
          ;;
          Hyperledger-Sawtooth)
             echo "Go to Sawtooth"
             BCNET=HLS
             echo -e $BCOLOR" Development Work in Progress "$NONE
             break
          ;;
          Explorer)
             echo "Go to Explorer, Explorer comes with any of Hyperledger framework, & by now it runs with fabric as default,
                    Run the Fabric Network first and start explorer"
             echo   "" >> 00_StartCustomHL.sh
             #sed -i -e "s/\.\/08_expstart.sh/""/g" 00_StartCustomHL.sh
             #echo  "./08_expstart.sh" >> 00_StartCustomHL.sh
             ./08  _expstart.sh
             break
          ;;
          R3-Corda)
             echo "Go to Corda"
             echo -e $BCOLOR" Development Work in Progress "$NONE
             BCNET=corda
          ;;
          Multichain)
             echo "Go to Multichain"
             echo -e $BCOLOR" Development Work in Progress "$NONE
             BCNET=MC
          ;;
          Pre-requisties)
            echo "Go to Prerequiste"
            echo -e $PCOLOR" This prerequisite is only applicable for Hyperledger Fabric 1.4x or 2.x, Kindly leverage this facility appropriately "$NONE
            source 01_prereqs.sh
            prereq14
            precheck
            FbinImage
            echo -e $PCOLOR" Fabric Prerequsties installation completed, Please rerun the script and choose HL BC Network"$NONE
            #break
            exit 1
          ;;
          exit) 

             exit 1
             
          ;;
          *) echo "ERROR: Invalid selection" 
          ;;
       esac
       
    done

}

## Just for below Swarm selection start
function DSwarmstart () {

                        . 02_swarmstart.sh
                        swarmCopyFiles
                        swarmchconfig
                        #swarmreplKeys ### REM for public access
                        swarmHost
                        swarmhostupdte
                        #dswarmInit  
                        #swarmscp ### REM for public access
                        
                        #swarmDeploy ### REM for public access
                        . 03_HLFpeernetconnect.sh
                        chlcreate
                        peernetconnect
}

function selcontainer() {
    echo
    echo
    
    echo -e $BCOLOR"How do you want to run your network?  On - [Single Host / DockerSwarm / kubernatees ] "$NONE
    #read yn
    case $yn in
        [[yY] | [yY][Ee][Ss] )
            echo -e $BCOLOR"Select your container Service..?"$NONE
            PS3="Enter your choice (must be a above number): "
            select CONTSERV in Single-host Docker-Swarm Kubernatees exit
            do
                case $CONTSERV in
                    Single-host)
                        echo "Go to Single-host"
                        export CONT=SINGLE
                        echo "CONT=SINGLE" >> .hlc.env

                        #. 03_HLFpeernetconnect.sh

                        #peernetconnect
                        
                        break
                    ;;
                    Docker-Swarm)
                        echo "Go to Docker-Swarm"
                        echo " Note : Currently Docker Swarm supports Solo order setup with fabric 1.4"
                        echo " under development for public access"
                        echo "CONT=DSWARM" >> .hlc.env
                        DSwarmstart
                        #exit 1 2 3
                        break
                    ;;
                    Kubernatees)
                        echo "Go to K8s"
                        echo " Under Development, Pls user docker swarm or singlehost"
                        exit 1
                        break
                    ;;
                    exit) 
                        break 
                    ;;
                    *) echo "ERROR: Invalid selection" 
                    ;;
                esac
            done            
            #read -p "Input your choice for Dockerswarm/K8s   (ex: "DOCKERSWARM" or "K8S") :" NETWORK_NAME
            #if [ -z $NETWORK_NAME ];then echo  "Taking default"; NETWORK_NAME="DOCKERSWARM"; else NETWORK_NAME="$NETWORK_NAME"; fi;
            #echo $NETWORK_NAME

            #./scripts/1a_firsttimeonly.sh
        ;;
        [nN] | [n|N][O|o] )
        echo ".....Skipping to docker custom files."
        ;;
        *) echo "Invalid input"
        exit 1
        ;;
    esac

}

function HLFver() {
    echo
    echo ""
    echo -e $BCOLOR"Select your Hyperledger Fabric Version..?"$NONE
    PS3="Enter your choice (must be a above number): "
    select HLFVER in 1.4.3 1.4.4 1.4.5 1.4.6 2.0 2.2 exit
    do
        case $HLFVER in
            1.4.3|1.4.4|1.4.5|1.4.6)  
                echo -e $GRCOLOR"Go to 1.4.x"$NONE             
                export IMAGE_TAG="1.4.3"
                export CAIMAGE_TAG="1.4.3"
                export DBIMAGE_TAG="0.4.15"
                echo "IMAGE_TAG=1.4.3" >> .hlc.env
                echo "CAIMAGE_TAG=1.4.3" >> .hlc.env
                echo "DBIMAGE_TAG=0.4.15" >> .hlc.env
                export CHLCAP1="1_4_3: true"
                export ORDCAP1="1_4_2: true"
                export APPCAP1="1_4_2: true"
                echo "CHLCAP1='1_4_3: true'" >> .hlc.env
                echo "ORDCAP1='1_4_2: true'" >> .hlc.env
                echo "APPCAP1='1_4_2: true'" >> .hlc.env
                rm ../bin && ln -s ./bin1.4 bin && mv bin ../

                break
            ;;
            2.0|2.2)
                echo -e $GRCOLOR"Go to 2.x"$NONE
                export IMAGE_TAG=2.2.0
                export CAIMAGE_TAG=1.4.7
                export DBIMAGE_TAG=3.1
                echo "IMAGE_TAG=2.2.0" >> .hlc.env
                echo "CAIMAGE_TAG=1.4.7" >> .hlc.env
                echo "DBIMAGE_TAG=3.1" >> .hlc.env
                export CHLCAP1="2_0: true"
                export ORDCAP1="2_0: true"
                export APPCAP1="2_0: true"
                echo "CHLCAP1='2_0: true'" >> .hlc.env
                echo "ORDCAP1='2_0: true'" >> .hlc.env
                echo "APPCAP1='2_0: true'" >> .hlc.env
                rm ../bin && ln -s ../fabric-samples2.0/bin bin && mv bin ../
                break
            ;;
            exit) 
                break 
            ;;
            *) echo "ERROR: Invalid selection" 
            ;;
        esac
    done  
}

echo $IMAGE
function HLFPrivdata () {
    echo -e $BCOLOR"Would you like to have Private data collection? [y,n]"$NONE
    read yn
    case $yn in
        [[yY] | [yY][Ee][Ss] )
            read -p "Input your choice for Dockerswarm/K8s   (ex: "DOCKERSWARM" or "K8S") :" NETWORK_NAME
            if [ -z $NETWORK_NAME ];then echo  "Taking default"; NETWORK_NAME="DOCKERSWARM"; else NETWORK_NAME="$NETWORK_NAME"; fi;
            echo $NETWORK_NAME


            #./scripts/1a_firsttimeonly.sh
        ;;
        [nN] | [n|N][O|o] )
        echo ".....Skipping to 3rd org."
        ;;
        *) echo "Invalid input"
        exit 1
        ;;
    esac
}

function Ask3rdorg () {
    echo -e $BCOLOR"Would you like to have 3rd organisation to be add ? [y,n]"$NONE
    read yn
    case $yn in
        [[yY] | [yY][Ee][Ss] )
            read -p "Input your choice for Dockerswarm/K8s   (ex: "DOCKERSWARM" or "K8S") :" NETWORK_NAME
            if [ -z $NETWORK_NAME ];then echo  "Taking default"; NETWORK_NAME="DOCKERSWARM"; else NETWORK_NAME="$NETWORK_NAME"; fi;
            echo $NETWORK_NAME

            #./scripts/1a_firsttimeonly.sh
        ;;
        [nN] | [n|N][O|o] )
        echo ".....Skipping to Docker config files."
        ;;
        *) echo "Invalid input"
        exit 1
        ;;
    esac

} 

function selconsensus() {
    echo -e $BCOLOR"Select your Consensus / Orderer  TYPE..?"$NONE
    PS3="Enter your choice (must be a above number): "
    select ORDTYPE in SOLO RAFT exit
    do
        case $ORDTYPE in
            SOLO)
                echo -e $GRCOLOR"Go to solo"$NONE
                if [ $ORDCOUNT -ge 2 ];
                    then
                        echo -e $RCOLOR "Found more Orderer service names, ignoring default  "$NONE
                        echo -e $GRCOLOR"Going to raft"$NONE
                        export ORD_TYPE="RAFT"
                        echo "ORD_TYPE=$ORD_TYPE" >> .hlc.env
                        sed -i -e "s/{ORDTYP}/etcdraft/g" configtx.yaml
                    else
                        sed -i -e "s/{ORDTYP}/solo/g" configtx.yaml
                        export ORD_TYPE="SOLO"
                        echo "ORD_TYPE=$ORD_TYPE" >> .hlc.env
                        break
                fi
                break
            ;;
            RAFT)
                echo -e $GRCOLOR"Go to raft"$NONE

                if [ $ORDCOUNT -ne 4 ];
                    then
                        echo -e $RCOLOR "Missing Orderer names, Expecting 5 Orderer names atleast  "$NONE
                        echo -e $GRCOLOR"Going  to solo"$NONE
                        export ORD_TYPE="SOLO"
                        echo "ORD_TYPE=$ORD_TYPE" >> .hlc.env
                        sed -i -e "s/{ORDTYP}/solo/g" configtx.yaml
                    else
                        export ORD_TYPE="RAFT"
                        echo "ORD_TYPE=$ORD_TYPE" >> .hlc.env
                        sed -i -e "s/{ORDTYP}/etcdraft/g" configtx.yaml
                fi
                break
            ;;
            exit) 
                break 
            ;;
            *) echo "ERROR: Invalid selection" 
            ;;
        esac
    done  

}


function AskcustomCC () {
    echo -e $BCOLOR"Would you like to have your own chaincode or Default examples ? [y,n]"$NONE
    read yn
    case $yn in
        [[yY] | [yY][Ee][Ss] )
            read -p "Input your choice for Dockerswarm/K8s   (ex: "DOCKERSWARM" or "K8S") :" NETWORK_NAME
            if [ -z $NETWORK_NAME ];then echo  "Taking default"; NETWORK_NAME="DOCKERSWARM"; else NETWORK_NAME="$NETWORK_NAME"; fi;
            echo $NETWORK_NAME

            #./scripts/1a_firsttimeonly.sh
        ;;
        [nN] | [n|N][O|o] )
        echo ".....Skipping to Docker config files."
        ;;
        *) echo "Invalid input"
        exit 1
        ;;
    esac

} 

function AskconfEmail () {
    echo -e $BCOLOR"Would you like to generate your config files and send to email ? [y,n]"$NONE
    read yn
    case $yn in
        [[yY] | [yY][Ee][Ss] )
            source .hlc.env
            read -p "Provide your email address( To Address) to send :" TOEMLADDRESS
            if [ -z $TOEMLADDRESS ];then echo  "No email address given"; read -p "Input your your email address :" TOEMLADDRESS ; else TOEMLADDRESS="$TOEMLADDRESS"; fi;
            echo $TOEMLADDRESS
            export TOEMLADDRESS=$TOEMLADDRESS
            echo "TOEMLADDRESS=$TOEMLADDRESS" >> .hlc.env
            if [ $ORDCOUNT -eq 0 -a $CONT==DSWARM ]; then 
                tar -czf $DOMAIN_NAME.tar.gz crypto-config base scripts swarm configtx.yaml crypto-config.yaml docker-compose-cli.yaml
                cp $DOMAIN_NAME.tar.gz /tmp/
                cp configfiles/emailsend.py emailsend.py
            elif [ $ORDCOUNT -eq 4 ]; then 
                tar -czf $DOMAIN_NAME.tar.gz  crypto-config base scripts configtx.yaml crypto-config.yaml docker-compose-cli.yaml docker-compose-orderer-etcraft.yaml
                cp $DOMAIN_NAME.tar.gz /tmp/
                cp configfiles/emailsend.py emailsend.py
            elif [ $ORDCOUNT -eq 0 -a $CONT==SINGLE  ]; then
                tar -czf $DOMAIN_NAME.tar.gz crypto-config base scripts configtx.yaml crypto-config.yaml docker-compose-cli.yaml
                cp $DOMAIN_NAME.tar.gz /tmp/
                cp configfiles/emailsend.py emailsend.py
            else
                echo "Error in Configuration execution"
            fi
            python3 emailsend.py

            #./scripts/1a_firsttimeonly.sh
        ;;
        [nN] | [n|N][O|o] )
        echo ".....Skipping ."
        ;;
        *) echo "Invalid input"
        exit 1
        ;;
    esac

} 
