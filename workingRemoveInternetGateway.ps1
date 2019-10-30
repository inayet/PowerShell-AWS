$AwsRegions = (Get-AWSRegion).Region

foreach ($AwsRegion in $AwsRegions) {
    $OneRegion = $AwsRegion.tostring()

    #Internet Gateway Id in object array
    $Ec2IgwIds = ( Get-EC2InternetGateway  -Region $OneRegion).InternetGatewayId

    #Vpc Ids in object array
    $VpcIds = (Get-EC2Vpc -region $OneRegion).VpcId

    foreach ($Ec2Igw in $Ec2IgwIds) {
        $Ec2IgwStr = $Ec2Igw.tostring()

        foreach ($VpcId in $VpcIds) {
            $VpcIdStr = $VpcId.tostring()

            #Detach/Dismount igw from vpc
            Dismount-EC2InternetGateway -VpcId $VpcIdStr -InternetGatewayId $Ec2IgwStr -Region $OneRegion

        }
            Remove-EC2InternetGateway -InternetGatewayId $Ec2IgwStr -Region $OneRegion -Force

        }

    }
