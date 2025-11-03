# 🔐 Azure bejelentkezés és előkészítés

Connect-AzAccount                      # Bejelentkezés az Azure fiókba
Get-AzSubscription                     # Elérhető előfizetések lekérdezése
Set-AzContext -SubscriptionName "Azure subscription 1"  # Aktív előfizetés kiválasztása
Get-AzResourceGroup                    # Meglévő Resource Group-ok listázása


# 🧱 Resource Group létrehozása és törlése

New-AzResourceGroup -Name "SZOMBAT" -Location "northeurope"   # Új RG létrehozása
Remove-AzResourceGroup -Name "SZOMBAT" -Force                 # RG törlése megerősítés nélkül


# 🌐 Virtuális hálózat (VNet) létrehozása + Subnet hozzáadása

$vnet = New-AzVirtualNetwork -Name "SZOMBAT-NET" `             # VNet létrehozása
  -ResourceGroupName "SZOMBAT" `
  -Location "northeurope" `
  -AddressPrefix "10.0.0.0/16"

Add-AzVirtualNetworkSubnetConfig -Name "SZOMBAT-NET-SUB1" `    # Subnet létrehozása a VNet-ben
  -AddressPrefix "10.0.1.0/24" `
  -VirtualNetwork $vnet

$vnet | Set-AzVirtualNetwork            # Mentés / frissítés (nélküle nem jön létre a subnet)


# 🌍 Másik példa: Resource Group, VNet, Subnet manuális paraméterezéssel

New-AzResourceGroup -Name proba-rg -Location northeurope       # RG létrehozása
Get-AzResourceGroup -Name proba-rg                             # Ellenőrzés

# Változók
$ResourceGroup="Proba-Rg"
$Location="northeurope"
$VnetName="Proba-Net"
$AddressPrefix="10.1.0.0/16"
$SubnetName="Alap-Subnet"
$SubnetPrefix="10.1.0.0/24"

# Subnet-konfiguráció létrehozása
$SubnetConfig=New-AzVirtualNetworkSubnetConfig -Name $SubnetName `
  -AddressPrefix $SubnetPrefix

# Virtuális hálózat létrehozása a subnettel együtt
New-AzVirtualNetwork -Name $VnetName `
  -ResourceGroupName $ResourceGroup `
  -Location $Location `
  -AddressPrefix $AddressPrefix `
  -Subnet $SubnetConfig

# Új subnet hozzáadása meglévő VNet-hez
$vnet = Get-AzVirtualNetwork -Name $VnetName -ResourceGroupName $ResourceGroup
Add-AzVirtualNetworkSubnetConfig -Name "Munka-Subnet" -AddressPrefix "10.1.1.0/24" -VirtualNetwork $vnet
$vnet | Set-AzVirtualNetwork          # Mentés / frissítés
$vnet = Get-AzVirtualNetwork -Name $VnetName -ResourceGroupName $ResourceGroup  # ← Frissítés!
$vnet.Subnets | Select-Object Name, AddressPrefix

# Subnet törlése
Remove-AzVirtualNetworkSubnetConfig -Name "Munka-Subnet" -VirtualNetwork $vnet
$vnet | Set-AzVirtualNetwork           # Ismét mentés!
$vnet = Get-AzVirtualNetwork -Name $VnetName -ResourceGroupName $ResourceGroup  # ← Frissítés!

# 💻 Alap VM létrehozása (egysoros parancs)

New-AzVM -ResourceGroupName "Proba-Rg" `
  -Location "northeurope" `
  -Name 'UjabbVM' `
  -VirtualNetworkName 'Proba-Net' `
  -SubnetName 'Alap-Subnet' `
  -Image 'MicrosoftWindowsServer:WindowsServer:2022-datacenter-azure-edition:latest' `
  -SecurityGroupName 'Proba-NSG' `
  -PublicIpAddressName 'SajatIP' `
  -OpenPorts 3389

Remove-AzVM -Name 'UjabbVM' -ResourceGroupName "Proba-Rg"      # VM törlése


# ⚙️ Haladó VM létrehozás részletes komponensekkel

# Alapváltozók
$ResourceGroup = "Proba-Rg"
$Location = "northeurope"
$VmName = "ProbaVM"
$VnetName = "Proba-Net"
$SubnetName = "Alap-Subnet"
$AddressPrefix = "10.1.0.0/16"
$SubnetPrefix = "10.1.1.0/24"

# Resource Group létrehozása
New-AzResourceGroup -Name $ResourceGroup -Location $Location

# VNet létrehozása
$vnet = New-AzVirtualNetwork -ResourceGroupName $ResourceGroup `
    -Location $Location `
    -Name $VnetName `
    -AddressPrefix $AddressPrefix

# Subnet hozzáadása
Add-AzVirtualNetworkSubnetConfig -Name $SubnetName `
    -AddressPrefix $SubnetPrefix `
    -VirtualNetwork $vnet

# VNet mentése
$vnet | Set-AzVirtualNetwork

# Frissített VNet és Subnet lekérése
$vnet = Get-AzVirtualNetwork -Name $VnetName -ResourceGroupName $ResourceGroup
$subnet = Get-AzVirtualNetworkSubnetConfig -Name $SubnetName -VirtualNetwork $vnet

# Public IP cím létrehozása
$PublicIP = New-AzPublicIpAddress -Name "$VmName-pip" `
    -ResourceGroupName $ResourceGroup `
    -Location $Location `
    -AllocationMethod Static `
    -Sku Standard

# NSG + RDP szabály
$RDP = New-AzNetworkSecurityRuleConfig -Name "RDP-Allow" `
    -Protocol Tcp `
    -Direction Inbound `
    -Priority 1001 `
    -SourceAddressPrefix * `
    -SourcePortRange * `
    -DestinationAddressPrefix * `
    -DestinationPortRange 3389 `
    -Access Allow

$nsg = New-AzNetworkSecurityGroup -ResourceGroupName $ResourceGroup `
    -Location $Location `
    -Name "$VmName-nsg" `
    -SecurityRules $RDP

# NIC IP Config létrehozása - JAVÍTVA
$IPConfig = New-AzNetworkInterfaceIpConfig -Name "$VmName-ipconfig" `
    -SubnetId $subnet.Id `
    -PublicIpAddressId $PublicIP.Id `
    -Primary

# NIC létrehozása
$nic = New-AzNetworkInterface -Name "$VmName-nic" `
    -ResourceGroupName $ResourceGroup `
    -Location $Location `
    -IpConfiguration $IPConfig `
    -NetworkSecurityGroupId $nsg.Id

# Hitelesítés
$cred = New-Object System.Management.Automation.PSCredential ("azureadmin", (ConvertTo-SecureString "Password2025!" -AsPlainText -Force))

# VM konfiguráció
$vmconfig = New-AzVMConfig -VMName $VmName -VMSize "Standard_D2s_v3" `
  | Set-AzVMOperatingSystem -Windows -ComputerName $VmName -Credential $cred -ProvisionVMAgent -EnableAutoUpdate `
  | Set-AzVMSourceImage -PublisherName "MicrosoftWindowsServer" `
    -Offer "WindowsServer" -Skus "2022-datacenter-azure-edition" -Version "latest" `
  | Add-AzVMNetworkInterface -Id $nic.Id

# VM létrehozása
New-AzVM -ResourceGroupName $ResourceGroup -Location $Location -VM $vmconfig


# ------------
# Felhasznalok
# ------------

Connect-AzureAD                              
# 1. Meglévő felhasználók és csoportok lekérdezése
Get-AzADUser
Get-AzADGroup

# 2. ÚJ FELHASZNÁLÓ létrehozása (CSAK az új verzió!)
New-AzADUser -DisplayName "Gipsz Jakab" `
  -UserPrincipalName "GJ@xnex88hotmail.onmicrosoft.com" `
  -Password (ConvertTo-SecureString "Jelszo2025!" -AsPlainText -Force) `
  -AccountEnabled $true `
  -MailNickname "Gipsz"

# 3. ÚJ CSOPORT létrehozása
New-AzADGroup -DisplayName "Dolgozok" -MailNickname "Dolgozok"

# 4. FELHASZNÁLÓ HOZZÁADÁSA csoporthoz
# Módszer 1: UserPrincipalName alapján
Add-AzADGroupMember -MemberUserPrincipalName "GJ@xnex88hotmail.onmicrosoft.com" -TargetGroupDisplayName "Dolgozok"

# Módszer 2: ObjectId alapján (megbízhatóbb)
$user = Get-AzADUser -UserPrincipalName "GJ@xnex88hotmail.onmicrosoft.com"
$group = Get-AzADGroup -DisplayName "Dolgozok"
Add-AzADGroupMember -MemberObjectId $user.Id -TargetGroupObjectId $group.Id

# 5. FELHASZNÁLÓ lekérdezése
Get-AzADUser -UserPrincipalName "GJ@xnex88hotmail.onmicrosoft.com"

# 6. FELHASZNÁLÓ TÖRLÉSE
Remove-AzADUser -UserPrincipalName "GJ@xnex88hotmail.onmicrosoft.com"

# 7. FELHASZNÁLÓ MÓDOSÍTÁSA
# FIGYELEM: Az ObjectId-t le kell kérdezned előtte!
$user = Get-AzADUser -UserPrincipalName "GJ@xnex88hotmail.onmicrosoft.com"
Update-AzADUser -ObjectId $user.Id -DisplayName "Ez az uj display name"

# 8. CSOPORT TAGOK lekérdezése
$group = Get-AzADGroup -DisplayName "Dolgozok"
Get-AzADGroupMember -GroupObjectId $group.Id

# 9. FELHASZNÁLÓ ELTÁVOLÍTÁSA csoportból
$user = Get-AzADUser -DisplayName "Gipsz Jakab"
$group = Get-AzADGroup -DisplayName "Dolgozok"
Remove-AzADGroupMember -MemberObjectId $user.Id -GroupObjectId $group.Id