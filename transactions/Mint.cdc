import FungibleToken from 0x01
import HotToken from 0x01

transaction(receiver: Address, amount: UFix64) {

    prepare(signer: AuthAccount) {
        // Borrow the HotToken Minter reference
        let minter = signer.borrow<&HotToken.Minter>(from: /storage/MinterStorage)
            ?? panic("You are don't have access to mint")
        
        // Borrow the receiver's HotToken Vault capability
        let receiverVault = getAccount(receiver)
            .getCapability<&HotToken.Vault{FungibleToken.Receiver}>(/public/Vault)
            .borrow()
            ?? panic("Error: Check your HotToken Vault status")
        
        // Minted tokens reference
        let mintedTokens <- minter.mintToken(amount: amount)

        // Deposit minted tokens into the receiver's HotToken Vault
        receiverVault.deposit(from: <-mintedTokens)
    }

    execute {
        log(amount.toString().concat(" Tokens minted and deposited"))
    }
}
