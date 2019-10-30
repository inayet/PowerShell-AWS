#Gets all AWS Regions in an object array 
$awsRegions = ((Get-AWSRegion).Region)

#Going through each region one by one 
foreach ($awsRegion in $awsRegions) {
    #Takes each region and converts into a string 
    $OneRegion = $awsRegion.tostring();
    #Retrives the AllocationId of each EC2
    $AllocationIds = (Get-EC2Address -region $OneRegion).AllocationId

    #Going through each allocation id one by one 
    foreach ($AllocationId in $AllocationIds) {
        #Takes each allocation id and converts into a string 
        $IdiEc2 = $AllocationId.tostring()
        #Removes the elastic IP address in each region 
        Remove-EC2Address -AllocationId $IdiEc2 -Region $OneRegion -Force

        }


}



