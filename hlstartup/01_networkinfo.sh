#!/bin/bash
#Created by : ravinayag@gmail.com | Ravi Vasagam
source .env
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
    select BCNET in Hyperledger-Fabric Hyperledger-Besu Hyperledger-Sawtooth  Explorer Pre-requisties-Fabric exit #
    do
       case $BCNET in
          #Hyperledger-Fabric | Hyperledger-Besu | Hyperledger-Sawtooth) 
          Hyperledger-Fabric)
             echo "Go to fabric"
             BCNET=HLFAB
             echo "BCNET=HLFAB" >> .hlc.env
             HLFver
             echo ""
             echo ""
             break
          ;;
          Hyperledger-Besu)
             echo "Go to besu"
             echo -e $RCOLOR" Development Work in Progress "$NONE
             BCNET=HLBESU
             echo "BCNET=HLBESU" >> .hlc.env
             sleep 3
             exit 1
             break
          ;;
          Hyperledger-Sawtooth)
             echo "Go to Sawtooth"
             BCNET=HLSAWT
             echo "BCNET=HLSAWT" >> .hlc.env
             echo -e $RCOLOR" Development Work in Progress "$NONE
             sleep 3
             exit 1
             break
             
          ;;
          Explorer)
             echo "Go to Explorer"
             echo "BCNET=FABEXPLOR" >> .hlc.env
             source $HL_CFG_PATH/.hlc.env

             echo "HL Explorer works with Fabric, Besu frame works and its tested with fabric only,
                    You can select fabric and go through the configurations to genereate explorer configs"
             echo   "" >> 00_StartCustomHL.sh
             #sed -i -e "s/\.\/08_expstart.sh/""/g" 00_StartCustomHL.sh
             #echo  "./08_expstart.sh" >> 00_StartCustomHL.sh
             if [ $HLENV != "WEB" ];then
             source $HL_CFG_PATH/hlstartup/./08_expstart.sh
             #explorerConfig
             #startexplore
             else 
             echo "Skipped local fabric start ."
             echo "Please select the Fabric network first and provide your custom names to generate explorer configuration "
             
             fi
             exit 1
             break
          ;;
          Pre-requisties-Fabric)
            echo "Go to Prerequiste"
            echo "BCNET=FABPREREQ" >> .hlc.env
            source $HL_CFG_PATH/.hlc.env
            echo -e $PCOLOR" This prerequisite is only applicable for Hyperledger Fabric 1.4x or 2.x, Kindly leverage this facility appropriately "$NONE
            if [ $HLENV != "WEB" ];then
            source $HL_CFG_PATH/hlstartup/01_prereqs.sh
            prereq14
            precheck
            FbinImage
            echo -e $PCOLOR" Fabric Prerequsties installation completed, Please rerun the script and choose HL BC Network"$NONE
            else echo "Skipping local fabric start and generatiing the configurations..."
            source $HL_CFG_PATH/hlstartup/01_networkinfo.sh
            prereqemail
            exit 1
            fi
            exit 1
            break
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


function selvirtcontainer() {
    echo
    echo

    source .hlc.env
    cd $HL_CFG_PATH
    echo -e $BCOLOR"How do you want to run your network?  On - [Single Host / DockerSwarm / kubernatees ] "$NONE

            echo -e $BCOLOR"Select your container Service..?"$NONE
            PS3="Enter your choice (must be a above number): "
            select CONTSERV in Single-host Docker-Swarm Kubernatees exit
            do
                case $CONTSERV in
                    Single-host)
                        echo "Go to Single-host"
                        export CONT=SINGLE
                        echo "CONT=SINGLE" >> .hlc.env
                        source $HL_CFG_PATH/hlstartup/04_Fabsamplecc.sh
                        selccode                        
                        if [ $HLENV != WEB ];then
                            source $HL_CFG_PATH/hlstartup/01_singlehost.sh
                            network_start
                        else 
                        echo "Skipping local fabric start and generatiing the configurations..."
                        source $HL_CFG_PATH/hlstartup/03_HLFpeernetconnect.sh
                        cd $HL_CFG_PATH/scripts
                        SEDpeernetconnect #updating the Values
                        source $HL_CFG_PATH/hlstartup/08_expstart.sh
                        cd ..
                        explorerConfig
                        startexplore
                        

                        fi
                        break
                    ;;
                    Docker-Swarm)
                        echo "Go to Docker-Swarm"
                        echo "CONT=DSWARM" >> .hlc.env
                        export CONT=DSWARM
                        echo " Note : Currently Docker Swarm supports Solo order setup with fabric 1.4"
                        echo "Ignore errors for not pingble hostnames/Ipaddres"
                        source $HL_CFG_PATH/hlstartup/02_swarmstart.sh
                        if [ $HLENV != "WEB" ];then
                            dswarmCAcheck
                            swarmStart
                            swarmCopyFiles
                            swarmSEDconfig
                            swarmreplKeys
                            swarmHost
                            swarmhostupdte
                            #dswarmInit
                            swarmscp

                            swarmDeploy
                            source $HL_CFG_PATH/hlstartup/03_HLFpeernetconnect.sh
                            chlcreate
                            peernetconnect
                        else 
                            echo ""
                            dswarmCAcheck
                            source $HL_CFG_PATH/hlstartup/04_Fabsamplecc.sh
                            selccode  
                            swarmStart
                            swarmCopyFiles
                            swarmSEDconfig
                            swarmHostCond
                            swarmhostupdte
                            source $HL_CFG_PATH/hlstartup/03_HLFpeernetconnect.sh
                            cd $HL_CFG_PATH/scripts
                            SEDpeernetconnect #updating the Values
                            source $HL_CFG_PATH/hlstartup/08_expstart.sh
                            cd ..
                            explorerConfig
                            startexplore
                        fi
                        #exit 1
                        break
                    ;;
                    Kubernatees)
                        echo "Go to K8s"
                        echo "CONT=KUBER" >> .hlc.env
                        
                        export CONT=KUBER
                        echo "Currently its working on marbles CC as external Container,However im working other chaincodes aswell for the update."
                        source $HL_CFG_PATH/hlstartup/04_Fabsamplecc.sh
                        #selccode                        
                        if [ $HLENV != WEB ];then
                        ./configfiles/k8s/k8start start
                        else echo "Skipping local fabric start and generatiing the configurations..."
                        source $HL_CFG_PATH/configfiles/k8s/k8s.sh
                        echo "HMEDIR=" >> .k8s.env

                        k8sORDcheck || true
                        k8sCAcheck || true
                        k8sNS
                        verifyDir
                        k8sCPfiles
                        k8sCONFTXCRYPTO
                        k8sSEDreplexe #updating the Values
                        cd $HL_CFG_PATH/
                        k8sexplorer
                        cp $HL_CFG_PATH/.*.env k8s/k8scripts/
                        
                        AskconfEmail
                        fi
                        
                        exit 1
                        break
                    ;;
                    exit) 
                        break 
                    ;;
                    *) 
                    echo "ERROR: Invalid selection" 
                    ;;
                esac
            done            


}

function HLFver() {
    echo
    echo ""
    echo -e $BCOLOR"Select your Hyperledger Fabric Version..?"$NONE
    PS3="Enter your choice (must be a above number): "
    select HLFVER in 1.4.3 1.4.4 1.4.5 1.4.6 2.0.0 2.1.0 2.2.0 exit
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
            2.0.0|2.1.0|2.2.0)
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
 

function AskconfEmail () {
    echo -e $BCOLOR"Would you like to generate your config files and send to email ? [y,n]"$NONE
    read yn
    cd $HL_CFG_PATH
    case $yn in
        [[yY] | [yY][Ee][Ss] )
            source .hlc.env
            read -p "Provide your email address( To Address) to send :" TOEMLADDRESS
            if [ -z $TOEMLADDRESS ];then echo  "No email address given"; read -p "Input your your email address :" TOEMLADDRESS ; else TOEMLADDRESS="$TOEMLADDRESS"; fi;
            echo $TOEMLADDRESS

            export TOEMLADDRESS=$TOEMLADDRESS
            echo "TOEMLADDRESS=$TOEMLADDRESS" >> .hlc.env
            echo "TOEMLADDRESS=$TOEMLADDRESS"  >> ./configfiles/emailssent
            date >> ./configfiles/emailssent
            yes 2>/dev/null | cp hlstartup/01_prereqs.sh 01_prereqs.sh
            cp ./configfiles/web/web-fab-start-single.sh web-fab-start-single.sh
            if [ "$ORDCOUNT" -eq 0 -a "$CONT" = "SINGLE" ]; then 
                tar -czf $DOMAIN_NAME.tar.gz .c.env .hlc.env .env Readme-SingleHost.md base scripts configtx.yaml crypto-config.yaml docker-compose-cli.yaml web-fab-start-single.sh explorer 01_prereqs.sh
            elif [ "$ORDCOUNT" -ge 1 -a "$CONT" = "SINGLE" ]; then 
                tar -czf $DOMAIN_NAME.tar.gz .c.env .hlc.env .env Readme-SingleHost.md base scripts configtx.yaml crypto-config.yaml docker-compose-cli.yaml docker-compose-orderer-etcraft.yaml web-fab-start-single.sh explorer 01_prereqs.sh
            elif [ "$CONT" = "DSWARM"  ]; then
                tar -czf $DOMAIN_NAME.tar.gz .c.env .hlc.env .env Readme-swarm.md scripts configtx.yaml crypto-config.yaml swarm .swarm.env explorer 01_prereqs.sh
            elif [ "$CONT" = "KUBER"  ]; then
                tar -czf $DOMAIN_NAME.tar.gz .c.env .hlc.env .env .k8s.env Readme-k8s.md configtx.yaml scripts/1a_firsttimeonly.sh crypto-config.yaml k8s explorer 01_prereqs.sh
            else
                echo "Error in Configuration execution"
            fi
            yes | cp  $DOMAIN_NAME.tar.gz /tmp/
            yes | cp configfiles/emailsend.py emailsend.py
            python3 emailsend.py
        ;;
        [nN] | [n|N][O|o] )
        echo ".....Skipping ."
        ;;
        *) echo "Invalid input"
        exit 1
        ;;
    esac

} 


function prereqemail() {
    echo -e $BCOLOR"Would you like to generate and send to email address? [y,n]"$NONE
    read yn
    cd $HL_CFG_PATH
    case $yn in
        [[yY] | [yY][Ee][Ss] )
            source .hlc.env
            read -p "Provide your email address( To Address) to send :" TOEMLADDRESS
            if [ -z $TOEMLADDRESS ];then echo  "No email address given"; read -p "Input your your email address :" TOEMLADDRESS ; else TOEMLADDRESS="$TOEMLADDRESS"; fi;
            echo $TOEMLADDRESS
            export TOEMLADDRESS=$TOEMLADDRESS
            echo "TOEMLADDRESS=$TOEMLADDRESS" >> .hlc.env
            echo "TOEMLADDRESS=$TOEMLADDRESS"  >> ./configfiles/emailssent
            date >> ./configfiles/emailssent
            if [ $BCNET==FABPREREQ ]; then
                yes 2>/dev/null | cp hlstartup/01_prereqs.sh 01_prereqs.sh 
                tar -czf prereq.com.tar.gz 01_prereqs.sh 
                echo "DOMAIN_NAME=prereq.com" >> .hlc.env
                yes 2>/dev/null | cp -r prereq.com.tar.gz /tmp/
                yes 2>/dev/null | cp configfiles/emailsend.py emailsend.py
                sleep 1
                python3 emailsend.py
            else
                echo "Error in Configuration execution"
            fi

        ;;
        [nN] | [n|N][O|o] )
        echo ".....Skipping ."
        ;;
        *) echo "Invalid input"
        exit 1
        ;;
    esac
}


### Not Deployed
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