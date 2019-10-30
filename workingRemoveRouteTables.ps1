#Set-StrictMode -Version Latest
#Not working need to skip main route table 


$AWSRegions = (Get-AWSRegion).Region


    foreach ($AWSRegion in $AWSRegions) {
        $OneRegion = $AWSRegion.tostring()
    
        $RouteTableIds = (Get-EC2RouteTable -Region $OneRegion).RouteTableId
    
        foreach ($RouteTableId in $RouteTableIds) {

            $MainRtId = ( Get-EC2RouteTable -Region $OneRegion -Filter @{Name="association.main"; Value="true"} ).RouteTableId


                if($RouteTableId -ne $MainRtId) {
                    Remove-EC2RouteTable -Region $OneRegion -RouteTableId $RouteTableId -Force

                }

        }
          
            
    }
    
    
        
    





#Remove-EC2RouteTable -Region us-east-1 -RouteTableId rtb-085631d8dec472ceb  -Force
#Remove-EC2SecurityGroup -GroupId sg-00743e349fb051bcc -Region us-east-1