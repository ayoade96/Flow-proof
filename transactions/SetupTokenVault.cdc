import FungibleToken from 0x01
import HotToken from 0x01

transaction() {

    // Define references
    let userVault: &HotToken.Vault{FungibleToken.Balance, FungibleToken.Provider, FungibleToken.Receiver, HotToken.CollectionPublic}?
    let account: AuthAccount

    prepare(acct: AuthAccount) {

        // Borrow vault capability and set account reference
        self.userVault = acct.getCapability(/public/Vault)
            .borrow<&HotToken.Vault{FungibleToken.Balance, FungibleToken.Provider, FungibleToken.Receiver, HotToken.CollectionPublic}>()

        self.account = acct
    }

    execute {
        if self.userVault == nil {
            // Create and link an empty vault if none exists
            let emptyVault <- HotToken.createEmptyVault()
            self.account.save(<-emptyVault, to: /storage/VaultStorage)
            self.account.link<&HotToken.Vault{FungibleToken.Balance, FungibleToken.Provider, FungibleToken.Receiver, HotToken.CollectionPublic}>(/public/Vault, target: /storage/VaultStorage)
            log("Empty vault created and linked")
        } else {
            log("Vault already exists and is properly linked")
        }
    }
}
