# HL-Starterkit
Hyperledger Starterkit    

# HL_Starterkit 

Disclaimer : Its fork from Hyperledger [fabric samples](https://github.com/hyperledger/fabric-samples),  On personal Interest I created this Devops Automation for HL Learners/Startup Community.  
I'm looking for testers / Scripters to fine tune this tool  to make available for everyone's use. 

Currently I'm Optimizing the code and waiting for UAT from learners community.

Hyperledger Fabric network is now Automated with Custom Config generator. The tools consists of Advance Shell scripting, Ansible, and Python along with Docker/k8s files. By Default the configurator tool generates with Two ORGS and two Peers. where i was explaining for BYFN/EYFN. [Ref] (https://github.com/ravinayag/fabric-samples-explained)

### What you can do with this tool dynamically .... ?

1, You can Create/Change your DOMAIN NAME, ORGS, Orderer,Peer and CA Names.

2, You can Create/Change Channel Names 

3, You Can Toggle between the Consensus type.

4, You can Toggle between HLF Fabric Versions and dependencies.

5, You can Deploy the Fabric network Single node / Multinode using DockerSwarm / Kubernatees.

6, You can select the Blockchain Network Between Hyperledger Frame Works. (Ex. Fabric/ Besu/ Sawtooth - besu/sawtooth under devlopment)

7, You can extend your Org Dynamically with custom name.

8, You can Upgrade your chaincode after Endorsement / Chaincode changes

9, You can deploy Private Data channels 

10, You have choice to select sample chaincodes or deploy custom chaincode as per fabric version

11, Dockerfile, Docker-compose file is ready and can support non linux distro's


This can be deployed on local system to generate config and test. You can also use it to deploy and test your own Fabric chaincodes and applications. 

To get started, see the demo video.

### Test Case Ready :

1, Fabric 1.4.x / 2.x - Basic with 2 orgs and above is ready with example chaincode02 in single host  - Ready

2, Fabric 1.4  + explorer ready - Ready

3, HLF - Pre-requisties - Ready

4, Generate config and send email with attachment - Ready (Sender email has to update)

5, Fabric 1.4.x / 2.x - Basic with 2 orgs and above is ready with Docker - Swarm network - ( Swarm Network is not ready for web Config generation) and kubernetes.

6, Consensus type - etcdRaft/Solo customaisation - Ready 

7, Kubernatees with basic & extended deployment for 1.4x and 2.x ( Tested with 2.x, )

8, Samples 1.4x = SACC, 2.x= Asset-transfer-Basic, SACC, ABAC -  Ready 


## Todo

9, Privatedata with private channel

10, Add option for Custom chaincode ( Approching Chain code developers)

11, Add other chaincodes for test

12, Optimize the scripts ( WIP )

13, Customaisation for endorsement methods

14, Customaisation code for SACC 


## Installations :
 I request to use Linux distro OS,  comfortablly works in Alpine/ubuntu linux. BASH, python,ansible is required if you running in non linux OS.

 Clone this repo  and run the ./hl-startup
 ```
 $ git clone https://github.com/ravinayag/HL-StartertKit.git
 $ cd HL-Starterkit
 $ ./hl-start.sh
```
If you want to run as a service on your system and access over webportal and access from port 8000. you can use '-d' to run as deamon in background

```
$ git clone https://github.com/ravinayag/HL-StartertKit.git
$ cd HL-Starterkit
$ docker-compose up   
``` 
Now you can access the tool from your web browser, 
http://your_ip_address:8000

Login/  passwd : term / term123 

$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$

I have posted demo videos and live tool can access from [here](https://hltool.knowledgesociety.tech)

$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$



