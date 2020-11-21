
#!/bin/bash

clear  #Need to remove on final stage
trap 'echo got SIGINT' SIGINT #### Control C
trap ' '2 20
trap "" TSTP
export IGNOREEOF=20   # Contrl+D
set -o ignoreeof
source .env

echo "Note : You need to complete the prerequisites to perform this configrator cli tool better.
if you haven't please do so. https://hyperledger-fabric.readthedocs.io/en/release-1.4/prereqs.html
I also compresed with all the prerequisites need,  you can download this script and run on  your lunix/ubuntu machine.
You can contact me anytime or leave a comment in message to ravinayag@github  or email at  ravinayag@gmail.com
Pre req script for 1.4 : https://github.com/ravinayag/Hyperledger/blob/master/prereqs_hlfv14.sh

Please remember, Currently the tool will not generate any crypto artifacts, due to infra limitations
2 Besu and Sawtooth are work in progress,  
"


source .env
source .c.env

## Selecing the Blockchain Network
source $HL_CFG_PATH/hlstartup/01_networkinfo.sh
selBCNet

## Custominzing the Configurations
source $HL_CFG_PATH/hlstartup/00_StartCustomHL.sh
checkenv

customDom
echo  -e $BCOLOR"##################################################################"$NONE && echo ""
customOrg
echo  -e $BCOLOR"##################################################################"$NONE && echo ""
customPeer
echo  -e $BCOLOR"##################################################################"$NONE && echo ""
customOrder
echo  -e $BCOLOR"##################################################################"$NONE && echo ""
customCA
echo  -e $BCOLOR"##################################################################"$NONE && echo ""
customChannel




## Syschannel variable Setting
setsyschl


## Checking the 3rd Organisation , Orderers and generate the custom files.
checkORG3

## Updating the Custom Values
SEDing
#SEDingfiles2

## Adding the Org's and updating the Values
addorgsed



## Cleaning the previous dir's and  Copying the container Script 
## As per Version Requirements
rmovecrypto
ScriptVerCopy

## Custom Select for Consensus/ Orderer Type  and Updating the values to dockercompose files.
#source $HL_CFG_PATH/hlstartup/01_networkinfo.sh
selconsensus
SEDordraft
## Updating the Confgitx Versions and generate Artifacts.
createChannelArtifacts

## Updating the Private keys to CA config file.s
replKeys

## Custom to Select Docker Containers SOLO/SWARM/K8s
#source $HL_CFG_PATH/hlstartup/01_networkinfo.sh
selvirtcontainer

## Custom Option to select Sample Chaincodes.
source $HL_CFG_PATH/hlstartup/04_Fabsamplecc.sh
#selccode





## Ask for Mail Communication
#source $HL_CFG_PATH/hlstartup/01_networkinfo.sh
AskconfEmail

## Ask for Explorer Start
#source $HL_CFG_PATH/hlstartup/08_expstart.sh
#explorerConfig
#startexplore

exit 123
exit 1