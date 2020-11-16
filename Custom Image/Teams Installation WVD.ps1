#Open an elevated cmd or PowerShell prompt and run the following command to identify the host as running in WVD
reg add "HKLM\SOFTWARE\Microsoft\Teams" /v IsWVDEnvironment /t REG_DWORD /d 1 /f

#VisualC++ Source x64
$VisualCSource = "https://aka.ms/vs/16/release/vc_redist.x64.exe"

#Remote Desktop WebRTC Redirector Service Source
$RDWRedirectorSource = "https://query.prod.cms.rt.microsoft.com/cms/api/am/binary/RE4AQBt"

#Teams Source x64
$TeamsSource = "https://statics.teams.cdn.office.net/production-windows-x64/1.3.00.21759/Teams_windows_x64.msi"

#Download Location
$location = "D:\"
$locationRDWR = "D:\MsRdcWebRTCSvc_HostSetup_1.0.2006.11001_x64.msi"
$locationvcc = "D:\vc_redist.x64.exe"
$locationteamsdownload = "C:\"
$locationteams = "C:\Teams_windows_x64.msi"

Set-ExecutionPolicy Unrestricted

#Download VisualC++ x64
Start-BitsTransfer -Source $VisualCSource -Destination $location
Start-Process -FilePath "$locationvcc" /quiet

#Download Remote Desktop WebRTC Redirector Service Source
Invoke-WebRequest -Uri $RDWRedirectorSource -OutFile $locationRDWR
Start-Process -FilePath "$locationRDWR" /quiet

#Download Teams Source x64
Start-BitsTransfer -Source $TeamsSource -Destination $locationteamsdownload

#Run this following command to install Teams
msiexec /i $locationteams /l*v teams_install.log ALLUSERS=1 ALLUSER=1