
#[test_only]
module virtualbank::virtualbank_tests {

    //==============================================================================================
    // Dependencies
    //==============================================================================================
    use sui::balance::{Self, Balance};
    use sui::coin::{Self, Coin, TreasuryCap};
    use virtualbank::virtualbank::{Self, Bank,AdminCap};

    #[test_only]
    use sui::test_scenario::{Self, next_tx, ctx};
    #[test_only]
    use sui::test_utils::assert_eq;
    #[test_only]
    use std::debug;
    #[test_only]
    public struct COIN_A has drop {}
    #[test_only]
    public struct COIN_B has drop {}

    #[test]
    fun test_initialize() {
        // Initialize a mock sender address
        let addr1 = @0xA;

        // Begins a multi transaction scenario with addr1 as the sender
        let mut scenario_val = test_scenario::begin(addr1);
        let scenario = &mut scenario_val;
        {
            virtualbank::test_init(ctx(scenario));
        };
        
        let tx=next_tx(scenario, addr1);
        let expected_events_emitted = 0;
            assert_eq(
                test_scenario::num_user_events(&tx),
                expected_events_emitted
        );
        {
            let admin_cap = test_scenario::take_from_sender<AdminCap>(scenario);
            let mut coin_a = sui::coin::mint_for_testing<COIN_A>(
                    10000, 
                    test_scenario::ctx(scenario)
                );
            let mut coin_b = sui::coin::mint_for_testing<COIN_B>(
                    5000, 
                    test_scenario::ctx(scenario)
                );
            assert_eq(coin::value(&coin_a), 10000);
            assert_eq(coin::value(&coin_b), 5000);
            let rate=2;
            virtualbank::initialize(& admin_cap,coin_a,coin_b,rate,ctx(scenario));
            test_scenario::return_to_sender(scenario,admin_cap);
        };
        // Cleans up the scenario object
        let tx = test_scenario::end(scenario_val);
        let expected_events_emitted = 1;
        assert_eq(
            test_scenario::num_user_events(&tx),
            expected_events_emitted
        );
    }

    #[test]
    fun test_add() {
        // Initialize a mock sender address
        let addr1 = @0xA;

        // Begins a multi transaction scenario with addr1 as the sender
        let mut scenario_val = test_scenario::begin(addr1);
        let scenario = &mut scenario_val;
        {
            virtualbank::test_init(ctx(scenario));
        };
        
        let tx=next_tx(scenario, addr1);
        let expected_events_emitted = 0;
            assert_eq(
                test_scenario::num_user_events(&tx),
                expected_events_emitted
        );
        {
            let admin_cap = test_scenario::take_from_sender<AdminCap>(scenario);
            let mut coin_a = sui::coin::mint_for_testing<COIN_A>(
                    10000, 
                    test_scenario::ctx(scenario)
                );
            let mut coin_b = sui::coin::mint_for_testing<COIN_B>(
                    5000, 
                    test_scenario::ctx(scenario)
                );
            assert_eq(coin::value(&coin_a), 10000);
            assert_eq(coin::value(&coin_b), 5000);
            let rate=2;
            virtualbank::initialize(& admin_cap,coin_a,coin_b,rate,ctx(scenario));
            test_scenario::return_to_sender(scenario,admin_cap);
        };

        let tx=next_tx(scenario, addr1);
        let expected_events_emitted = 1;
            assert_eq(
                test_scenario::num_user_events(&tx),
                expected_events_emitted
        );
        {
            let mut bank = test_scenario::take_shared<Bank<COIN_A,COIN_B>>(scenario);
            let coin_a = sui::coin::mint_for_testing<COIN_A>(
                    1000, 
                    test_scenario::ctx(scenario)
                );
            let coin_b = sui::coin::mint_for_testing<COIN_B>(
                    50000, 
                    test_scenario::ctx(scenario)
                );
            assert_eq(coin::value(&coin_a), 1000);
            assert_eq(coin::value(&coin_b), 50000);
            virtualbank::add(coin_a,coin_b,&mut bank);
            test_scenario::return_shared(bank);
        };



        // Cleans up the scenario object
        let tx = test_scenario::end(scenario_val);
        let expected_events_emitted = 1;
        assert_eq(
            test_scenario::num_user_events(&tx),
            expected_events_emitted
        );
    }

     #[test]
    fun test_swap_a_b() {
        // Initialize a mock sender address
        let addr1 = @0xA;

        // Begins a multi transaction scenario with addr1 as the sender
        let mut scenario_val = test_scenario::begin(addr1);
        let scenario = &mut scenario_val;
        {
            virtualbank::test_init(ctx(scenario));
        };
        
        let tx=next_tx(scenario, addr1);
        let expected_events_emitted = 0;
            assert_eq(
                test_scenario::num_user_events(&tx),
                expected_events_emitted
        );
        {
            let admin_cap = test_scenario::take_from_sender<AdminCap>(scenario);
            let mut coin_a = sui::coin::mint_for_testing<COIN_A>(
                    10000, 
                    test_scenario::ctx(scenario)
                );
            let mut coin_b = sui::coin::mint_for_testing<COIN_B>(
                    5000, 
                    test_scenario::ctx(scenario)
                );
            assert_eq(coin::value(&coin_a), 10000);
            assert_eq(coin::value(&coin_b), 5000);
            let rate=2;
            virtualbank::initialize(& admin_cap,coin_a,coin_b,rate,ctx(scenario));
            test_scenario::return_to_sender(scenario,admin_cap);
        };

        let tx=next_tx(scenario, addr1);
        let expected_events_emitted = 1;
            assert_eq(
                test_scenario::num_user_events(&tx),
                expected_events_emitted
        );
        {
            let mut bank = test_scenario::take_shared<Bank<COIN_A,COIN_B>>(scenario);
            let coin_a = sui::coin::mint_for_testing<COIN_A>(
                    2000, 
                    test_scenario::ctx(scenario)
                );
            
            assert_eq(coin::value(&coin_a), 2000);
            virtualbank::swap_a_b(coin_a,&mut bank,ctx(scenario));
            test_scenario::return_shared(bank);
        };



        // Cleans up the scenario object
        let tx = test_scenario::end(scenario_val);
        let expected_events_emitted = 1;
        assert_eq(
            test_scenario::num_user_events(&tx),
            expected_events_emitted
        );
    }

    #[test]
    fun test_swap_b_a() {
        // Initialize a mock sender address
        let addr1 = @0xA;

        // Begins a multi transaction scenario with addr1 as the sender
        let mut scenario_val = test_scenario::begin(addr1);
        let scenario = &mut scenario_val;
        {
            virtualbank::test_init(ctx(scenario));
        };
        
        let tx=next_tx(scenario, addr1);
        let expected_events_emitted = 0;
            assert_eq(
                test_scenario::num_user_events(&tx),
                expected_events_emitted
        );
        {
            let admin_cap = test_scenario::take_from_sender<AdminCap>(scenario);
            let mut coin_a = sui::coin::mint_for_testing<COIN_A>(
                    10000, 
                    test_scenario::ctx(scenario)
                );
            let mut coin_b = sui::coin::mint_for_testing<COIN_B>(
                    5000, 
                    test_scenario::ctx(scenario)
                );
            assert_eq(coin::value(&coin_a), 10000);
            assert_eq(coin::value(&coin_b), 5000);
            let rate=2;
            virtualbank::initialize(& admin_cap,coin_a,coin_b,rate,ctx(scenario));
            test_scenario::return_to_sender(scenario,admin_cap);
        };

        let tx=next_tx(scenario, addr1);
        let expected_events_emitted = 1;
            assert_eq(
                test_scenario::num_user_events(&tx),
                expected_events_emitted
        );
        {
            let mut bank = test_scenario::take_shared<Bank<COIN_A,COIN_B>>(scenario);
            let coin_b = sui::coin::mint_for_testing<COIN_B>(
                    500, 
                    test_scenario::ctx(scenario)
                );
            
            assert_eq(coin::value(&coin_b), 500);
            virtualbank::swap_b_a(coin_b,&mut bank,ctx(scenario));
            test_scenario::return_shared(bank);
        };



        // Cleans up the scenario object
        let tx = test_scenario::end(scenario_val);
        let expected_events_emitted = 1;
        assert_eq(
            test_scenario::num_user_events(&tx),
            expected_events_emitted
        );
    }


    #[test]
    fun test_withdraw() {
        // Initialize a mock sender address
        let addr1 = @0xA;

        // Begins a multi transaction scenario with addr1 as the sender
        let mut scenario_val = test_scenario::begin(addr1);
        let scenario = &mut scenario_val;
        {
            virtualbank::test_init(ctx(scenario));
        };
        
        let tx=next_tx(scenario, addr1);
        let expected_events_emitted = 0;
            assert_eq(
                test_scenario::num_user_events(&tx),
                expected_events_emitted
        );
        let admin_cap = test_scenario::take_from_sender<AdminCap>(scenario);
        {
            
            let mut coin_a = sui::coin::mint_for_testing<COIN_A>(
                    10000, 
                    test_scenario::ctx(scenario)
                );
            let mut coin_b = sui::coin::mint_for_testing<COIN_B>(
                    5000, 
                    test_scenario::ctx(scenario)
                );
            assert_eq(coin::value(&coin_a), 10000);
            assert_eq(coin::value(&coin_b), 5000);
            let rate=2;
            virtualbank::initialize(& admin_cap,coin_a,coin_b,rate,ctx(scenario));
            
        };

        let tx=next_tx(scenario, addr1);
        let expected_events_emitted = 1;
            assert_eq(
                test_scenario::num_user_events(&tx),
                expected_events_emitted
        );
        {
            let mut bank = test_scenario::take_shared<Bank<COIN_A,COIN_B>>(scenario);
            virtualbank::withdraw(&admin_cap,&mut bank,ctx(scenario));
            test_scenario::return_shared(bank);
            test_scenario::return_to_sender(scenario,admin_cap);
        };



        // Cleans up the scenario object
        let tx = test_scenario::end(scenario_val);
        let expected_events_emitted = 1;
        assert_eq(
            test_scenario::num_user_events(&tx),
            expected_events_emitted
        );
    }
}

