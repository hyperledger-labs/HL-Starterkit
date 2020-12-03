

function DBimagechg (){
    source .env
    #source .hlc.env
    export `cat .hlc.env | grep DBIMAGE_TAG`
    if [ $DBIMAGE_TAG == 0.4.15 ];then
    docker pull hyperledger/fabric-couchdb:0.4.15
    docker tag hyperledger/fabric-couchdb:0.4.15 couchdb:0.4.15
    #sed -i -e "s/COUCHDB_USER=admin/COUCHDB_USER=/g" $HL_CFG_PATH/docker-compose-cli.yaml
    #sed -i -e "s/COUCHDB_PASSWORD=password/COUCHDB_PASSWORD=/g" $HL_CFG_PATH/docker-compose-cli.yaml
    fi
}