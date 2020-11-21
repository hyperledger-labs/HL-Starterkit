#!bin/bash

PORT9=10051
PORT9C=10052
PORT6=11051
PORT6C=11052


function addorgport () {

              ((PORT9=PORT9+1000))
              ((PORT9C=PORT9C+1000))
              ((PORT6=PORT6+1000)) 
              ((PORT6C=PORT6C+1000))                
              
              export PORT9=$PORT9
              export PORT9C=$PORT9C
              export PORT6=$PORT6
              export PORT6C=$PORT6C


}




function addOrgdockfile() {
    export `cat ./.hlc.env | grep ORGCNT`
    #echo ORGCNT != $ORGCNT
    #set +x
    rm configfiles/base/peer?addorg?.yaml 
    rm configfiles/base/peer?addorgcli?.yaml 

    if  [ '$ORGCNT' != '2' ] ; then
      #PORT9=10051
      #PORT9C=10052
      #PORT6=11051
      #PORT6C=11052
      for ((i=3; i<= $ORGCNT; i++));

            do
                #for ((PORT9=10051; i<= $ORGCNT; i++))
                #  do
                #    ((PORT9=PORT9+1000))
                #    export PORT9=$PORT9
                #    
                #  done
              
              cp configfiles/peer0add_orgi_1.yml configfiles/base/peer0addorg$i.yaml
              cp configfiles/peer1add_orgi_1.yml configfiles/base/peer1addorg$i.yaml
              cp configfiles/peer0add_orgi_2.yml configfiles/base/peer0addorgcli$i.yaml
              cp configfiles/peer1add_orgi_2.yml configfiles/base/peer1addorgcli$i.yaml
              addorgport
              #((PORT9=PORT9+1000))
              #((PORT9C=PORT9C+1000))
              #((PORT6=PORT6+1000)) 
              #((PORT6C=PORT6C+1000))                
              #
              #export PORT9=$PORT9
              #export PORT9C=$PORT9C
              #export PORT6=$PORT6
              #export PORT6C=$PORT6C
              #
              sed -i -e "s/{ORG_9}/{ORG_$i}/g" configfiles/base/peer0addorg$i.yaml
              sed -i -e "s/{ORG_9_C}/{ORG_${i}_C}/g" configfiles/base/peer0addorg$i.yaml
              sed -i -e "s/{PEER_0}/{PEER_NAME0}/g" configfiles/base/peer0addorg$i.yaml
              sed -i -e "s/{PEER_1}/{PEER_NAME1}/g" configfiles/base/peer0addorg$i.yaml
              sed -i -e "s/{PORT9}/$PORT9/g" configfiles/base/peer0addorg$i.yaml
              sed -i -e "s/{PORT9C}/$PORT9C/g" configfiles/base/peer0addorg$i.yaml
              sed -i -e "s/{PORT6}/$PORT6/g" configfiles/base/peer0addorg$i.yaml
              #
              sed -i -e "s/{PEER_0}/{PEER_NAME0}/g" configfiles/base/peer0addorgcli$i.yaml
              sed -i -e "s/{ORG_9}/{ORG_$i}/g" configfiles/base/peer0addorgcli$i.yaml
              #
              sed -i -e "s/{ORG_9}/{ORG_$i}/g" configfiles/base/peer1addorg$i.yaml
              sed -i -e "s/{ORG_9_C}/{ORG_${i}_C}/g" configfiles/base/peer1addorg$i.yaml
              sed -i -e "s/{PEER_0}/{PEER_NAME0}/g" configfiles/base/peer1addorg$i.yaml
              sed -i -e "s/{PEER_1}/{PEER_NAME1}/g" configfiles/base/peer1addorg$i.yaml
              sed -i -e "s/{PORT9}/$PORT9/g" configfiles/base/peer1addorg$i.yaml
              sed -i -e "s/{PORT6C}/$PORT6C/g" configfiles/base/peer1addorg$i.yaml
              sed -i -e "s/{PORT6}/$PORT6/g" configfiles/base/peer1addorg$i.yaml
              #
              sed -i -e "s/{PEER_1}/{PEER_NAME1}/g" configfiles/base/peer1addorgcli$i.yaml
              sed -i -e "s/{ORG_9}/{ORG_$i}/g" configfiles/base/peer1addorgcli$i.yaml
              addorgport
            done


    else

      echo -e $RCOLOR"un recoganised CONTAINER Selection='$CONT'. exiting"$NONE
      #exit 1
    fi
    #res=$?
    #echo $res

}



