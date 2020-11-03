param( 
[parameter(Mandatory=$true)][string]$ouUsers,
[parameter(Mandatory=$true)][string]$ouHosts
)

New-ADOrganizationalUnit -Name $ouUsers
New-ADOrganizationalUnit -Name $ouHosts

#####Security Group Creation
New-ADGroup -Name ’User-Of-WVD’ -GroupCategory ’Security’  
-GroupScope ’DomainLocal’

##################################################
# Add AD Users
##################################################

# Set values for your environment
$numUsers = "10"
$userPrefix = "WVDUser"
$passWord = ""
$userDomain = ""

# Import the AD Module
Import-Module ActiveDirectory

# Convert the password to a secure string
$UserPass = ConvertTo-SecureString -AsPlainText "$passWord" -Force

#Add the users
for ($i=0; $i -le $numUsers; $i++) {
$newUser = $userPrefix + $i
New-ADUser -name $newUser -SamAccountName $newUser -UserPrincipalName $newUser@$userDomain -GivenName $newUser -Surname $newUser -DisplayName $newUser `
-AccountPassword $userPass -ChangePasswordAtLogon $false -PasswordNeverExpires $true -Enabled $true
}

Add-ADGroupMember -Identity User-Of-WVD -Members WVDUser0,WVDUser1,WVDUser2,WVDUser3,WVDUser4,WVDUser5,WVDUser6,WVDUser7,WVDUser8,WVDUser9,WVDUser10
