
# Using dot sourcing to delete VPC dependencies before VPC can be deleted.

. ./workingRemoveEC2.ps1

#Waiting 80 seconds before moving on to the next dot source script; this is the lazy way 
##because what if it takes longer than 60 seconds?

Start-Sleep  -Seconds 60

. ./workingRemoveElasticIp.ps1
. ./workingRemoveSubnets.ps1
. ./workingRemoveInternetGateway.ps1
. ./workingRemoveSecurityGroup.ps1
. ./WorkingRemoveRouteTables.ps1
. ./workingRemoveVPC.ps1








