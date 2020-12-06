README First


Fabric Single host Information for 1.4.x / 2.x

By this time you have received configuration files in .tar.gz or zip format. If not please rename your attachment to .tar.gz file.
Once the prerequests are installed and you do dowloaded the fabric samples and placed under /your/path/fabric-samples, then create a folder  name with hltool. 

Extract your attachment under this folder, So your path become like /your/path/fabric-samples/hltool/yourfile.tar.gz
Once it extracted, you have file name called  `web-fab-start-single.sh`
ensure the file 755 permissions if not please do run `sudo chmod 755 web-fab-start-single.sh`

Now you run the file 
`./web-fab-start-single.sh`



Notes : 
In case you face couchdb not found from docker source, then change the tag for 1.4.x
$ docker tag couchdb:3.1 couchdb:0.4.15

#####################






