
#Gets all AWS Regions in an object array
$awsRegions = ((Get-AWSRegion).Region)


foreach ($awsRegion in $awsRegions) {

        # Main Variables
        $OneRegion = $awsRegion.tostring();

        # Get all keypairs in object array
        $AllKeyPairs = (Get-EC2KeyPair -Region $OneRegion).KeyName

        foreach ($UniqueKeyPair in $AllKeyPairs) {
           $StrKeyPair =  $UniqueKeyPair.tostring();
           if($StrKeyPair -ne "devops" -and $StrKeyPair -ne "phil-inayet"){
                Remove-EC2KeyPair -KeyName $UniqueKeyPair -Region $OneRegion  -Force

            }

        }



    }