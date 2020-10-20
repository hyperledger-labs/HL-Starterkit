#!/bin/bash
#####

trap 'echo got SIGINT' SIGINT #### Control C
# Signal 2 is Ctrl+C
# Okay disable it:
#trap '' 2     ### Control C
### Disable CTRL+C and CRTL+Z command ########
trap ' '2 20
trap "" TSTP

export IGNOREEOF=20   # Contrl+D
set -o ignoreeof
source .env


docker-compose -f docker-compose-cli.yaml down -v
docker-compose -f explorer/docker-compose-explorer.yml down -v
docker stop $(docker ps -qa)
docker rm $(docker ps -qa)
docker image rm $(docker image ls | grep -E 'mycc|dev' | awk '{print $3}')

docker volume prune -f
docker network prune -f
clear  #Need to remove on final stage


echo "Note : You need to complete the prerequisites to perform this configrator cli tool better.
if you haven't please do so. https://hyperledger-fabric.readthedocs.io/en/release-1.4/prereqs.html
I also compresed with all the prerequisites need,  you can download this script and run on  your lunix/ubuntu machine.
You can contact me anytime or leave a comment in message to ravinayag@github  or email at  ravinayag@gmail.com
Pre req script for 1.4 : https://github.com/ravinayag/Hyperledger/blob/master/prereqs_hlfv14.sh
Pre req script for 2.x : WIP
"

source .c.env

. 01_networkinfo.sh

selBCNet



echo
echo -e $GCOLOR"                                                                                                     "$NONE
echo -e $GCOLOR" ########  Starting custom script for Fabric configuration & Docker-compose  files ##########        "$NONE
echo -e $GCOLOR"                                                                                                     "$NONE
echo
echo
function customDom() {
    echo -e $BCOLOR"Lets start the Custom Configuration for Hyperledger Fabric.."$NONE
    echo
    read -p "Give your domain name(ex:example.com) :" DOMAIN_NAME
    if [ -z $DOMAIN_NAME ];then echo  "Taking default"; DOMAIN_NAME="example.com"; else DOMAIN_NAME="$DOMAIN_NAME"; fi;
    echo $DOMAIN_NAME
    echo "DOMAIN_NAME=$DOMAIN_NAME" >> .hlc.env


}
customDom


function customOrg() {
    read -p "How Many ORGS you need (default : 2  ) : " ORGCNT
    if [ -z $ORGCNT ];then echo  "Taking default"; ORGCNT="2" ; else ORGCNT="$ORGCNT"; fi;
    if [[ $ORGCNT =~ ^[+-]?[0-9]+$ ]]; then
    echo $ORGCNT
    export ORGCNT=$ORGCNT
    echo "ORGCNT=$ORGCNT" >> .hlc.env
    
    
    #if [ -z $PCOUNT ];then echo  "Taking default"; PCOUNT="2"; else PCOUNT="$PCOUNT"; fi;
    elif [[ $ORGCNT =~ ^[+-]?[0-9]+\.?[0-9]*$ ]]; then
    echo "Seems to be Float, Please enter valid input number, and try again"
    exit 1
    else
    echo "Please enter valid input number, and try again"
    exit 1
    fi
    
   
    #echo > ab.txt
    for ((i=1; i<= $ORGCNT; i++))   
        do
            #echo $i
            read -p "Give your ORG name(default: org$i) : " ORGNME
            if [ -z $ORGNME ];
            then 
                echo  "Taking default : org$i"
                export ORG_$i=org$i
                echo "ORG_$i=org$i" >> .hlc.env
                ORN=org$i
                echo "ORG_${i}_C=${ORN^}" >> .hlc.env
                export ORG_${i}_C="${ORN^}"   
            else 
                echo "Given Name :  $ORGNME"
                export ORG_$i=$ORGNME
                echo "ORG_$i=$ORGNME" >> .hlc.env
                echo "ORG_${i}_C="${ORGNME^}"" >> .hlc.env
                export ORG_${i}_C="${ORGNME^}"
                

            fi;
        done

}
customOrg


echo  -e $BCOLOR"##################################################################"$NONE
echo ""


function customPeer() {
    read -p "How Many Peers you need (default:2 (start with 0) ) : " PCOUNT
    if [ -z $PCOUNT ];then echo  "Taking default"; PCOUNT="1" ; else PCOUNT="$PCOUNT"; fi;
    if [[ $PCOUNT =~ ^[+-]?[0-9]+$ ]]; then
    echo $PCOUNT
    export PCOUNT=$PCOUNT
    echo "PCOUNT=$PCOUNT" >> .hlc.env
    
    
    #if [ -z $PCOUNT ];then echo  "Taking default"; PCOUNT="2"; else PCOUNT="$PCOUNT"; fi;
    elif [[ $PCOUNT =~ ^[+-]?[0-9]+\.?[0-9]*$ ]]; then
    echo "Seems to be Float, Please enter valid input number, and try again"
    exit 1
    else
    echo "Please enter valid input number, and try again"
    fi
    
   
    #echo > ab.txt
    for ((i=0; i<= $PCOUNT; i++))   
        do
            #echo $i
            read -p "Give your peer name(default: Peer$i) : " PEER_NAME
            if [ -z $PEER_NAME ];
            then 
                echo  "Taking default : peer$i"
                echo "PEER_NAME$i=peer$i" >> .hlc.env
                export PEER_NAME$i="peer$i"
            else 
                echo "Given Name :  $PEER_NAME"
                echo "PEER_NAME$i=$PEER_NAME" >> .hlc.env
                export PEER_NAME$i=$PEER_NAME

            fi;
        done

}
customPeer


echo  -e $BCOLOR"##################################################################"$NONE
echo ""


function customOrder() {
    read -p "How Many Order nodes you need (default:1 for solo, 5 for RAFT;  starts with 0 ) : " ORDCOUNT
    if [ -z $ORDCOUNT ];then echo  "Taking default"; ORDCOUNT="0" ; else ORDCOUNT=$(($ORDCOUNT-1)); fi;
    if [[ $ORDCOUNT =~ ^[+-]?[0-9]+$ ]]; then
    #echo $(($ORDCOUNT-1))
    echo $ORDCOUNT

    export ORDCOUNT=$ORDCOUNT
    echo "ORDCOUNT=$ORDCOUNT" >> .hlc.env
    
    
    #if [ -z $PCOUNT ];then echo  "Taking default"; PCOUNT="2"; else PCOUNT="$PCOUNT"; fi;
    elif [[ $ORDCOUNT =~ ^[+-]?[0-9]+\.?[0-9]*$ ]]; then
    echo "Seems to be Float, Please enter valid input number, and try again"
    exit 1
    else
    echo "Please enter valid input number, and try again"
    fi
    
   
    #echo > ab.txt
    for ((i=0; i<= $ORDCOUNT; i++))   
        do
            #echo $i
            #echo "ORD_NAME0=orderer" >> .hlc.env
            #export ORD_NAME0="orderer"
            read -p "Give your Orderer name(default: Orderer$i) : " ORD_NAME
            if [ -z $ORD_NAME ];
            then 
                echo  "Taking default : orderer$i"
                echo "ORD_NAME$i=orderer$i" >> .hlc.env
                export ORD_NAME$i="orderer$i"
                #ORD_NAME0_C="${ORD_NAME0^}"
                #echo "ORD_NAME0_C="${ORD_NAME0^}" " >> .hlc.env
                ORD=orderer$i
                echo "ORD_NAME${i}_C=${ORD^}" >> .hlc.env
                export ORD_NAME${i}_C="${ORD^}" 
            else 
                echo "Given Name :  $ORD_NAME"
                echo "ORD_NAME$i=$ORD_NAME" >> .hlc.env
                export ORD_NAME$i=$ORD_NAME
                echo "ORD_NAME${i}_C="${ORD_NAME^}" " >> .hlc.env

            fi;
        done

}
customOrder

echo  -e $BCOLOR"##################################################################"$NONE
echo ""



function customCA() {
    read -p "How Many CA nodes you need (default:2 ) : " CACOUNT
    if [ -z $CACOUNT ];then echo  "Taking default"; CACOUNT="1" ; else CACOUNT="$CACOUNT"; fi;
    if [[ $CACOUNT =~ ^[+-]?[0-9]+$ ]]; then
    echo $CACOUNT
    export CACOUNT=$CACOUNT
    echo "CACOUNT=$CACOUNT" >> .hlc.env
    
    
    #if [ -z $PCOUNT ];then echo  "Taking default"; PCOUNT="2"; else PCOUNT="$PCOUNT"; fi;
    elif [[ $CACOUNT =~ ^[+-]?[0-9]+\.?[0-9]*$ ]]; then
    echo "Seems to be Float, Please enter valid input number, and try again"
    exit 1
    else
    echo "Please enter valid input number, and try again"
    fi
    
   
    #echo > ab.txt
    for ((i=1; i<= $CACOUNT; i++))   
        do
            #echo $i
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

}
customCA

echo  -e $BCOLOR"##################################################################"$NONE
echo ""

SYS_CHANNEL=syschannel
echo "SYS_CHANNEL=syschannel" >> .hlc.env

function customChannel() {
    read -p "How Many Chaincode Channel you need (default:1 ) : " CHCOUNT
    if [ -z $CHCOUNT ];then echo  "Taking default"; CHCOUNT="1" ; else CHCOUNT="$CHCOUNT"; fi;
    if [[ $CHCOUNT =~ ^[+-]?[0-9]+$ ]]; then
    echo $CHCOUNT
    export CHCOUNT=$CHCOUNT
    echo "CHCOUNT=$CHCOUNT" >> .hlc.env
    
    
    #if [ -z $PCOUNT ];then echo  "Taking default"; PCOUNT="2"; else PCOUNT="$PCOUNT"; fi;
    elif [[ $CHCOUNT =~ ^[+-]?[0-9]+\.?[0-9]*$ ]]; then
    echo "Seems to be Float, Please enter valid input number, and try again"
    exit 1
    else
    echo "Please enter valid input number, and try again"
    fi
    
   
    #echo > ab.txt
    for ((i=1; i<= $CHCOUNT; i++))   
        do
            #echo $i
            read -p "Give your Channel name(default: mychannel$i ) : " CHANNEL_NAME
            if [ -z $CHANNEL_NAME ];
            then 
                echo  "Taking default : mychannel"
                echo "CHANNEL_NAME$i=mychannel" >> .hlc.env
                export CHANNEL_NAME$i="mychannel"
            else 
                echo "Given Name :  $CHANNEL_NAME"
                echo "CHANNEL_NAME$i=$CHANNEL_NAME" >> .hlc.env
                export CHANNEL_NAME$i=$CHANNEL_NAME

            fi;
        done

}
customChannel


echo  -e $BCOLOR"##################################################################"$NONE
echo ""


#ORD_NAME0_C="${ORD_NAME0^}"
#ORG_1_C="${ORG_1^}"      ### for bash ver 4.0 and above
#ORG_2_C="${ORG_2^}"
#ORG_2_C=${ORG_2:0:1}     ### for bash ver3.2 and above


#This needs to be taken care later stage of expanding orgs as part of ansible.
#ORG_3_C=`echo "${ORG_3^}"`
#ORG_4_C="${ORG_4^}"
#ORG_5_C="${ORG_5^}"
#printf '%s\n' "$ORD_NAME0_C"


#echo "ORD_NAME0_C="${ORD_NAME0^}" " >> .hlc.env
#echo "ORG_1_C="${ORG_1^}" " >> .hlc.env
#echo "ORG_2_C="${ORG_2^}"" >> .hlc.env
#echo "ORG_3_C=`echo "${ORG_3^}"`" >> .hlc.env

pwd
rm configtx.yaml crypto-config.yaml docker-compose-cli.yaml
function raftadd() {
    if [ $ORDCOUNT -ge 2 ];
        then                
            cd configfiles/ansiblescripts
            ansible-playbook 04_cryptoconorderer.yaml
            cd ../../
        else
           echo "do nothing"
    fi
}

#raftadd

## updating the Configtx14-org.yaml file using ansible

function checkORG3() {
    export `cat .hlc.env | grep ORGCNT`
    #!/bin/bash -vx
    export `cat .hlc.env | grep IMAGE_TAG`
    if  [ $ORGCNT -ge 3  -a  $IMAGE_TAG == 2.2.0 ]  ;
    then
        echo "...Adding orgs in config"
        echo " org > 3 & fabric 2.2  "
        source 09_addorg.sh
        addOrgdockfile
        #if [ $IMAGE_TAG -eq 2.2.0 ] then
        cd configfiles/ansiblescripts/
        
        ansible-playbook 05_configtx_fab2.0.yaml
        ansible-playbook 06_configtx_fab2.0-orgadd.yaml
        if [ $ORDCOUNT -gt 0  -a  "$IMAGE_TAG" == 2.2.0 ];
        then
        ansible-playbook 04_cryptoconorderer.yaml
        else " Solo config @2x"
        fi
        cd ../../ 
        cp ./configfiles/ansiblescripts/configtx_v20.org.yaml ./configtx.yaml
        cp ./configfiles/ansiblescripts/crypto-config.org.yaml ./crypto-config.yaml
        cp ./configfiles/base/docker-compose-base-org.yaml ./base/docker-compose-base.yaml
        cp ./configfiles/base/peer-base-org.yaml ./base/peer-base.yaml
        cp ./configfiles/base/ca-base-org.yaml ./base/ca-base.yaml
        cp ./configfiles/docker-compose-cli-org.yaml ./docker-compose-cli.yaml
    elif   [ $ORGCNT -lt 3  -a  "$IMAGE_TAG" == 2.2.0 ] ;
    then
        echo " fabric 2.2.0 & < 3org "
        cd configfiles/ansiblescripts/
        #ansible-playbook 04_cryptoconorderer.yaml
        ansible-playbook 05_configtx_fab2.0.yaml

        if [ $ORDCOUNT -gt 0  -a  "$IMAGE_TAG" == 2.2.0 ]; then
        ansible-playbook 04_cryptoconorderer.yaml
        else " Solo config @2x"
        fi
        cd ../../ 
        cp ./configfiles/ansiblescripts/configtx_v20.org.yaml ./configtx.yaml
        cp ./configfiles/ansiblescripts/crypto-config.org.yaml ./crypto-config.yaml
        cp ./configfiles/base/docker-compose-base-orgsrc.yaml ./base/docker-compose-base.yaml
        cp ./configfiles/base/peer-base-orgsrc.yaml ./base/peer-base.yaml
        cp ./configfiles/base/ca-base-orgsrc.yaml ./base/ca-base.yaml
        cp ./configfiles/docker-compose-cli-orgsrc.yaml ./docker-compose-cli.yaml
    elif  [ $ORGCNT -ge 3 -a  "$IMAGE_TAG" == 1.4.3 ]  ;
    then
        echo " fabric 1.4.3 &> 3org "
        # for fabric 1.4x
        cd configfiles/ansiblescripts/
        #set -o nounset -o pipefail -o errexit
        # Load all variables from .env and export them all for Ansible to read
        #set -o allexport
        source ../../.hlc.env
        #set -o allexport
        ansible-playbook 01_configtxchg.yaml
        if [ $ORDCOUNT -gt 0  -a  "$IMAGE_TAG" == 1.4.3 ] ;
        then
        ansible-playbook 04_cryptoconorderer.yaml
        else " Solo config @1.4x"
        fi
        cd ../../
        cp ./configfiles/ansiblescripts/configtx_v14.org.yaml ./configtx.yaml
        #fi
        cp ./configfiles/ansiblescripts/crypto-config.org.yaml ./crypto-config.yaml
        cp ./configfiles/base/docker-compose-base-org.yaml ./base/docker-compose-base.yaml
        cp ./configfiles/base/peer-base-org.yaml ./base/peer-base.yaml
        cp ./configfiles/base/ca-base-org.yaml ./base/ca-base.yaml
        cp ./configfiles/docker-compose-cli-org.yaml ./docker-compose-cli.yaml
    else
        echo "...Skipping to default 2org/1.4x" 
        #if [ $ORDCOUNT -le 1 ]; then 
        #    cp ./configfiles/ansiblescripts/crypto-config.org.yaml ./crypto-config.yaml
        #    else 
        #    cp ./configfiles/ansiblescripts/crypto-config.orgsrc.yaml ./crypto-config.yaml
        #fi
        #if [ $IMAGE_TAG -eq 2.2.0 ] then
        #    cd configfiles/ansiblescripts/
        #    ansible-playbook 05_configtx_fab2.0.yaml
        #    cd ../../ 
        #    cp ./configfiles/ansiblescripts/configtx_v20.org.yaml ./configtx.yaml
        #else 
        cp ./configfiles/ansiblescripts/configtx_v14.orgsrc.yaml ./configtx.yaml
        cp ./configfiles/ansiblescripts/crypto-config.orgsrc.yaml ./crypto-config.yaml
        #fi
        if [ $ORDCOUNT -gt 0  ] ;then
        cd configfiles/ansiblescripts/
        source ../../.hlc.env
        ansible-playbook 04_cryptoconorderer.yaml
        cd ../../
        cp ./configfiles/ansiblescripts/crypto-config.org.yaml ./crypto-config.yaml
        else 
        cp ./configfiles/ansiblescripts/crypto-config.orgsrc.yaml ./crypto-config.yaml
        fi
        
        
        rm -rf ./base/
        mkdir -p ./base
        cp ./configfiles/base/docker-compose-base-orgsrc.yaml ./base/docker-compose-base.yaml
        cp ./configfiles/base/peer-base-orgsrc.yaml ./base/peer-base.yaml
        cp ./configfiles/base/ca-base-orgsrc.yaml ./base/ca-base.yaml
        cp ./configfiles/docker-compose-cli-orgsrc.yaml ./docker-compose-cli.yaml
    fi

}

checkORG3


#cp ./configfiles/configtx_v14.org.yaml  ./configtx.yaml
#cp ./configfiles/crypto-config.org.yaml ./crypto-config.yaml


rm -rf crypto-config/
echo "updating the crypto custom config files1."
set +x


###### for Different Host ########
#echo $DOMAIN_NAME ,  $ORD_NAME0_C 
#echo $ORG_1_C  , $ORG_2_C
sed -i -e "s/{IP-HOST1}/$HOST1/g" configtx.yaml
sed -i -e "s/{IP-HOST2}/$HOST2/g" configtx.yaml
sed -i -e "s/{IP-HOST3}/$HOST3/g" configtx.yaml

####Crypto-config.yml#######
sed -i -e "s/{DOMAIN_NAME}/$DOMAIN_NAME/g" crypto-config.yaml
sed -i -e "s/{ORD_NAME0}/$ORD_NAME0/g" crypto-config.yaml



sed -i -e "s/{ORD_NAME0_C}/$ORD_NAME0_C/g" crypto-config.yaml
sed -i -e "s/{ORG_1_C}/$ORG_1_C/g" crypto-config.yaml
sed -i -e "s/{ORG_2_C}/$ORG_2_C/g" crypto-config.yaml
sed -i -e "s/{ORG_3_C}/$ORG_3_C/g" crypto-config.yaml
sed -i -e "s/{ORG_4_C}/$ORG_4_C/g" crypto-config.yaml
sed -i -e "s/{ORG_5_C}/$ORG_5_C/g" crypto-config.yaml

#cat crypto-config.yaml
#sleep 5


sed -i -e "s/{ORG_1}/$ORG_1/g" crypto-config.yaml
sed -i -e "s/{ORG_2}/$ORG_2/g" crypto-config.yaml
sed -i -e "s/{ORG_3}/$ORG_3/g" crypto-config.yaml
sed -i -e "s/{ORG_4}/$ORG_4/g" crypto-config.yaml
sed -i -e "s/{ORG_5}/$ORG_5/g" crypto-config.yaml
sed -i -e "s/{PCOUNT}/$PCOUNT/g" crypto-config.yaml
sed -i -e "s/{PEER_NAME0}/$PEER_NAME0/g" crypto-config.yaml
sed -i -e "s/{PEER_NAME1}/$PEER_NAME1/g" crypto-config.yaml
sed -i -e "s/{PEER_NAME2}/$PEER_NAME2/g" crypto-config.yaml


####configtx.yml#######
sed -i -e "s/{DOMAIN_NAME}/$DOMAIN_NAME/g" configtx.yaml
sed -i -e "s/{ORD_NAME0}/$ORD_NAME0/g" configtx.yaml
sed -i -e "s/{ORG_1}/$ORG_1/g" configtx.yaml
sed -i -e "s/{ORG_2}/$ORG_2/g" configtx.yaml
sed -i -e "s/{ORG_3}/$ORG_3/g" configtx.yaml
sed -i -e "s/{ORG_4}/$ORG_4/g" configtx.yaml
sed -i -e "s/{ORG_5}/$ORG_5/g" configtx.yaml

sed -i -e "s/{PEER_NAME0}/$PEER_NAME0/g" configtx.yaml
sed -i -e "s/{PEER_NAME1}/$PEER_NAME1/g" configtx.yaml
sed -i -e "s/{PEER_NAME2}/$PEER_NAME2/g" configtx.yaml

sed -i -e "s/{ORD_NAME0_C}/$ORD_NAME0_C/g" configtx.yaml
sed -i -e "s/{ORG_1_C}/$ORG_1_C/g" configtx.yaml
sed -i -e "s/{ORG_2_C}/$ORG_2_C/g" configtx.yaml
sed -i -e "s/{ORG_3_C}/$ORG_3_C/g" configtx.yaml
sed -i -e "s/{ORG_4_C}/$ORG_4_C/g" configtx.yaml
sed -i -e "s/{ORG_5_C}/$ORG_5_C/g" configtx.yaml

sed -i -e "s/{HOST_IP1}/$HOST_IP1/g" configtx.yaml

function ordraft() {
    #if [ "$ORD_TYPE" == "RAFT"  ]; then
    cp configfiles/ansiblescripts/orderer-doc-comp-raft-org.yaml ./docker-compose-orderer-etcraft.yaml
    sed -i -e "s/{ORD_NAME1}/$ORD_NAME1/g" crypto-config.yaml
    sed -i -e "s/{ORD_NAME2}/$ORD_NAME2/g" crypto-config.yaml
    sed -i -e "s/{ORD_NAME3}/$ORD_NAME3/g" crypto-config.yaml
    sed -i -e "s/{ORD_NAME4}/$ORD_NAME4/g" crypto-config.yaml

    sed -i -e "s/{ORD_NAME1}/$ORD_NAME1/g" configtx.yaml
    sed -i -e "s/{ORD_NAME2}/$ORD_NAME2/g" configtx.yaml 
    sed -i -e "s/{ORD_NAME3}/$ORD_NAME3/g" configtx.yaml
    sed -i -e "s/{ORD_NAME4}/$ORD_NAME4/g" configtx.yaml

    
    sed -i -e "s/{DOMAIN_NAME}/$DOMAIN_NAME/g" docker-compose-orderer-etcraft.yaml
    sed -i -e "s/{ORD_NAME1}/$ORD_NAME1/g" docker-compose-orderer-etcraft.yaml
    sed -i -e "s/{ORD_NAME2}/$ORD_NAME2/g" docker-compose-orderer-etcraft.yaml 
    sed -i -e "s/{ORD_NAME3}/$ORD_NAME3/g" docker-compose-orderer-etcraft.yaml
    sed -i -e "s/{ORD_NAME4}/$ORD_NAME4/g" docker-compose-orderer-etcraft.yaml
    sed -i -e "s/{ORD_NAME5}/$ORD_NAME5/g" docker-compose-orderer-etcraft.yaml
    #fi

    
}



###### for Docker Compose files ########
#rm -rf ./base/
#mkdir -p ./base
#cp ./configfiles/base/docker-compose-base-org.yaml ./base/docker-compose-base.yaml
#cp ./configfiles/base/peer-base-org.yaml ./base/peer-base.yaml
#cp ./configfiles/base/ca-base-org.yaml ./base/ca-base.yaml
#cp ./configfiles/docker-compose-cli-org.yaml ./docker-compose-cli.yaml

#HLFver

##### Org1, Orderer, cli, CA1 #######
echo "updating thecustom config files2."
set +x
sed -i -e "s/{ORD_NAME0}/$ORD_NAME0/g" ./base/docker-compose-base.yaml
sed -i -e "s/{ORD_NAME0_C}/$ORD_NAME0_C/g" ./base/peer-base.yaml

sed -i -e "s/{DOMAIN_NAME}/$DOMAIN_NAME/g" ./base/docker-compose-base.yaml

#sed -i -e "s/{ORG_1_C}/$ORG_1_C/g" ./base/docker-compose-base.yaml
#sed -i -e "s/{ORG_1}/$ORG_1/g" ./base/docker-compose-base.yaml
#sed -i -e "s/{ORG_2_C}/$ORG_2_C/g" ./base/docker-compose-base.yaml
#sed -i -e "s/{ORG_2}/$ORG_2/g" ./base/docker-compose-base.yaml

sed -i -e "s/{PEER_NAME0}/$PEER_NAME0/g" ./base/docker-compose-base.yaml
sed -i -e "s/{PEER_NAME1}/$PEER_NAME1/g" ./base/docker-compose-base.yaml
sed -i -e "s/{PEER_NAME2}/$PEER_NAME2/g" ./base/docker-compose-base.yaml

sed -i -e "s/{ORD_NAME0}/$ORD_NAME0/g" ./docker-compose-cli.yaml
sed -i -e "s/{DOMAIN_NAME}/$DOMAIN_NAME/g" ./docker-compose-cli.yaml

#sed -i -e "s/{ORG_1_C}/$ORG_1_C/g" ./docker-compose-cli.yaml
#sed -i -e "s/{ORG_1}/$ORG_1/g" ./docker-compose-cli.yaml
#sed -i -e "s/{ORG_2_C}/$ORG_2_C/g" ./docker-compose-cli.yaml
#sed -i -e "s/{ORG_2}/$ORG_2/g" ./docker-compose-cli.yaml

sed -i -e "s/{PEER_NAME0}/$PEER_NAME0/g" ./docker-compose-cli.yaml
sed -i -e "s/{PEER_NAME1}/$PEER_NAME1/g" ./docker-compose-cli.yaml
sed -i -e "s/{PEER_NAME2}/$PEER_NAME2/g" ./docker-compose-cli.yaml

sed -i -e "s/{IMAGE_TAG}/$IMAGE_TAG/g" ./base/docker-compose-base.yaml
sed -i -e "s/{DBIMAGE_TAG}/$DBIMAGE_TAG/g" ./base/docker-compose-base.yaml

sed -i -e "s/{CA_ORG1}/$CA_ORG1/g" ./docker-compose-cli.yaml
sed -i -e "s/{CA_ORG1}/$CA_ORG1/g" ./base/ca-base.yaml
sed -i -e "s/{ORG_1}/$ORG_1/g" ./base/ca-base.yaml
sed -i -e "s/{DOMAIN_NAME}/$DOMAIN_NAME/g" ./base/ca-base.yaml

function addorgsed() {
    export `cat .hlc.env | grep ORGCNT`
    for ((i=1; i<= $ORGCNT; i++));
        do
        if [ $ORGCNT -ge 1 ];  then 
            eval printf '%s' "\${ORG_${i}_C}" | ( read ORC ; echo $ORC | sed -i -e "s/{ORG_${i}_C}/${ORC^}/g" ./base/docker-compose-base.yaml ;)
            eval printf '%s' "\${ORG_${i}}" | ( read ORC ; echo $ORC | sed -i -e "s/{ORG_$i}/$ORC/g" ./base/docker-compose-base.yaml ;)

            eval printf '%s' "\${ORG_${i}_C}" | ( read ORC ; echo $ORC | sed -i -e "s/{ORG_${i}_C}/${ORC^}/g" ./docker-compose-cli.yaml ;)
            eval printf '%s' "\${ORG_${i}}" | ( read ORC ; echo $ORC | sed -i -e "s/{ORG_$i}/$ORC/g" ./docker-compose-cli.yaml ;)
        else
            echo "there is an error pls check out"
        fi
    done

}

addorgsed






################################# Docker Swarm files ##############################3333

function swarmStart() {
    rm -rf org1 org2
    cp ./configfiles/swarm-scripts/swarm-org.env ./.swarm.env
  
    echo "CHANNEL_NAME1=$CHANNEL_NAME1" >> .swarm.env
    mkdir org1 org2
    echo "SYS_CHANNEL=$SYS_CHANNEL" >> .swarm.env
    #./02_swarmstart.sh

}

swarmStart


####################### articrafts generation ############################
#export FABRIC_CFG_PATH=${PWD}
rm -rf ./crypto-config
rm -rf channel-artifacts
rm -rf ./scripts

#########  Generating Orderer Genesis block, Channel creation & Anchor Peer for Org.

mkdir channel-artifacts

cp -r ./configfiles/scripts/. ./scripts
cp .c.env ./scripts/

#export ORD_TYPE="SOLO"
selconsensus
ordraft

function createChannelArtifacts() {
    echo 
    echo -e $BCOLOR"Do you want to create channel artifacts? [y,n]"$NONE
    read yn
    case $yn in
        [[yY] | [yY][Ee][Ss] )
            
            sed -i -e "s/{CHLCAP1}/$CHLCAP1/g" configtx.yaml
            sed -i -e "s/{ORDCAP1}/$ORDCAP1/g" configtx.yaml
            sed -i -e "s/{APPCAP1}/$APPCAP1/g" configtx.yaml

            echo running ./scripts/1a_firsttimeonly.sh
            #cp ./configfiles/scripts/1a_firsttimeonly.sh ./scripts/1a_firsttimeonly.sh
            sed -i -e "s/{ORG_1_C}/$ORG_1_C/g" ./scripts/1a_firsttimeonly.sh
            sed -i -e "s/{ORG_2_C}/$ORG_2_C/g" ./scripts/1a_firsttimeonly.sh
            sed -i -e "s/{SYS_CHANNEL}/$SYS_CHANNEL/g" ./scripts/1a_firsttimeonly.sh
            sed -i -e "s/{CHANNEL_NAME1}/$CHANNEL_NAME1/g" ./scripts/1a_firsttimeonly.sh
            ./scripts/1a_firsttimeonly.sh
        ;;
        [nN] | [n|N][O|o] )
        ;;
        *) echo "Invalid input"
        exit 1
        ;;
    esac
}
createChannelArtifacts


###################################




### Replacing KEY values
function replKeys () {
    ORG1KEY="$(ls crypto-config/peerOrganizations/$ORG_1.$DOMAIN_NAME/ca/ | grep 'sk$')"
    sed -i -e "s/{ORG1-CA-KEY}/$ORG1KEY/g" ./base/ca-base.yaml


    ORG1TLSKEY="$(ls crypto-config/peerOrganizations/$ORG_1.$DOMAIN_NAME/tlsca/ | grep 'sk$')"
    sed -i -e "s/{ORG1-TLSCA-KEY}/$ORG1TLSKEY/g" ./base/ca-base.yaml

    #ORG2KEY="$(ls crypto-config/peerOrganizations/$ORG_2.$DOMAIN_NAME/ca/ | grep 'sk$')"
    #sed -i -e "s/{ORG2-CA-KEY}/$ORG2KEY/g" docker-compose-org2.yml
    


}
replKeys



#Select Docker Container
selcontainer
 

source 04_Fabsamplecc.sh
selcc


#Send config as attachment over email.
AskconfEmail


#
#echo "        ++++++++  Adding New Org now   +++++++++  "
#sleep 10 
#
#   
##./scripts/14_prereq_addorg.sh
#sleep 10 
##docker exec cli sh ./scripts/15_addorg_netup.sh
#sleep 15
#./scripts/16_addorg_joinnet.sh
#sleep 5
#docker exec Org3cli sh ./scripts/17_addorg_ccins_qry.sh
#echo " #####  Tested the first network -explained  #### "
#./expstart.sh

echo -e $BCOLOR"Would you like to Hyperledger Explorer  ? [y,n]"$NONE
    read yn
    case $yn in
        [[yY] | [yY][Ee][Ss] )
        ./08_expstart.sh
        ;;
        [nN] | [n|N][O|o] )
        echo ".....Skipping ."
        echo "Thanks for using the config generator"
        ;;
        *) echo "Invalid input"
        exit 1
        ;;
    esac
