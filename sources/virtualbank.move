
/// Module: virtualbank
/// This module represents a virtual bank system.
module virtualbank::virtualbank {
    // Import necessary modules for balance and coin operations.
    use sui::balance::{Self, Balance};
    use sui::coin::{Self, Coin};

    // Define a constant for insufficient balance error code.
    const EInsufficientBalance: u64 = 11;

    // Define a struct representing administrative capability with a key.
    public struct AdminCap has key {
        id: UID
    }

    // Define a struct representing a bank with a key, which holds two balances and a rate.
    public struct Bank <phantom A, phantom B> has key {
        id: UID, // Unique identifier for the bank.
        coin_a: Balance<A>, // Balance of coin type A.
        coin_b: Balance<B>, // Balance of coin type B.
        rate: u64 // Exchange rate between coin A and coin B.
    }

    // Function to initialize the module by creating and transferring an AdminCap.
    fun init(ctx: &mut TxContext) {
        let admin_cap = AdminCap {
            id: object::new(ctx) // Create a new unique ID for the AdminCap.
        };
        transfer::transfer(admin_cap, tx_context::sender(ctx)) // Transfer the AdminCap to the sender of the transaction.
    }

    // Function to initialize a bank with initial coins and rate.
    public fun initialize<A,B>(_ :&AdminCap, coin1: Coin<A>, coin2: Coin<B>, rate:u64, ctx: &mut TxContext) {
        let mut bank = Bank<A, B> {
            id: object::new(ctx), // Create a new unique ID for the bank.
            coin_a: balance::zero<A>(), // Initialize the balance of coin A to zero.
            coin_b: balance::zero<B>(), // Initialize the balance of coin B to zero.
            rate: rate, // Set the exchange rate.
        };

        // Add the coins to the respective balances of the bank.
        balance::join(&mut bank.coin_a, coin::into_balance(coin1));
        balance::join(&mut bank.coin_b, coin::into_balance(coin2));

        // Share the newly created bank object with the sender of the transaction.
        transfer::share_object(bank)
    }

    // Function to set the exchange rate of the bank.
    public fun set_rate<A, B>(_ :&AdminCap, bank: &mut Bank<A, B>, rate: u64, _ctx: &mut TxContext) {
        bank.rate = rate // Update the exchange rate of the bank.
    }

    // Entry function to add coins to the bank.
    public entry fun add<A, B>(coin1: Coin<A>, coin2: Coin<B>, bank: &mut Bank<A, B>) {
        let balance1 = coin::into_balance(coin1); // Convert the coin to balance format.
        balance::join(&mut bank.coin_a, balance1); // Add the balance to the coin A balance of the bank.
        let balance2 = coin::into_balance(coin2); // Convert the coin to balance format.
        balance::join(&mut bank.coin_b, balance2); // Add the balance to the coin B balance of the bank.
    }

    /// Swaps coins of type A for coins of type B based on the bank's exchange rate.
    public entry fun swap_a_b<A, B>(coin: Coin<A>, bank: &mut Bank<A, B>, ctx: &mut TxContext) {
        let v1 = coin::value(&coin);
        
        assert!(v1 > 0, EInsufficientBalance);
        let v2 = v1 * bank.rate;
        // Asserts that the bank has sufficient balance of type B coins to perform the swap.
        assert!(balance::value(&bank.coin_b) > v2, EInsufficientBalance);

        let coin2 = coin::take(&mut bank.coin_b, v2, ctx);
        
        let balance = coin::into_balance(coin);
        // Converts the incoming coin of type A into a balance and adds it to the bank's balance.
        balance::join(&mut bank.coin_a, balance);
        // Transfers the coins of type B to the sender of the transaction.
        transfer::public_transfer(coin2, tx_context::sender(ctx));
    }

   
    /// Swaps coins of type B for coins of type A based on the bank's exchange rate.
    public entry fun swap_b_a<A, B>(coin: Coin<B>, bank: &mut Bank<A, B>, ctx: &mut TxContext) {
        let v1 = coin::value(&coin);
        // Asserts that the coin value is greater than zero to prevent zero-value swaps.
        assert!(v1 > 0, EInsufficientBalance);
        let v2 = v1 / bank.rate;
        // Asserts that the bank has sufficient balance of type A coins to perform the swap.
        assert!(balance::value(&bank.coin_a) > v2, EInsufficientBalance);

        let coin2 = coin::take(&mut bank.coin_a, v2, ctx);
        
        let balance = coin::into_balance(coin);
        // Converts the incoming coin of type B into a balance and adds it to the bank's balance.
        balance::join(&mut bank.coin_b, balance);
        // Transfers the coins of type A to the sender of the transaction.
        transfer::public_transfer(coin2, tx_context::sender(ctx));
    }

    // Withdraws all coins of type A and B from the bank and transfers them to the sender.
    #[allow(lint(self_transfer))]
    public fun withdraw<A, B>(_ :&AdminCap, bank: &mut Bank<A, B>, ctx: &mut TxContext) {
        let balance1 = balance::value(&bank.coin_a);
        // Takes all coins of type A from the bank's balance.
        let coin1 = coin::take(&mut bank.coin_a, balance1, ctx);
        // Transfers the coins of type A to the sender of the transaction.
        transfer::public_transfer(coin1, tx_context::sender(ctx));

        let balance2 = balance::value(&bank.coin_b);
        // Takes all coins of type B from the bank's balance.
        let coin2 = coin::take(&mut bank.coin_b, balance2, ctx);
        // Transfers the coins of type B to the sender of the transaction.
        transfer::public_transfer(coin2, tx_context::sender(ctx));
    }
}
