    
    #!/bin/bash
    source HLF_Automation/.env
    source HLF_Automation/01_networkinfo.sh
    HLFver
    #For latest version  of link
    #curl -sSL   https://raw.githubusercontent.com/hyperledger/fabric/master/scripts/bootstrap.sh | bash -s
    #### if you need to download specific version follow below syntax
    #curl -sSL http://bit.ly/2ysbOFE | bash -s -- <fabric_version> <fabric-ca_version> <thirdparty_version>

    curl -sSL http://bit.ly/2ysbOFE | bash -s -- $IMAGE_TAG $CAIMAGE_TAG $DBIMAGE_TAG
    
    if [[ "$IMAGE_TAG" == '1.4.3' ]] ; 
    then 
        docker pull hyperledger/fabric-couchdb:0.4.15; 
        docker tag hyperledger/fabric-couchdb:0.4.15 couchdb:0.4.15; 
    else echo "error in imaging"; 
    fi



