module virtualbank::virtualbank {
    // Import necessary modules for balance and coin operations.
    use sui::balance::{Self, Balance};
    use sui::coin::{Self, Coin};
    use sui::event;
    use sui::transfer;
    use sui::tx_context::{Self, TxContext};
    use sui::object::{Self, UID};

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

    //==============================================================================================
    // Event structs - DO NOT MODIFY
    //==============================================================================================
    /**
    * Represents the initialization data for a bank.
    *
    * @param bank_id - The unique identifier of the bank. (@type ID)
    * @param rate - The annual interest rate of the bank expressed in basis points (0-100%). (@type u64)
    */
    public struct BankInitialize has copy, drop {
        bank_id: ID,
        rate: u64,
    }

    /**
    * Represents the addition of coins where two different types of coins are involved.
    *
    * @param coin_a_balance - The balance of coin A after the addition operation. (@type u64)
    * @param coin_b_balance - The balance of coin B after the addition operation. (@type u64)
    */
    public struct AddCoins has copy, drop {
        coin_a_balance: u64,
        coin_b_balance: u64,
    }

    /**
    * Represents the swapping of coins between two types, with a specified swap direction.
    *
    * @param swap_type - An enum value indicating the swap direction: 0 for swapping from A to B, 1 for swapping from B to A. (@type u8)
    * @param coin_a_balance - The balance of coin A after the swap operation. (@type u64)
    * @param coin_b_balance - The balance of coin B after the swap operation. (@type u64)
    */
    public struct SwapCoins has copy, drop {
        swap_type: u8, /// 0: swap_a_b, 1: swap_b_a
        coin_a_balance: u64,
        coin_b_balance: u64,
    }

    /**
    * Represents the withdrawal of coins, involving two different types of coins.
    *
    * @param coin_a_balance - The remaining balance of coin A after the withdrawal operation. (@type u64)
    * @param coin_b_balance - The remaining balance of coin B after the withdrawal operation. (@type u64)
    */
    public struct WithdrawCoins has copy, drop {
        coin_a_balance: u64,
        coin_b_balance: u64,
    }

    //==============================================================================================
    // Functions
    //==============================================================================================
    // Function to initialize the module by creating and transferring an AdminCap.
    public fun init(ctx: &mut TxContext) {
        let admin_cap = AdminCap {
            id: object::new(ctx) // Create a new unique ID for the AdminCap.
        };
        transfer::transfer(admin_cap, tx_context::sender(ctx)) // Transfer the AdminCap to the sender of the transaction.
    }

    /**
    * Initializes the banking system with specific coins and an interest rate.
    *
    * This function sets up the initial state for a banking system by taking administrative capabilities,
    * defining two distinct coin types, setting an interest rate, and utilizing a transaction context.
    *
    * @param _ :&AdminCap - The administrative capability required to perform the initialization. (Unused parameter)
    * @param coin1: Coin<A> - The first type of coin to be managed within the bank. (@template A)
    * @param coin2: Coin<B> - The second type of coin to be managed within the bank. (@template B)
    * @param rate: u64 - The base interest rate applied to transactions within the bank. (@type u64)
    * @param ctx: &mut TxContext - The mutable reference to the transaction context 
    */
    public fun initialize<A, B>(_ :&AdminCap, coin1: Coin<A>, coin2: Coin<B>, rate: u64, ctx: &mut TxContext) {
        let bank_id = object::new(ctx); // Create a new unique ID for the bank.
        event::emit(BankInitialize{
            bank_id: object::uid_to_inner(&bank_id), 
            rate,
        });
        let mut bank = Bank<A, B> {
            id: bank_id, 
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

    /**
    *  Adjusts the interest rate for a specific bank.
    *
    * This function allows an administrator to change the interest rate associated with a bank,
    * affecting future transactions involving the bank's coins. It requires administrative capabilities
    * and a mutable reference to the bank to apply the new rate.
    *
    * @param _ :&AdminCap - The administrative capability required to modify the bank's interest rate. (Unused parameter)
    * @param bank: &mut Bank<A, B> - A mutable reference to the bank whose interest rate is to be set. (@template A, B)
    * @param rate: u64 - The new interest rate to be applied to the bank. Represented in basis points (0-100%). (@type u64)
    * @param _ctx: &mut TxContext - The mutable reference to the transaction context
    */
    public fun set_rate<A, B>(_ :&AdminCap, bank: &mut Bank<A, B>, rate: u64, _ctx: &mut TxContext) {
        bank.rate = rate // Update the exchange rate of the bank.
    }

    /**
    * Adds amounts of two different coins to a bank account.
    *
    * This public entry function enables users to deposit quantities of two coin types into a bank.
    * It requires mutable access to the bank to update the balances accordingly.
    *
    * @param coin1: Coin<A> - The first coin to be added to the bank account. (@template A)
    * @param coin2: Coin<B> - The second coin to be added to the bank account. (@template B)
    * @param bank: &mut Bank<A, B> - A mutable reference to the bank where the coins will be deposited. 
    */
    public entry fun add<A, B>(coin1: Coin<A>, coin2: Coin<B>, bank: &mut Bank<A, B>) {
        let balance1 = coin::into_balance(coin1); // Convert the coin to balance format.
        balance::join(&mut bank.coin_a, balance1); // Add the balance to the coin A balance of the bank.
        let balance2 = coin::into_balance(coin2); // Convert the coin to balance format.
        balance::join(&mut bank.coin_b, balance2); // Add the balance to the coin B balance of the bank.
        event::emit(AddCoins{
            coin_a_balance: balance::value(&bank.coin_a), 
            coin_b_balance: balance::value(&bank.coin_b),
        });
    }

    /**
    * Executes a swap operation from coin type A to coin type B within a bank.
    *
    * This public entry function facilitates swapping coins of type A to coins of type B within the bank,
    * updating the user's balance and interacting with the bank's state. It also utilizes a transaction context
    * for logging and maintaining the integrity of the swap operation.
    *
    * @param coin: Coin<A> - The coin of type A to be swapped. (@template A)
    * @param bank: &mut Bank<A, B> - A mutable reference to the bank where the swap operation takes place. (@template A, B)
    * @param ctx: &mut TxContext - The mutable reference to the transaction context
    */
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

        event::emit(SwapCoins{
            swap_type: 0, 
            coin_a_balance: balance::value(&bank.coin_a), 
            coin_b_balance: balance::value(&bank.coin_b),
        });
    }

    /**
    * Executes a swap operation from coin type B to coin type A within a bank.
    *
    * This public entry function facilitates swapping coins of type B to coins of type A within the bank,
    * updating the user's balance and interacting with the bank's state. It also uses a transaction context
    * for logging the swap event and maintaining the consistency of the transactional state.
    *
    * @param coin: Coin<B> - The coin of type B to be swapped. (@template B)
    * @param bank: &mut Bank<A, B> - A mutable reference to the bank where the swap operation takes place. (@template A, B)
    * @param ctx: &mut TxContext - The mutable reference to the transaction context
    */
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

        event::emit(SwapCoins{
            swap_type: 1, 
            coin_a_balance: balance::value(&bank.coin_a), 
            coin_b_balance: balance::value(&bank.coin_b),
        });
    }

    #[allow(lint(self_transfer))]
    /**
    * Administered function to initiate a withdrawal process from a bank.
    *
    * This function allows an administrator to start a withdrawal operation from a bank, affecting the balances
    * of the bank's managed coins. It requires administrative capabilities and a mutable bank reference to proceed.
    * The transaction context is used for logging and ensuring the atomicity of the withdrawal action.
    *
    * @param _ :&AdminCap - The administrative capability needed to authorize the withdrawal operation. (Unused parameter)
    * @param bank: &mut Bank<A, B> - A mutable reference to the bank from which funds are to be withdrawn. (@template A, B)
    * @param ctx: &mut TxContext - The mutable reference to the transaction context
    */
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

        event::emit(WithdrawCoins{
            coin_a_balance: balance1, 
            coin_b_balance: balance2,
        });
    }

    #[test_only]
    /// Wrapper of module initializer for testing
    public fun test_init(ctx: &mut TxContext) {
        init(ctx)
    }
}
