/**
 * The `virtualbank::usd` module outlines a structure and function for initializing a representation of the United States Dollar (USD)
 * within a virtual banking system on the Sui blockchain platform. It follows similar patterns to previous modules for HK and RMB.

 * ## Struct
 * - `USD`: A simple struct declaration for the USD currency type. It serves as a marker for type safety and doesn't encapsulate additional data in this context.

 * ## Function
 * ### `init`
 * - **Purpose**: This function initializes the USD currency by generating the necessary treasury and metadata, then transfers the treasury to the transaction sender.
 * - **Parameters**:
   - `witness: USD`: An instance of the `USD` struct, primarily used for type-checking in the context of this function.
   - `ctx: &mut TxContext`: A mutable reference to the transaction context, providing transaction-related details including the sender's address.
 * - **Functionality**:
   - Utilizes `coin::create_currency` to establish the USD with 6 decimal places, minimal metadata, and no additional arguments.
   - Immediately freezes the created currency's metadata to prevent further modifications.
   - Executes a public transfer of the treasury object to the sender of the transaction, effectively minting the initial USD supply to that account.
 */
module virtualbank::usd {
    use std::option;
    use sui::coin;
    use sui::transfer;
    use sui::tx_context::{Self, TxContext};

    public struct USD has drop {}

    fun init(witness: USD, ctx: &mut TxContext) {
        let (treasury, metadata) = coin::create_currency(witness, 6, b"USD", b"", b"", option::none(), ctx);
        transfer::public_freeze_object(metadata);
        transfer::public_transfer(treasury, tx_context::sender(ctx))
    }
}