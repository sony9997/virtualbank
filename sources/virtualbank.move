module virtualbank::virtualbank {
    //==============================================================================================
    // Dependencies
    //==============================================================================================
    use sui::balance::{Self, Balance};
    use sui::coin::{Self, Coin};
    use sui::object::{Self, UID};
    use sui::transfer;
    use sui::tx_context::{Self, TxContext};
    use sui::event;

    //==============================================================================================
    // Error codes 
    //==============================================================================================
    const EInsufficientBalanceA: u64 = 11;
    const EInsufficientBalanceB: u64 = 12;
    const EUnauthorized: u64 = 13;
    const EZeroValueSwap: u64 = 14;

    //==============================================================================================
    // Structs 
    //==============================================================================================
    public struct AdminCap has key {
        id: UID,
    }

    public struct Bank<phantom A, phantom B> has key {
        id: UID,
        coin_a: Balance<A>,
        coin_b: Balance<B>,
        rate: u64,
    }

    //==============================================================================================
    // Event structs - DO NOT MODIFY
    //==============================================================================================
    public struct BankInitialize has copy, drop {
        bank_id: ID,
        rate: u64,
    }

    public struct AddCoins has copy, drop {
        coin_a_balance: u64,
        coin_b_balance: u64,
    }

    public struct SwapCoins has copy, drop {
        swap_type: u8,
        coin_a_balance: u64,
        coin_b_balance: u64,
    }

    public struct WithdrawCoins has copy, drop {
        coin_a_balance: u64,
        coin_b_balance: u64,
    }

    //==============================================================================================
    // Functions
    //==============================================================================================
    /// Initialize the admin capability and transfer it to the transaction sender.
    public fun init(ctx: &mut TxContext) {
        let admin_cap = AdminCap {
            id: object::new(ctx),
        };
        transfer::transfer(admin_cap, tx_context::sender(ctx))
    }

    /// Initializes a bank with two types of coins and an exchange rate.
    public fun initialize<A, B>(_admin_cap: &AdminCap, coin1: Coin<A>, coin2: Coin<B>, rate: u64, ctx: &mut TxContext) {
        let bank_id = object::new(ctx);
        
        // Emit an event to indicate bank initialization.
        event::emit(BankInitialize {
            bank_id: object::uid_to_inner(&bank_id),
            rate,
        });

        // Initialize the bank with zero balances and set the exchange rate.
        let mut bank = Bank<A, B> {
            id: bank_id,
            coin_a: balance::zero<A>(),
            coin_b: balance::zero<B>(),
            rate,
        };

        // Add the provided coins to the bank's balances.
        balance::join(&mut bank.coin_a, coin::into_balance(coin1));
        balance::join(&mut bank.coin_b, coin::into_balance(coin2));
        transfer::share_object(bank);
    }

    /// Sets a new exchange rate for the bank.
    public fun set_rate<A, B>(_admin_cap: &AdminCap, bank: &mut Bank<A, B>, rate: u64, _ctx: &mut TxContext) {
        bank.rate = rate;
    }

    /// Adds two types of coins to the bank.
    public entry fun add<A, B>(coin1: Coin<A>, coin2: Coin<B>, bank: &mut Bank<A, B>) {
        let balance1 = coin::into_balance(coin1);
        balance::join(&mut bank.coin_a, balance1);

        let balance2 = coin::into_balance(coin2);
        balance::join(&mut bank.coin_b, balance2);

        // Emit an event to indicate coins addition.
        event::emit(AddCoins {
            coin_a_balance: balance::value(&bank.coin_a),
            coin_b_balance: balance::value(&bank.coin_b),
        });
    }

    /// Swaps coins of type A for coins of type B based on the exchange rate.
    public entry fun swap_a_b<A, B>(coin: Coin<A>, bank: &mut Bank<A, B>, ctx: &mut TxContext) {
        let coin_value = coin::value(&coin);

        // Handle zero-value swap explicitly.
        if coin_value == 0 {
            return Err(EZeroValueSwap);
        }

        let required_b = coin_value * bank.rate;
        
        // Ensure the bank has enough balance of coin B.
        assert!(balance::value(&bank.coin_b) >= required_b, EInsufficientBalanceB);

        // Transfer the equivalent value of coin B to the user.
        let coin_b = coin::take(&mut bank.coin_b, required_b, ctx);
        let coin_a_balance = coin::into_balance(coin);
        
        // Add the provided coin A to the bank's balance.
        balance::join(&mut bank.coin_a, coin_a_balance);
        transfer::public_transfer(coin_b, tx_context::sender(ctx));

        // Emit an event to indicate the swap operation.
        event::emit(SwapCoins {
            swap_type: 0,
            coin_a_balance: balance::value(&bank.coin_a),
            coin_b_balance: balance::value(&bank.coin_b),
        });
    }

    /// Swaps coins of type B for coins of type A based on the exchange rate.
    public entry fun swap_b_a<A, B>(coin: Coin<B>, bank: &mut Bank<A, B>, ctx: &mut TxContext) {
        let coin_value = coin::value(&coin);

        // Handle zero-value swap explicitly.
        if coin_value == 0 {
            return Err(EZeroValueSwap);
        }

        let required_a = coin_value / bank.rate;
        
        // Ensure the bank has enough balance of coin A.
        assert!(balance::value(&bank.coin_a) >= required_a, EInsufficientBalanceA);

        // Transfer the equivalent value of coin A to the user.
        let coin_a = coin::take(&mut bank.coin_a, required_a, ctx);
        let coin_b_balance = coin::into_balance(coin);
        
        // Add the provided coin B to the bank's balance.
        balance::join(&mut bank.coin_b, coin_b_balance);
        transfer::public_transfer(coin_a, tx_context::sender(ctx));

        // Emit an event to indicate the swap operation.
        event::emit(SwapCoins {
            swap_type: 1,
            coin_a_balance: balance::value(&bank.coin_a),
            coin_b_balance: balance::value(&bank.coin_b),
        });
    }

    /// Withdraws all coins of types A and B from the bank.
    #[allow(lint(self_transfer))]
    public fun withdraw<A, B>(admin_cap: &AdminCap, bank: &mut Bank<A, B>, ctx: &mut TxContext) {
        // Authorization check.
        assert!(tx_context::sender(ctx) == admin_cap.id, EUnauthorized);

        let coin_a_balance = balance::value(&bank.coin_a);
        let coin_a = coin::take(&mut bank.coin_a, coin_a_balance, ctx);
        transfer::public_transfer(coin_a, tx_context::sender(ctx));

        let coin_b_balance = balance::value(&bank.coin_b);
        let coin_b = coin::take(&mut bank.coin_b, coin_b_balance, ctx);
        transfer::public_transfer(coin_b, tx_context::sender(ctx));

        // Emit an event to indicate withdrawal.
        event::emit(WithdrawCoins {
            coin_a_balance,
            coin_b_balance,
        });
    }

    #[test_only]
    public fun test_init(ctx: &mut TxContext) {
        init(ctx);
    }
}
