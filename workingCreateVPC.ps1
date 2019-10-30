# This script will create a VPC, Private and Public Subnet, Internet Gateway attached to the VPC, create custom Route Tables,
# and finally create a Security Group in every AWS region. 
# To execute these scripts in PoweShell you must have the AWS SDK installed for PowerShell.  

$awsRegions = ((Get-AWSRegion).Region)
# VPC CIDR
$ADVPC = "192.168.0.0/16"
#$awsRegion = "us-east-1"

#Going through each region one by one
foreach ($awsRegion in $awsRegions) {

#Create VPC non default virtual private cloud/virtual network, enable dns hostnames and tag the vpc resource
$Ec2Vpc = New-EC2Vpc  -CidrBlock $ADVPC -Region $awsRegion -InstanceTenancy default
Edit-EC2VpcAttribute -VpcId $Ec2Vpc.VpcId -Region $awsRegion -EnableDnsHostnames $true
$TagVPC = New-Object Amazon.EC2.Model.Tag
$TagVPC.Key = "Name"
$TagVPC.Value = "Active Diretory VPC"
New-EC2Tag -Resource $Ec2Vpc.VpcId -Region $awsRegion -Tag $TagVPC

#Create Public Subnet
$Ec2subnet1 = New-EC2Subnet -VpcId $Ec2Vpc.VpcId -CidrBlock "192.168.4.0/23" -Region $awsRegion
$TagSn1 = New-Object Amazon.EC2.Model.Tag
$TagSn1.Key = "Name"
$TagSn1.Value = "Public Subnet"
New-EC2Tag -Resource $Ec2subnet1.SubnetId -Region $awsRegion -Tag $TagSn1
Edit-EC2SubnetAttribute -SubnetId $Ec2subnet1.SubnetId -MapPublicIpOnLaunch $false -Region $awsRegion


# Create Private Subnet 
$Ec2subnet2 = New-EC2Subnet -VpcId $Ec2Vpc.VpcId -CidrBlock "192.168.3.0/23" -Region $awsRegion
$TagSn2 = New-Object Amazon.EC2.Model.Tag
$TagSn2.Key = "Name"
$TagSn2.Value = "Private Subnet"
New-EC2Tag -Resource $Ec2subnet2.SubnetId -Region $awsRegion -Tag $TagSn2
Edit-EC2SubnetAttribute -SubnetId $ec2subnet2.SubnetId -MapPublicIpOnLaunch $false -Region $awsRegion 

#Create Internet Gateway and attach it to the VPC
$Ec2InternetGateway = New-EC2InternetGateway -Region $awsRegion

Add-EC2InternetGateway -InternetGatewayId $Ec2InternetGateway.InternetGatewayId -VpcId $ec2Vpc.VpcId -Region $awsRegion

$TagIGW = New-Object Amazon.EC2.Model.Tag
$TagIGW.Key = "Name"
$TagIGW.Value = "Active Directory IGW"
New-EC2Tag -Resource $Ec2InternetGateway.InternetGatewayId -Tag $TagIGW -Region $awsRegion


#Create custom route table with route to the internet and associate it with the subnet
$Ec2RouteTable = New-EC2RouteTable -VpcId $Ec2Vpc.VpcId -Region $awsRegion

$TagRT = New-Object Amazon.EC2.Model.Tag
$TagRT.Key = "Name"
$TagRT.Value = "Active Directory RT"
New-EC2Tag -Resource $Ec2RouteTable.RouteTableId -Region $awsRegion -Tag $TagRT 
New-EC2Route -RouteTableId $Ec2RouteTable.RouteTableId -DestinationCidrBlock "0.0.0.0/0" -GatewayId $Ec2InternetGateway.InternetGatewayId -Region $awsRegion

Register-EC2RouteTable -RouteTableId $Ec2RouteTable.RouteTableId -SubnetId $Ec2subnet1.SubnetId -Region $awsRegion

Register-EC2RouteTable -RouteTableId $Ec2RouteTable.RouteTableId -SubnetId $Ec2subnet2.SubnetId -Region $awsRegion



#Create security group with a rule to enable remote desktop access to the EC2Instance.

#Create Security group and firewall rule for RDP
$SecurityGroup = New-EC2SecurityGroup -Description "Active Directory SG" -GroupName "Active Directory SG" -VpcId $Ec2Vpc.VpcId -Region $awsRegion

$ipinfo = Invoke-RestMethod http://ipinfo.io/json | Select-Object -ExpandProperty ip
$ipCidr = $ipinfo + "/32" 

$TagSg = New-Object Amazon.EC2.Model.Tag
$TagSg.Key = "Name"
$TagSg.Value = "Active Directory SG"
New-EC2Tag -Resource $SecurityGroup -Region $awsRegion -Tag $TagSg 
$RdpIpRole = New-Object Amazon.EC2.Model.IpPermission
$RdpIpRole.ToPort = 3389
$RdpIpRole.FromPort = 3389
$RdpIpRole.IpProtocol = "tcp"
$RdpIpRole.IpRanges.Add($ipCidr)
Grant-EC2SecurityGroupIngress -GroupId $SecurityGroup -IpPermission $RdpIpRole -Force -Region $awsRegion


}


