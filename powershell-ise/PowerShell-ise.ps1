Clear-Host
[int]$a= Read-Host " Irj be egy szamot"
[int]$b= Read-Host " Irj be egy masik szamot"
if ($a -lt $b)
{Write-Host "$a kisebb mint $b"}
elseif ($a -gt $b)
{Write-Host "$a nagyobb mint $b"}
else
{Write-Host "$a egyenlo $b"}


Clear-Host
[int]$a= Read-Host "Melyik evben szulettel"
$b = (Get-Date).year - $a
Write-Host "$b eves vagy"

# Ciklusok

Clear-Host
[int]$a= Read-Host "Melyen jegyet kaptal?"
if ($a -eq 1)
{Write-Host "Kituno"}
elseif ($a -eq 2)
{Write-Host "Jeles"}
elseif ($a -eq 3)
{Write-Host "Jo"}
elseif ($a -eq 4)
{Write-Host "Elegseges"}
elseif ($a -eq 5)
{Write-Host "Elegtelen"}
else 
{Write-Host "Nincs ilyen jegy"}

# Switch ciklus

Clear-Host
[int]$a= Read-Host "Melyen jegyet kaptal?"
Switch ($a)
{
    1 {Write-Host "Kituno";break}
    2 {Write-Host "Jeles";break}
    3 {Write-Host "Jo";break}
    4 {Write-Host "Elegseges";break}
    5 {Write-Host "Elegtelen";break}
    default {Write-Host "Ilyen jegy nincs"}
    
}

# for while Ciklusok

Clear-Host
for ($i=5;$i -lt 10; $i+=2)
{
    Write-Host ($i,'. alkalom')
}

Clear-Host
$j=1
while($j -lt 10)
{
    Write-Host ($j,'. alkalom')
    $j++
}

# do while until Ciklusok 

Clear-Host
$k=1
do
{
    Write-Host ($k,". sor")
    $k++
}
while ($k -le 10)

Clear-Host
$k=1
do
{
    Write-Host ($k,". sor")
    $k++
}
until ($k -gt 10)


# Guessing Game
Clear-Host
[int]$read = Read-Host "Milyen szamra gondoltam? 1 -100"
[int]$random = Get-Random -Minimum 1 -Maximum 101
while ($read -ne $random)
{
    Write-Host "Nem talalt"
        if ($read -lt $random)
        {
            Write-Host "nagyobb"
        }
    elseif ($read -gt $random)
        {
            Write-Host "kisebb"
        }
    [int]$read = Read-Host "Próbáld újra"

    
}
Write-host "Eltalaltad a $random szamra gondoltam"


#Tömbök

Clear-Host
$tomb = @(11,20,34,3.14,56,77,987,190)
$tomb[0]
$tomb[0]+2
$meret=$tomb.Length
$meret


Clear-Host
$tomb = @(11,20,34,3.14,56,77,987,190)
$szum = 0
foreach ($adat in $tomb)
{
    $szum+=$adat
}
Write-Host "Az osszeg: $szum"

$db=$tomb.Length - 1
for ($db;$db -ge 0;$db--)
{Write-Host $tomb[$db]}


# File check

Clear-Host
$allomany="feladat.txt"
$path="C:\"
if (Test-Path $path\$allomany)
{
    Write-Host "Az allomany letezik"
}
else
{
    Write-Host "Az allomany nem letezik"
}

#---------
# AD users
#---------


Clear-Host
$username = "Dolgozo"
$path = "OU=TH1,OU=KOZPONT,DC=INTER,DC=NET"
$count=2..10
foreach ($i in $count) 
{
    New-ADUser $username$i -Path $path -Enabled $true -ChangePasswordAtLogon $true `
    -AccountPassword (ConvertTo-SecureString "Jelszo 2025" -AsPlainText -Force) -PassThru
}


Clear-Host
$ADusers = Import-Csv F:\userek.csv
foreach ($user in $ADusers)
{
    $username = $user.username
    $password = $user.password
    $firstname = $user.firstname
    $lastname = $user.lastname
    $department = $user.department
    $OU = $user.OU

    # Ellenorzes
    if (Get-ADUser -F {SamAccountName -eq $username})
    {
        Write-Warning "A felhasznalo mar letezik"
    }
    else
    {
        New-ADUser -SamAccountName $username `
        -UserPrincipalName "$username@inter.net" `
        -Name "$firstname $lastname" `
        -GivenName $firstname `
        -Surname $lastname `
        -Enabled $true `
        -ChangePasswordAtLogon $true `
        -DisplayName "$lastname $firstname" `
        -Department $department `
        -Path $OU `
        -AccountPassword (ConvertTo-SecureString $password -AsPlainText -Force)
    }
}



$path="OU=teszt,OU=kozpont,dc=inter,dc=net"
$username="Teszt"
$db=1..5
$password=(ConvertTo-SecureString "Jelszo 2025!" -AsPlainText -Force)
foreach ($i in $db) {New-ADUser -Name $username$i -Path $path -AccountPassword $password -PassThru `
    -Enabled $true -ChangePasswordAtLogon}



Clear-Host
$ido = (Get-Date).AddDays(-5)
Get-ADUser -Filter * -Properties whenCreated |
ForEach-Object {
    if ($_.whenCreated -lt $ido) {
        Write-Host $_.Name
    }
}

Clear-Host
$db=1..5
foreach ($i in $db) {
Set-ADUser -Identity teszt$i -Enabled $false
}


param ([string]$nev="ismeretlen")
Write-Output "Neved: $nev"

param (
    [parameter(Mandatory=$true)]
    [string]$nev
)
Write-Output "Neved: $nev"


