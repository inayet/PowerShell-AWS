#Purpose would be to remove entire VPC
#Gets all AWS Regions in an object array 

#Set-StrictMode -Version Latest

$awsRegions = ((Get-AWSRegion).Region)



#Going through each region one by one
foreach ($awsRegion in $awsRegions) {
    #Takes each region and converts into a string
    $OneRegion = $awsRegion.tostring();
    $GroupIds = (Get-EC2SecurityGroup -region $OneRegion).GroupId

    $GroupNames = (Get-EC2SecurityGroup -region $OneRegion).GroupName

    $UniqueGroupNames = foreach ($GroupName in $GroupNames) {

        if(Compare-Object $GroupName.GetType() $GroupNames.GetType()){
            foreach ($EachGroupName in $GroupName) {
              
                   # Write-Host 
                    $EachGroupName.tostring();
               

            }

        } else {
            #Write-Host
            $GroupName.tostring();

        }

    }

   # write-host $UniqueGroupNames.GetType() "unique group names"
   # Write-Host $UniqueGroupNames.GetType()

    $GroupStatus = foreach ($UniqueGroupName in $UniqueGroupNames) {
       #Write-Host 
       $UniqueGroupName.tostring()
    }

     foreach ($SingleGroupStatus in $GroupStatus) {
        if($SingleGroupStatus -ne "default" ){
            #Remove Security Group in every region
            foreach ($GroupId in $GroupIds) {
   
               if(Compare-Object $GroupId.GetType() $GroupIds.GetType()){
                   foreach ($item in $GroupId) {
                   #  Write-Host
   
                   $item.tostring();
   
                   }
   
               } else {
                   #Write-Host
                   $GroupId.tostring();
   
               }
   
               $StrGroupId = $GroupId.tostring();

               $GroupNameId = (Get-EC2SecurityGroup -GroupId $StrGroupId -Region $OneRegion).GroupName

        
   
               if($StrGroupId -ne $null){
                if($GroupNameId -ne "default") {
               Remove-EC2SecurityGroup -GroupId $StrGroupId -Region $OneRegion -Force
            }
               }
   
           }
   
       }
    }



        #Need to first delete  VPC sub-components like subnets, route tables,
        ##security groups






}

