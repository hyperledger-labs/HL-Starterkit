READ ME First

Some Bash enviornments not exporting all fields, Hence do this script  if errors 

Make sure you have bin  and Chaincode folders one folder before 

for ex:
Your Path is /home/term then you should have bin and chaincode folder under this and your extracted config/compose folder should be below
/home/term/bin
/home/term/chaincode
/home/term/composefiles

Change your directory to /home/term/composefiles 
$ tar xzf example.com.tar.gz
$ source .hlc.env
$ source .c.env
$ source .env
$ export `cat .hlc.env | grep IMAGE_TAG`

In case you fase couchdb not found from docker source, then change the tag for 1.4.x
$ docker tag couchdb:3.1 couchdb:0.4.15

Lets Start : 
First you need to generate artifacts
mkdir channel-artifacts

$ scripts/1a_firsttimeonly.sh
Run this below commands

Below is only applicable to 1.4.x
ORG1KEY="$(ls crypto-config/peerOrganizations/$ORG_1.$DOMAIN_NAME/ca/ | grep 'sk$')"
sed -i -e "s/{ORG1-CA-KEY}/$ORG1KEY/g" ./base/ca-base.yaml
ORG1TLSKEY="$(ls crypto-config/peerOrganizations/$ORG_1.$DOMAIN_NAME/tlsca/ | grep 'sk$')"
sed -i -e "s/{ORG1-TLSCA-KEY}/$ORG1TLSKEY/g" ./base/ca-base.yaml

$ docker-compose -f docker-compose-cli.yaml up -d
