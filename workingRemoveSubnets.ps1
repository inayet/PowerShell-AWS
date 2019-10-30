#Set-StrictMode -Version Latest

$AWSRegions = (Get-AWSRegion).Region

foreach ($AWSRegion in $AWSRegions) {
    $OneRegion = $AWSRegion.tostring()
    $EC2SubnetIds = (Get-EC2Subnet -Region $OneRegion).SubnetId

    foreach ($EC2Subnet in $EC2SubnetIds) {
        Write-Host $EC2Subnet.GetType()
        Remove-EC2Subnet -SubnetId $EC2Subnet -Region $OneRegion -Force
    }

  
}


