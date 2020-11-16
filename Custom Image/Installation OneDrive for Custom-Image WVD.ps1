#Uninstall One Drive current version
#Do it manually through app andp

#OneDrive Per-Machine Source
$OneDriveSource = "https://go.microsoft.com/fwlink/?linkid=2083517"

#Download Location
$locationOneDrivedownload = "C:\OneDriveSetup.exe"

#Uninstall the current version of OneDrive from the programs

#Download OneDrive Per-Machine
Invoke-WebRequest -Uri $OneDriveSource -OutFile $locationOneDrivedownload

#Install OneDrive
C:\OneDriveSetup.exe /allusers
