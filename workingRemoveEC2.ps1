
#Run these scripts successfully you must have admin privilages to all aws resources

#
#$awsRegions = ((Get-AWSRegion).Region.PsObject.BaseObject) | ForEach-Object {$_}
$awsRegions = ((Get-AWSRegion).Region)

foreach ($awsRegion in $awsRegions) {
        $OneRegion = $awsRegion.tostring();
        $Ec2Ids = (Get-EC2Instance -region $OneRegion).Instances.instanceId

        foreach ($Ec2Id in $Ec2Ids) {
            $IdiEc2 = $Ec2Id.tostring()
            Remove-EC2Instance -InstanceId $IdiEc2 -Region $OneRegion -Force
        }
    }



