
#--------------
# File kezeles
#--------------


Clear-Host
Write-Host
Read-Host
Write-Output
Get-ChildItem

Get-Help -name Get-Process -Examples
Get-ChildItem -Include *.txt -Recurse 
Get-ChildItem | Sort-Object -Descending
Get-ChildItem | Select-Object -First 25 | Sort-Object -Descending
Get-ChildItem | Sort-Object -Property Length -Descending | Select-Object -First 20
Get-Service
Get-EventLog -LogName Application -Newest 10

Start-Process notepad.exe
Stop-Process -Name notepad -Force

New-Item -Path c:\ -Name MUNKA -ItemType Directory
Remove-Item -Path c:\MUNKA -Recurse -Force

New-Item -Path c:\ -Name feladat.txt -ItemType File -Value "Ez egy tesztfájl."
Add-Content -Path c:\feladat.txt -Value "Ez a második sor."
Set-Content -Path c:\feladat.txt -Value "Ez felülírja a fájl tartalmát."
Get-Content -Path c:\feladat.txt
Rename-Item -Path c:\feladat.txt -NewName c:\feladat_uj.txt
Copy-Item -Path c:\feladat_uj.txt -Destination c:\MUNKA\
Move-Item -Path c:\feladat_uj.txt -Destination c:\MUNKA\
Remove-Item -Path c:\MUNKA\feladat_uj.txt -Force
Write-Host "Hideg van" -BackgroundColor Yellow -ForegroundColor Blue

Test-Path -Path c:\MUNKA\feladat_uj.txt
Clear-Content -Path c:\MUNKA\feladat_uj.txt

Get-Date | Format-List
Get-Date -DisplayHint Date
Get-Date.AddDays(-5)
Get-TimeZone
Set-TimeZone -id "central europe standard time"

$a="Ez egy szöveg"
$a.GetType()
Write-Output $a.Length
Write-Output $a.ToUpper()
Write-Output $a.Split()

$file=(Get-ChildItem C:\MUNKA\feladat_uj.txt).Attributes
$file.Attributes= 'ReadOnly'
$file.Attributes= 'Archive'
$file.Attributes= 'Hidden'

$file | Get-Member

Get-Variable
Remove-Variable -Name a
Clear-Variable -Name A

#FONTOS
Get-ExecutionPolicy
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned
#FONTOS

Get-ChildItem -Path c:\Windows\System32\ | Where-Object {$_.Name -like "D*"} | Select-Object Name, Length

Get-ComputerInfo -Property "*version*"
Get-CimInstance -ClassName Win32_OperatingSystem | Select-Object Caption, Version, BuildNumber
Get-CimInstance -ClassName Win32_QuickFixEngineering | Select-Object HotFixID, Description, InstalledOn
Get-CimInstance -ClassName Win32_LogicalDisk
Get-CimInstance -ClassName Win32_BIOS

Rename-Computer -NewName "NewComputerName" -Force -Restart


#-------------
# LemezKezelés
#-------------


Get-Command -Module Storage
Get-PhysicalDisk
Get-Disk
Get-Partition
Get-Volume
Get-FileSystem
Get-PSDrive

Get-Disk | Where-Object IsOffline -eq $true
Get-Disk | Where-Object IsSystem -eq $true

Initialize-Disk -Number 1 -PartitionStyle GPT
New-Partition -DiskNumber 1 -Size 60GB -DriveLetter G
New-Partition -DiskNumber 1 -UseMaximumSize -DriveLetter H
Format-Volume -DriveLetter G -FileSystem NTFS -Confirm:$false
Format-Volume -DriveLetter H -FileSystem ReFS -Confirm:$false
Get-Volume | Where-Object {$_.DriveType -eq 'fixed' -and $_.DriveLetter}

Clear-Disk -Number 1 -RemoveData -RemoveOEM

New-PSDrive -PSProvider FileSystem -Name Z -Root 'C:\20250906\'

#----------
# Megosztas
#----------


New-SmbShare -Name Kozos -Path j:\Kozos\ -FullAccess Administrator
Get-SmbShareAccess -Name Kozos
Remove-SmbShare -Name Kozos -Force
New-SmbShare -Name Kozos -Path j:\Kozos\ -FullAccess Administrator -ChangeAccess Users -ReadAccess everyone
Grant-SmbShareAccess -Name Kozos -AccountName everyone -AccessRight full -Force
Revoke-SmbShareAccess -Name Kozos -AccountName everyone 

#-------------
# Felhasználók
#-------------


whoami.exe /user
whoami.exe /groups

Get-LocalUser
Get-LocalUser -Name Administrator | Select-Object name, sid
Get-Command -Module Microsoft.PowerShell.LocalAccounts

$jelszo = ConvertTo-SecureString "Jelszo1234" -AsPlainText -Force
New-LocalUser -Name user2 -Password $jelszo -FullName "Masodik Felhasznalo" -Description "Ez egy masik felhasznalo"
Set-LocalUser -Name user1 -Password $jelszo -Verbose
Set-LocalUser -Name user1 -PasswordNeverExpires $true
Get-LocalUser -Name user1 | Select-Object -Property *

New-LocalGroup -Name Felhasznalok -Description "Itt lesznek a felhasznalok"
Add-LocalGroupMember -Group Felhasznalok -Member user1
Get-LocalGroupMember -Group Felhasznalok

foreach($csoport in Get-LocalGroup){if (Get-LocalGroupMember $csoport -Member user1 -ErrorAction SilentlyContinue){$csoport.name}}


#--------
# Halozat
#--------


Get-NetIPConfiguration
Get-NetAdapter
Rename-NetAdapter -Name Ethernet -NewName BELSO
Get-NetAdapter -InterfaceIndex 5 | Disable-NetAdapter
New-NetIPAddress -IPAddress 192.168.1.100 -DefaultGateway 192.168.1.1 -PrefixLength 24 -InterfaceAlias BELSO
Get-NetIPAddress -AddressFamily ipv4 -InterfaceIndex 5
Set-DnsClientServerAddress -InterfaceIndex 5 -ServerAddresses 127.0.0.1
Set-DnsClientServerAddress -InterfaceIndex 5 -ResetServerAddresses
Restart-NetAdapter -InterfaceIndex 5
Disable-NetAdapterBinding -Name belso -ComponentID ms_tcpip6


Get-PSDrive
New-PSDrive -Name I -Root K:\ISKOLA\ -PSProvider FileSystem
Get-ADUser -Filter * | Select-Object name >user.txt
Get-ADUser -Filter {enabled -eq "False"} | Select-Object samaccountname, name




#-------
# Server
#-------


Get-WindowsFeature
Get-WindowsFeature | Where-Object {$_.installstate -eq 'installed'}
Get-WindowsFeature | Where-Object {!$_.installstate -eq 'installed'}
Install-WindowsFeature -Name windows-server-backup -LogPath F:\telepites.txt -Verbose
Install-WindowsFeature -Name web-server -IncludeAllSubFeature -IncludeManagementTools -Verbose
Remove-WindowsFeature -Name windows-server-backup, search-service -Verbose -LogPath F:\telepites.txt

Install-WindowsFeature -Name AD-Domain-Services -IncludeManagementTools
Install-ADDSForest -DomainName INTER.NET -DomainNetbiosName INTER -InstallDns
Import-Module ActiveDirectory

Get-ADUser -Filter *
Get-ADUser -Filter * -Properties name,whencreated | Select-Object name, whencreated
Get-ADUser -Identity user2
Get-ADUser -Identity user2 -Properties *
Get-ADUser -Identity user2 | Set-ADUser -PasswordNeverExpires:$true

Set-ADUser -Identity user2 -Title 'Junior rendszeruzemelteto'
Set-ADUser -Identity user2 -EmailAddress 'user2@ezamail.com' -LogonWorkstations 'win10,win11'

New-ADUser -Name "Nagy Ferenc" -GivenName "Nagy" -Surname "Ferenc" -SamAccountName nagyf -UserPrincipalName nagyf@inter.net -AccountPassword(Read-Host -AsSecureString "jelszo")  -Enabled $true
New-ADUser -Name Vezeto1 -SamAccountName Vezeto1 -UserPrincipalName vezeto1@inter.net -AccountPassword (ConvertTo-SecureString 'Jelszo1234' -AsPlainText -Force) -Enabled $true -path "OU=TH2,OU=KOZPONT,DC=INTER,DC=NET"

Get-ADDomain
Get-ADDomainController
Get-ADComputer -Filter *
Get-ADOrganizationalUnit -Filter *
Get-ADOrganizationalUnit -Filter * | Select-Object name

New-ADOrganizationalUnit -Name MUNKA
New-ADOrganizationalUnit -Name MUNKA3 -Path "OU=MUNKA,DC=INTER,DC=NET"
Set-ADOrganizationalUnit -Identity "OU=MUNKA2,DC=INTER,DC=NET" -ProtectedFromAccidentalDeletion $false
Remove-ADOrganizationalUnit -Identity "OU=MUNKA2,DC=INTER,DC=NET"
Move-ADObject -Identity "OU=MUNKA2,DC=INTER,DC=NET" -TargetPath "OU=MUNKA,DC=INTER,DC=NET"

New-ADGroup -Name DOLGOZOK -GroupScope Global -GroupCategory Security
Get-ADGroup -Filter * | Select-Object name
New-ADGroup -Name Felhasznalok -Path "OU=MUNKA,DC=INTER,DC=NET" -GroupCategory Security -GroupScope Global
Add-ADGroupMember -Identity Felhasznalok -Members user1

Get-ADDefaultDomainPasswordPolicy
Set-ADDefaultDomainPasswordPolicy -Identity inter.net -MinPasswordLength 4 -LockoutThreshold 4 -ComplexityEnabled $false


New-ADUser -Name Dolgozo1 `
-SamAccountName Dolgozo1 `
-UserPrincipalName dolgozi1@inter.net `
-AccountPassword (ConvertTo-SecureString "Jelszo 2025" -AsPlainText -Force) `
-Enabled $true `
-Path "OU=TH1,OU=KOZPONT,DC=INTER,DC=NET"

Add-DhcpServerv4Scope -Name "Kiindulas" -StartRange 192.168.10.100 -EndRange 192.168.10.150 -SubnetMask 255.255.255.0 -State Active
Set-DhcpServerv4OptionValue -ScopeId 192.168.10.0 -Router 192.168.10.1
Set-DhcpServerv4OptionValue -ScopeId 192.168.10.0 -DnsServer 192.168.10.1 -DnsDomain INTER.NET
Add-DhcpServerInDC -DnsName 'inter.net' -IPAddress 192.168.10.1


Install-WindowsFeature -Name FS-Resource-Manager -IncludeManagementTools
New-FSRMQuota -Path K:\Munka -Description "Ez korlatozva van 100MB-ra" -Size 100MB

Install-WindowsFeature -Name Web-server -IncludeAllSubFeature -IncludeManagementTools

# Domain installation - Connect DC2 to the domain

Add-Computer -DomainName inter.net                                          # DC2
Install-WindowsFeature -Name AD-Domain-Services -IncludeManagementTools     # DC2
Import-Module ADDSDeployment                                                # DC2
Install-ADDSDomainController -DomainName 'example.com' -InstallDns -ReplicationSourceDC "dc1.example.com" -NoGlobalCatalog:$false -Force:$true -Credential (Get-Credential)

