# Login and set context
# Connect-AzAccount
$context = Get-AzSubscription -SubscriptionName "Windows Azure MSDN - Visual Studio Premium"
Set-AzContext $context

# Create resource group
$rg = New-AzResourceGroup -Name "az-204-labs-webapp-rg" -Location "westeurope"

# Skapa keyvault
# to purge, az keyvault purge --name 'az-204-labs-webapp-vault'
$vault = New-AzKeyVault -VaultName "az-204-labs-webapp-vault" -ResourceGroupName $rg.ResourceGroupName -Location $rg.Location `
    -EnabledForDiskEncryption `
    -EnabledForDeployment `
    -EnabledForTemplateDeployment `

# Ge beh�righeter till azure user (en sj�lv) att hantera keyvault - https://docs.microsoft.com/en-us/powershell/module/azurerm.keyvault/set-azurermkeyvaultaccesspolicy?view=azurermps-6.13.0
$upn = Get-AzADUser
Set-AzKeyVaultAccessPolicy -VaultName "az-204-labs-webapp-vault" -UserPrincipalName $upn.UserPrincipalName `
    -PermissionsToKeys get,list,update,create,import,delete,recover,backup,restore `
    -PermissionsToSecrets get,list,set,delete,recover,backup,restore,purge `
    -PermissionsToCertificates purge,get,list,update,create,import,delete,recover,backup,restore,managecontacts

$secretValue = ConvertTo-SecureString -String "hemlighet fr�n key vault" -AsPlainText -Force
$secret = Set-AzKeyVaultSecret -VaultName "az-204-labs-webapp-vault" -Name "TestSecret" -SecretValue $secretValue 
$secret.Id

## Ge get beh�righet �ver secrets f�r app id som motsvarar v�r webapps app registration i Azure
Set-AzKeyVaultAccessPolicy -VaultName "az-204-labs-webapp-vault" -ServicePrincipalName "120238c9-7552-4f43-97e8-59006afd87ed" `
    -PermissionsToSecrets get