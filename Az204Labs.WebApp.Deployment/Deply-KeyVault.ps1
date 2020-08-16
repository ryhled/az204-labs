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

# Ge behörigheter att hantera keyvault - https://docs.microsoft.com/en-us/powershell/module/azurerm.keyvault/set-azurermkeyvaultaccesspolicy?view=azurermps-6.13.0
$upn = Get-AzADUser
Set-AzKeyVaultAccessPolicy -VaultName "az-204-labs-webapp-vault" -UserPrincipalName $upn.UserPrincipalName `
    -PermissionsToKeys get,list,update,create,import,delete,recover,backup,restore `
    -PermissionsToSecrets get,list,set,delete,recover,backup,restore,purge `
    -PermissionsToCertificates purge,get,list,update,create,import,delete,recover,backup,restore,managecontacts

$secretValue = ConvertTo-SecureString -String "test123" -AsPlainText -Force
$secret = Set-AzKeyVaultSecret -VaultName "az-204-labs-webapp-vault" -Name "TestSecret" -SecretValue $secretValue 
$secret.Id