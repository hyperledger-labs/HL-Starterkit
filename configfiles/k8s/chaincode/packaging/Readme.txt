Change the org1.connnection.json to connection.json file and package it. do the same for org2 packageing.

Ref :  "address": "chaincode-marbles-org1.hlfk8s:7052",

$ rm -f code.tar.gz
$ tar cfz code.tar.gz connection.json
$ tar cfz marbles-org1.tgz code.tar.gz metadata.json
$ peer lifecycle chaincode install marbles-org1.tgz