#!/bin/sh

echo README FIRST 

source .env
source .c.env
echo "The prerequistes is scripted to install as per the HLF - https://hyperledger-fabric.readthedocs.io/en/release-1.4/prereqs.html
to run HL Fabric with the minimum versions of dependency.
Ex. Golang, Docker, Docker-compose, Node, Npm, python. However, this can be modify according to version needed.
You can contact me anytime or leave a comment in message to ravinayag@github  or email at  ravinayag@gmail.com"


echo " If you do manual running then execute below commands in following sequence, remember you have also placed 
and extracted your fabric configuration in current folder, if  not please skip this now and extract it before you start this."
echo 
echo -e $GRCOLOR "source ./01_prereqs.sh \n prereq14 \n precheck \n FbinImage" $NONE

echo "## Optional, Download images manually. Update the Env variables for 'IMAGE_TAG CAIMAGE_TAG DBIMAGE_TAG'"
echo "FbinImage"   
echo "for Ex : DBIMAGE_TAG=0.4.18 CAIMAGE_TAG=1.4.7 IMAGE_TAG=1.4.7"





function prereq14 {
    ### export environment variables for current shell.
    #export GOPATH=$HOME/go
    #export PATH=$PATH:$GOPATH/bin
    #export PATH=${PWD}/bin:${PWD}:$PATH

    #### adding  environment variables to profile
    echo 'export GOPATH=/opt/go' >> ~/.profile
    echo 'export GOBIN=/opt/go/bin' >> ~/.profile
    echo 'export PATH=/usr/local/go/bin:$PATH' >> ~/.profile
    echo 'export PATH=${PWD}/bin:${PWD}:$PATH' >> ~/.profile
    source ~/.profile

    #### Installing dependency packages
    sudo apt-get update -y
    echo -e $PCOLOR"Installing golang"$NONE
    sudo apt-get install -y curl golang-go
    sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
    sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
    sudo apt-get -y install apt-transport-https ca-certificates
    sudo apt-get install -y python
    sudo apt-get update -y
    echo -e $PCOLOR"Installing Docker"$NONE
    sudo apt-cache policy docker-ce
    sudo apt-get install -y docker-ce docker-ce-cli
    sudo curl -L https://github.com/docker/compose/releases/download/1.26.0/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose
    sudo chmod +x /usr/local/bin/docker-compose
    sudo cp /usr/local/bin/docker-compose /usr/bin/docker-compose
    echo -e $PCOLOR"Installing Node"$NONE
    sudo curl -sL https://deb.nodesource.com/setup_10.x -o nodesource_setup.sh
    sudo bash nodesource_setup.sh && sudo apt-get install -y nodejs 
    sudo apt-get install -y figlet ansible
    sudo apt-get install -y build-essential checkinstall libssl-dev
    #sudo apt-get upgrade -y


    ##### Add user account to the docker group
    sudo usermod -aG docker $(whoami)
    echo
    echo
    echo -e $YCOLOR"Before running FbinImage, you need to logout/login for docker permission issues or open a new terminal and follow the steps.\n 
    1, Move to your directory \n
    2, Source 01_prereqs.sh \n
    3, FbinImage \n " $NONE
}

function precheck () {
    ####  Print installation details for user
    echo ''
    echo -e $LBCOLOR'Prereq/Installation completed, versions found/installed are:'$NONE
    echo ''
    echo -e $GRCOLOR "Node:             `node --version`"
    echo -e $GRCOLOR "NPM:              `npm --version`"
    echo -e $GRCOLOR "Docker:           `docker --version`"
    echo -e $GRCOLOR "Docker-Compose:   `docker-compose --version`"
    echo -e $GRCOLOR "Python:           `python -V`" 
    $NONE 
    echo 
    echo
    echo -e $RCOLOR" Logout/login back for the changes to take effect. You can ignore if you already handled"$NONE
    echo


}



function FbinImage () {
    source .hlc.env
    echo "If you get permission denied error, please open a new terminal window and  rerun the script. \n 
    1, Move to your directory \n 2, source 01_prereqs.sh \n 3, FbinImage \n  "
    sleep 5

    export `cat $HL_CFG_PATH/.hlc.env | grep IMAGE_TAG`
    curl -sSL http://bit.ly/2ysbOFE | bash -s -- $IMAGE_TAG $CAIMAGE_TAG $DBIMAGE_TAG
    
    if [[ "$IMAGE_TAG" == '1.4.3' ]] ; 
    then 
        docker pull hyperledger/fabric-couchdb:0.4.15; 
        docker tag hyperledger/fabric-couchdb:0.4.15 couchdb:0.4.15; 
    
    fi
}

