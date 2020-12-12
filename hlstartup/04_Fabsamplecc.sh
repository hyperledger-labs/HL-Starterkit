#!/bin/bash
#Created by : ravinayag@gmail.com | Ravi Vasagam

function selccode() {
    echo
    echo
    cd $HL_CFG_PATH
    echo -e $BCOLOR"Would you like to go with sample chaincode examples to run - Single host, DockerSwarm ?  "$NONE

    echo -e $BCOLOR"Select sample chaincode Service..?"$NONE
    echo -e "    Note : For non web service, the Docker compose will bring up containers once the CC selected.
    You can select EXIT for config generation 
    "             
    PS3="Enter your choice (must be a above number): "
    select CONTSERV in  SACC-v1.4 AssetTransfer-v2.0  ABAC-v2.0 Fabcar-v2.0 Marbles-v2.0 Abstore-v1.4 Marbles_Private  exit
    do
        case $CONTSERV in
            SACC-v1.4)
                echo "Go to SACC"
                export `cat .hlc.env | grep IMAGE_TAG`
                echo "SAMPLE_CC=SACC" >> .hlc.env
                break
            ;;
            AssetTransfer-v2.0)
                echo "Go to AssetTransfer"
                export `cat .hlc.env | grep IMAGE_TAG`
                echo "SAMPLE_CC=ASSETTRANSFER" >> .hlc.env
                break
            ;; 
            ABAC)
                echo "Go to ABAC"
                echo "SAMPLE_CC=ABCC" >> .hlc.env
                echo -e $BCOLOR" Development Work in Progress "$NONE
                export `cat .hlc.env | grep IMAGE_TAG`
            ;;
            Fabcar)
                echo "Go to FabCar"
                echo "SAMPLE_CC=FABCAR" >> .hlc.env
                echo -e $BCOLOR" Development Work in Progress "$NONE
                break
            ;;
            Marbles-v2.0)
                echo "Go to Marbles02"
                echo "SAMPLE_CC=Marbles-v2.0" >> .hlc.env
                echo -e $BCOLOR" Development Work in Progress "$NONE
                break
            ;;
            Abstore-v1.4)
                echo " Go to Abstore"
                echo "SAMPLE_CC=Abstore" >> .hlc.env
                echo -e $BCOLOR" Development Work in Progress "$NONE
                break
            ;;
            Marbles_Private)
                echo " Go to Marbles_private"
                echo "SAMPLE_CC=Marbles_Private" >> .hlc.env
                echo -e $BCOLOR" Development Work in Progress "$NONE
                break
            ;;
            exit) 
                exit 1
                break 
            ;;
            *) echo "ERROR: Invalid selection" 
            ;;
        esac
    done            



}
