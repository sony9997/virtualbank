/**
 * The `virtualbank::rmb` module represents a virtual bank system for the Chinese Renminbi (RMB)
 * on the Sui blockchain. It contains a struct and a function for creating and initializing the RMB currency.
 *
 * ## Struct
 * - `RMB`: A struct representing the RMB currency. Like the `HK` struct in the previous example, it has no fields here but acts as a type.
 *
 * ## Function
 * ### `init`
 * - **Description**: The `init` function initializes the RMB currency by creating it and transferring its treasury to the sender's address.
 * - **Parameters**:
   - `witness: RMB`: An instance of the `RMB` struct, likely used for type-checking purposes rather than any direct operations.
   - `ctx: &mut TxContext`: A mutable reference to the transaction context, which provides details about the current transaction, such as the sender.
 * - **Actions**:
   - Creates a new RMB currency with 6 decimal places, using the provided `witness` struct and transaction context.
   - Freezes the metadata associated with the RMB currency to ensure immutability.
   - Transfers the treasury capability to the address of the transaction sender, minting the initial supply of RMB.
 */
module virtualbank::rmb {
    use std::option;
    use sui::coin;
    use sui::transfer;
    use sui::tx_context::{Self, TxContext};

    public struct RMB has drop {}

    fun init(witness: RMB, ctx: &mut TxContext) {
      let (treasury, metadata) =
        coin::create_currency(witness, 6, b"RMB", b"", b"", option::none(), ctx);

        transfer::public_freeze_object(metadata);

        transfer::public_transfer(treasury, tx_context::sender(ctx))
    }
}