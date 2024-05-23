/**
 * This module, `virtualbank::hk`, defines the structure and initialization logic
 * for a hypothetical virtual bank system on the Sui blockchain, specifically tailored for Hong Kong.
 * It creates a new currency within the Sui ecosystem, demonstrating issuance and initial setup of a digital asset.
 *
 * ## Structs
 * - `HK`: Represents the base struct for the Hong Kong virtual bank system. It does not contain fields in this snippet but serves as a placeholder for future extensions or type checking.
 *
 * ## Constants
 * - `SendAddress`: A constant address (`address`) set to `@0x01`, which could be used as a default or treasury address.
 *
 * ## Functions
 * ### `init`
 * - **Description**: The `init` function initializes the virtual bank by creating a new currency with the name "HK".
 *   It sets up the initial treasury capability and metadata for the currency, freezing the coin's metadata for immutability
 *   and transferring the treasury capability to the sender's address, effectively minting the initial supply.
 * - **Parameters**:
   - `hk: HK`: An instance of the `HK` struct, used here primarily for type annotation; no direct operation is performed on it.
   - `ctx: &mut TxContext`: A mutable reference to the transaction context, providing transactional context like sender information.
 * - **Actions**:
   - Creates a new currency with 8 decimal places.
   - Sets metadata for the currency with abbreviations and full names indicating it's from Hong Kong.
   - Freezes the coin's metadata to prevent further changes.
   - Transfers the treasury capability to the sender's address, establishing ownership.
 */
module virtualbank::hk {

    use sui::coin::create_currency;
    use sui::tx_context::{TxContext, sender};
    use std::option;
    use sui::transfer;

    public struct HK has drop {}

    const SendAddress: address = @0x01;

    fun init(hk: HK, ctx: &mut TxContext) {
        let (treasury_cap, coin_metadata) =
            create_currency(
                hk,
            8,
            b"HK",
            b"HK  made in hongkong",
            b"HK  made in hongkong",
            option::none(),
            ctx);

        transfer::public_freeze_object(coin_metadata);
        let my_address = sender(ctx);
        transfer::public_transfer(treasury_cap, my_address)
    }
}
