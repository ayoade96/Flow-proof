import FungibleToken from 0x01
import HotToken from 0x01

pub fun main(account: Address) {

    // Attempt to borrow PublicVault capability
    let publicVault: &HotToken.Vault{FungibleToken.Balance, FungibleToken.Receiver, HotToken.CollectionPublic}? =
        getAccount(account).getCapability(/public/Vault)
            .borrow<&HotToken.Vault{FungibleToken.Balance, FungibleToken.Receiver, HotToken.CollectionPublic}>()

    if (publicVault == nil) {
        // Create and link an empty vault if capability is not present
        let newVault <- HotToken.createEmptyVault()
        getAuthAccount(account).save(<-newVault, to: /storage/VaultStorage)
        getAuthAccount(account).link<&HotToken.Vault{FungibleToken.Balance, FungibleToken.Receiver, HotToken.CollectionPublic}>(
            /public/Vault,
            target: /storage/VaultStorage
        )
        log("Empty vault created")
        
        // Borrow the vault capability again to display its balance
        let retrievedVault: &HotToken.Vault{FungibleToken.Balance}? =
            getAccount(account).getCapability(/public/Vault)
                .borrow<&HotToken.Vault{FungibleToken.Balance}>()
        log(retrievedVault?.balance)
    } else {
        log("Vault already exists and is properly linked")
        
        // Borrow the vault capability for further checks
        let checkVault: &HotToken.Vault{FungibleToken.Balance, FungibleToken.Receiver, HotToken.CollectionPublic} =
            getAccount(account).getCapability(/public/Vault)
                .borrow<&HotToken.Vault{FungibleToken.Balance, FungibleToken.Receiver, HotToken.CollectionPublic}>()
                ?? panic("Vault capability not found")
        
        // Check if the vault's UUID is in the list of vaults
        if HotToken.vaults.contains(checkVault.uuid) {
            log(publicVault?.balance)
            log("This is a HotToken vault")
        } else {
            log("This is not a HotToken vault")
        }
    }
}
