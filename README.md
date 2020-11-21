# HL-learnerscript
Hyperledger CLI Config Generator Tool   

# HL_Starterkit Automation

Disclaimer : Its fork from Hyperledger fabric samples[https://github.com/hyperledger/fabric-samples],  On my self Interest I created this Devops Automation for HL Learners/Startup Community.  
I'm looking for tester community to fine tune this tool  to serve better. 

Currently I'm Optimizing the code and waiting for UAT from learners community, I will be posting the code soon.  

Hyperledger Fabric network is now Automated with Custom Configuration creator. The tools consists of Advance Shelling scripting, Ansible, and Python. By Default the configurator tool generates with Two ORGS and two Peers an extension of BYFN model for Sample. 

What you can do with this Tool dynamically .... ?

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

This can be deployed on local system to generate config and test. You can also use it to deploy and test your own Fabric chaincodes and applications. 

To get started, see the demo video.

# Test Case Ready and To do :

1, Fabric 1.4.x / 2.x - Basic with 2 orgs and above is ready with example chaincode02 in single host  - Ready

2, Fabric 1.4  + explorer ready - Ready

3, HLF - Pre-requisties - Ready

4, Generate config and send email with attachment - Ready

5, Fabric 1.4.x / 2.x - Basic with 2 orgs and above is ready with example chaincode02 in Docker - Swarm network - Ready

6, Consensus type - etcdRaft customaisation - Ready 

7, Kubernatees with basic  & extended deployment for 1.4x and 2.x ( Tested with 2.x, )

8, Samples 1.4x = SACC, 2.x= Asset-transfer-Basic, SACC, ABAC -  Ready 

## Todo

9, Privatedata with private channel

10, Add option for Custom chaincode ( Approching Chain code developers)

11, Add other chaincodes for test

12, Optimize the scripts



