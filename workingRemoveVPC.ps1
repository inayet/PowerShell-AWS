$awsRegions = ((Get-AWSRegion).Region)


foreach ($awsRegion in $awsRegions) {

    # Main Variables
    $OneRegion = $awsRegion.tostring();
    $VpcIds = (Get-EC2Vpc -region $OneRegion).VpcId


    #Remove VPC
    foreach ($VpcId in $VpcIds) {
        $VpcIdString = $VpcId.tostring()

        Remove-EC2Vpc -VpcId $VpcIdString -Region $OneRegion -Force
    }
}





