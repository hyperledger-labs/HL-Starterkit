#!/bin/bash


function selcc() {
    echo
    echo
    
    echo -e $BCOLOR"Would you like to go with sample chaincode examples to run ?  "$NONE
    #read yn
    case $yn in
        [[yY] | [yY][Ee][Ss] )
            echo -e $BCOLOR"Select sample chaincode Service..?"$NONE
            PS3="Enter your choice (must be a above number): "
            select CONTSERV in  SACC-v1.4 AssetTransfer-v2.0  ABAC-v2.0 Fabcar-v2.0 Marbles02 Abstore Marbles02_private  exit
            do
                case $CONTSERV in
                    SACC-v1.4)
                        echo "Go to SACC"
                        export `cat .hlc.env | grep IMAGE_TAG`
                        if [ "$IMAGE_TAG"==1.4.3 ];  then
                            echo "SAMPLE_CC=SACC" >> .hlc.env
                            source 01_singlehost.sh
                            fabsinhost
                        else
                            echo "Invalid Image, Not Applicable to run CC_example02"
                        fi
                        break
                    ;;
                    AssetTransfer-v2.0)
                        echo "Go to AssetTransfer"
                        echo "SAMPLE_CC=ASSETTRANSFER" >> .hlc.env
                        if [ "$IMAGE_TAG"==2.2.0 ];  then
                            source 01_singlehost.sh
                            fabsinhost
                        else
                            echo "Invalid selection, Not Applicable to run in V2.0"
                        fi
                        exit 1
                        break
                    ;; 
                    ABAC)
                        echo "Go to ABAC"
                        echo "SAMPLE_CC=ABCC" >> .hlc.env
                        echo -e $BCOLOR" Development Work in Progress "$NONE

                        exit 1
                        break
                    ;;
                    Fabcar)
                        echo "Go to FabCar"
                        echo "SAMPLE_CC=FABCAR" >> .hlc.env
                        echo -e $BCOLOR" Development Work in Progress "$NONE
                        break
                    ;;
                    Marbles02)
                        echo "Go to Marbles02"
                        echo -e $BCOLOR" Development Work in Progress "$NONE
                        break
                    ;;
                    Abstore)
                        echo " Go to Abstore"
                        echo -e $BCOLOR" Development Work in Progress "$NONE
                        break
                    ;;
                    Marbles02_private)
                        echo " Go to Marbles_private"
                        echo -e $BCOLOR" Development Work in Progress "$NONE
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