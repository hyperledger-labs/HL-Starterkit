#!/bin/bash
#Created by : ravinayag@gmail.com | Ravi Vasagam

source scripts/.c.env
source scripts/.hlc.env
function lcpackage20(){

    echo -e $PCOLOR"Packaging  & Installing chaincode on $PEER_NAME0.$ORG_1..."$NONE
   
    export `cat scripts/.hlc.env | grep SAMPLE_CC`
    
    
    if [ $SAMPLE_CC == "ASSETTRANSFER" ]; then 
    export CC_PATH=/opt/gopath/src/github.com/chaincode/asset-transfer-basic/chaincode-go/
    cd $CC_PATH
    GO111MODULE=on go mod vendor
    go mod tidy
    cd /opt/gopath/src/github.com/hyperledger/fabric/peer
    export CC_LABLNAME="${SAMPLE_CC,,}"
    peer lifecycle chaincode package $SAMPLE_CC.tar.gz --path $CC_PATH --lang golang --label $CC_LABLNAME


    elif [ $SAMPLE_CC == "SACC" ]; then
    export CC_PATH=/opt/gopath/src/github.com/chaincode/sacc
    cd $CC_PATH
    GO111MODULE=on go mod vendor
    go mod tidy
    cd /opt/gopath/src/github.com/hyperledger/fabric/peer
    export CC_LABLNAME="${SAMPLE_CC,,}"
    peer lifecycle chaincode package $SAMPLE_CC.tar.gz --path $CC_PATH --lang golang --label $CC_LABLNAME
    

    elif [ $SAMPLE_CC == "ABSTORE" ]; then
    export CC_PATH=/opt/gopath/src/github.com/chaincode/abstore/go
    cd $CC_PATH
    GO111MODULE=on go mod vendor
    go mod tidy
    cd /opt/gopath/src/github.com/hyperledger/fabric/peer
    export CC_LABLNAME="${SAMPLE_CC,,}"
    peer lifecycle chaincode package $SAMPLE_CC.tar.gz --path $CC_PATH --lang golang --label $CC_LABLNAME
  

    elif [ $SAMPLE_CC == "ABAC" ]; then
    export CC_PATH=/opt/gopath/src/github.com/chaincode/abac/go
    cd $CC_PATH
    GO111MODULE=on go mod vendor
    go mod tidy
    cd /opt/gopath/src/github.com/hyperledger/fabric/peer
    export CC_LABLNAME="${SAMPLE_CC,,}"
    peer lifecycle chaincode package $SAMPLE_CC.tar.gz --path $CC_PATH --lang golang --label $CC_LABLNAME
   

    elif [ $SAMPLE_CC == "FABCAR" ]; then
    export CC_PATH=/opt/gopath/src/github.com/chaincode/fabcar/go
    cd $CC_PATH
    GO111MODULE=on go mod vendor
    go mod tidy
    cd /opt/gopath/src/github.com/hyperledger/fabric/peer
    export CC_LABLNAME="${SAMPLE_CC,,}"
    peer lifecycle chaincode package $SAMPLE_CC.tar.gz --path $CC_PATH --lang golang --label $CC_LABLNAME


    elif [ $SAMPLE_CC == "MARBLES" ]; then
    export CC_PATH=/opt/gopath/src/github.com/chaincode/marbles02/go
    cd $CC_PATH
    GO111MODULE=on go mod vendor
    go mod tidy
    cd /opt/gopath/src/github.com/hyperledger/fabric/peer
    export CC_LABLNAME="${SAMPLE_CC,,}"
    peer lifecycle chaincode package $SAMPLE_CC.tar.gz --path $CC_PATH --lang golang --label $CC_LABLNAME
    

    else
        echo -e $RCOLOR"Unknown Sample Chaincode"$NONE
    fi


}

function lcpkinstall20 () {
    cd /opt/gopath/src/github.com/hyperledger/fabric/peer
    peer lifecycle chaincode install $SAMPLE_CC.tar.gz

}