# Module: virtualbank

> NOTE: sui version >= 1.24.1 and the edition = " 2024.beta ".

- This module is represents a virtual bank system, and user can swap their SUI coins to virtual bank. 
- Bank is a global shared object that is managed by the admin, which is designated by the ownership of the bank owner capability. 
- The bank owner can initialize bank, set the exchange rate, add coins to the bank, and withdraw coins from the bank. 
- Users can exchange two types of coins through virtual banks

## Structs

### (1) Bank 
- A Bank is a global shared object that is managed by the admin. 
- The bank owner can initialize bank, set the exchange rate, add coins to the bank, and withdraw coins from the bank. 
    
### (2) AdminCap:
- Ownership of the Bank object is represented by holding the bank owner capability object.  
- The shop owner has the ability to add items to the shop, unlist items, and withdraw from the shop. 

## Functions
### (1) initialize: initialize a bank
    Function to initialize a bank with initial coins and rate.


### (2) set_rate: Set rate to bank: 
    Function to set the exchange rate of the bank.

### (3) add: add coins to the bank.
    Entry function to add coins to the bank.

### (4) swap_a_b: Swaps coins of type B for coins of type A
    Swaps coins of type B for coins of type A based on the bank's exchange rate.

### (5) swap_b_a: Swaps coins of type B for coins of type A
    Swaps coins of type B for coins of type A based on the bank's exchange rate.

### (6) withdraw: Withdraws all coins of type A and B
    Withdraws all coins of type A and B from the bank and transfers them to the sender.

## UNITTEST
```bash
$ sui --version
sui 1.24.1-2aadf14aa

$ sui move test
INCLUDING DEPENDENCY Sui
INCLUDING DEPENDENCY MoveStdlib
BUILDING virtualbank
Running Move unit tests
[ PASS    ] 0x0::virtualbank_tests::test_add
[ PASS    ] 0x0::virtualbank_tests::test_initialize
[ PASS    ] 0x0::virtualbank_tests::test_swap_a_b
[ PASS    ] 0x0::virtualbank_tests::test_swap_b_a
[ PASS    ] 0x0::virtualbank_tests::test_withdraw
Test result: OK. Total tests: 5; passed: 5; failed: 0
```

## Deployment

### 1. Create new address
> address alias: `nifty-phenacite`
```bash
$ sui client new-address ed25519 nifty-phenacite
╭────────────────────────────────────────────────────────────────────────────────────────────╮
│ Created new keypair and saved it to keystore.                                              │
├────────────────┬───────────────────────────────────────────────────────────────────────────┤
│ alias          │ nifty-phenacite                                                                  │
│ address        │ 0x31b9bdb2d50def6e6e2326113763d13cc475fa447d14365ba9ac52f69d9adc16        │
│ keyScheme      │ ed25519                                                                   │
│ recoveryPhrase │ ......                                                                    │
╰────────────────┴───────────────────────────────────────────────────────────────────────────╯

export MOVE_ADDRESS=0x31b9bdb2d50def6e6e2326113763d13cc475fa447d14365ba9ac52f69d9adc16
```

### 2. switch to `nifty-phenacite` address
```bash
$ sui client switch --address nifty-phenacite
Active address switched to 0x31b9bdb2d50def6e6e2326113763d13cc475fa447d14365ba9ac52f69d9adc16
```

### 3. Get gas coins
```bash
$ sui client faucet
Request successful. It can take up to 1 minute to get the coin. Run sui client gas to check your gas coins.
```

### 4. Check gas coins
```bash
$ sui client gas
╭────────────────────────────────────────────────────────────────────┬────────────────────┬──────────────────╮
│ gasCoinId                                                          │ mistBalance (MIST) │ suiBalance (SUI) │
├────────────────────────────────────────────────────────────────────┼────────────────────┼──────────────────┤
│ 0x939c99a6dfa75c064b30ed24da678a2ab8b5e2713bd89a7e3ab9609f1e8730cd │ 1000000000         │ 1.00             │
│ 0xdee6843e76030da8c58642997e310719a9891b0616e1e93100444f22735ae5df │ 1000000000         │ 1.00             │
╰────────────────────────────────────────────────────────────────────┴────────────────────┴──────────────────╯
```

### 5. Publish 
```bash
$ sui client publish --gas-budget 100000000 --skip-dependency-verification

...
│  ┌──                                                                                                      │
│  │ ObjectID: 0xdb50884fa1bd13657242d53373d636238477fab6128ef3d9d791240e11e0fd19                           │
│  │ Sender: 0x31b9bdb2d50def6e6e2326113763d13cc475fa447d14365ba9ac52f69d9adc16                             │
│  │ Owner: Account Address ( 0x31b9bdb2d50def6e6e2326113763d13cc475fa447d14365ba9ac52f69d9adc16 )          │
│  │ ObjectType: 0x51c7eaa2dac07aa1a771030ef8dc438196813b66c26421e85677fac60087a6a6::virtualbank::AdminCap  │
│  │ Version: 58                                                                                            │
│  │ Digest: BpNTHaLrGasRWXgG5DREQ1e86TWPVbrXkJWzS2xAuQDy                                                   │
│  └──                                                                                                      │
│ Mutated Objects:                                                                                          │
│  ┌──                                                                                                      │
│  │ ObjectID: 0x939c99a6dfa75c064b30ed24da678a2ab8b5e2713bd89a7e3ab9609f1e8730cd                           │
│  │ Sender: 0x31b9bdb2d50def6e6e2326113763d13cc475fa447d14365ba9ac52f69d9adc16                             │
│  │ Owner: Account Address ( 0x31b9bdb2d50def6e6e2326113763d13cc475fa447d14365ba9ac52f69d9adc16 )          │
│  │ ObjectType: 0x2::coin::Coin<0x2::sui::SUI>                                                             │
│  │ Version: 58                                                                                            │
│  │ Digest: ngKMJigoDmh2Yz2mQ5whQN9ewCcHgewHQ1ksEAG9XMk                                                    │
│  └──                                                                                                      │
│ Published Objects:                                                                                        │
│  ┌──                                                                                                      │
│  │ PackageID: 0x51c7eaa2dac07aa1a771030ef8dc438196813b66c26421e85677fac60087a6a6                          │
│  │ Version: 1                                                                                             │
│  │ Digest: 8Ye2GtAWg8nyrLGijSULtSc9CybvU5HLgyWeYAR6NwZc                                                   │
│  │ Modules: virtualbank                                                                                   │
│  └──                                                                                                      │
╰───────────────────────────────────────────────────────────────────────────────────────────────────────────╯
...

export ADMIN_CAP_ID=0xdb50884fa1bd13657242d53373d636238477fab6128ef3d9d791240e11e0fd19
export PACKAGE_ID=0x51c7eaa2dac07aa1a771030ef8dc438196813b66c26421e85677fac60087a6a6
export TREASURY_CAP_ID=0x939c99a6dfa75c064b30ed24da678a
export RECIPIENT_ID=0x31b9bdb2d50def6e6e2326113763d13cc475fa447d14365ba9ac52f69d9adc16
```

### 6. mint coins 
```bash
 $ sui client call --gas-budget 100000000 \
 --package  0x2 \
 --module coin \
 --function mint_and_transfer \
 --type-args $PACKAGE_ID::rmb::RMB \
 --args $TREASURY_CAP_ID 100000000000 $RECIPIENT_ID
```
### 7. Initialize a new bank
mint RMB and HK
```bash
$ sui client call --function initialize --package $PACKAGE_ID --module virtualbank --args $ADMIN_CAP_ID --gas-budget 10000000
```