
#!/bin/bash


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