


#Windows Login user
$AdminUser = "sqlserver\Administrator"

# Read-Host "Enter Password" -AsSecureString | ConvertFrom-SecureString | Out-File ./adminCreds.txt
$AdminPassword = Get-Content -Path “C:\Users\Administrator\Desktop\adminSqlCreds.txt” | ConvertTo-SecureString

#Creates secure credentials
$adminCreds = New-Object System.Management.Automation.PSCredential ($AdminUser,$AdminPassword) 

# To get it to work with Linux PS Core ?
##$sessOpt = New-PSSessionOption -SkipCACheck -SkipCNCheck 

#Opening a persistent connection to host hosting the MySQL database.
$sess = New-PSSession -ComputerName 192.168.3.120 -Credential $adminCreds -Authentication Negotiate 

#Entering the session 
Enter-PSSession $sess

$command = {
#To set the MySQl path to the MySQL installed bin folder
$mysqlpath = "C:\Program Files\MySQL\MySQL Server 8.0\bin"

#To specify where we need to store the backups
$backuppath = "C:\Program Files\MySQL\MySQL Server 8.0\Backup\"

#The database that we want to work with and backup.
$database = "sql_store"

# Config file contains the mysql credential (MySQL backup will not work if credentials are directly placed inside script)
# In that file password is not secure 
$config = "C:\Users\Administrator\AppData\Roaming\MySQL\.mylogin.cnf"

#Logfile to log the errors if any
$errorLog = "C:\ADMIN\error_dump.log"

# To have the timestamp ready, to be used while uniquely renaming the DB backups
$date = Get-Date
$timestamp=""+$date.day + $date.month + $date.year + "_" + $date.hour + $date.minute +$date.Second

$backupfile = $backuppath + $database + "_" + $timestamp +".sql"

#Backup file name generation
Set-Location $mysqlpath 
.\mysqldump.exe --defaults-extra-file=$config  --login-path=client --log-error=$errorlog --result-file=$backupfile --databases $database 

# Deletes Old backup Files 
Get-ChildItem -Path $backuppath  | Where-Object {
$_.LastWriteTime -le (Get-Date).AddSeconds(-5) } | ForEach-Object {

#Write-Host $_.FullName
Remove-Item $_.FullName


}
Set-Location $backuppath
#Exit-PSSession
}

Invoke-Command -Session $sess -ScriptBlock $command
