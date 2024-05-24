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

### (3) RMB:
- The `virtualbank::rmb` module represents a virtual bank system for the Chinese Renminbi (RMB)

### (4) USD:
- The `virtualbank::usd` module outlines a structure and function for initializing a representation of the United States Dollar (USD)


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
╭───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────╮
│ Object Changes                                                                                                        │
├───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┤
│ Created Objects:                                                                                                      │
│  ┌──                                                                                                                  │
│  │ ObjectID: 0x1e98e504d2b34129399425ccb3ab11ec5ae5f5aa5d347f1360b1a5418567633f                                       │
│  │ Sender: 0x31b9bdb2d50def6e6e2326113763d13cc475fa447d14365ba9ac52f69d9adc16                                         │
│  │ Owner: Account Address ( 0x31b9bdb2d50def6e6e2326113763d13cc475fa447d14365ba9ac52f69d9adc16 )                      │
│  │ ObjectType: 0x2::coin::TreasuryCap<0xb8e912d9a861f658a45a1b31c7fff3348a10bbe5b1fb2077ab242427f947e22d::rmb::RMB>   │
│  │ Version: 61                                                                                                        │
│  │ Digest: 7MegauzmtYQqmGe9ZaVFPQRkTHdADo8ZBa5PeKLcsgDK                                                               │
│  └──                                                                                                                  │
│  ┌──                                                                                                                  │
│  │ ObjectID: 0x226c027772ce696772de768b0621c453f6166d348185df1f9714a4bad5214e53                                       │
│  │ Sender: 0x31b9bdb2d50def6e6e2326113763d13cc475fa447d14365ba9ac52f69d9adc16                                         │
│  │ Owner: Account Address ( 0x31b9bdb2d50def6e6e2326113763d13cc475fa447d14365ba9ac52f69d9adc16 )                      │
│  │ ObjectType: 0x2::package::UpgradeCap                                                                               │
│  │ Version: 61                                                                                                        │
│  │ Digest: 6YmtZsEoXa3ufNXSruLLL36EcPiG9pCp1CPR6PQ2h3sV                                                               │
│  └──                                                                                                                  │
│  ┌──                                                                                                                  │
│  │ ObjectID: 0x56d9f62a9f7d478e11d770f3296911e9aa2a504c8e474f2e680efc77f10b2703                                       │
│  │ Sender: 0x31b9bdb2d50def6e6e2326113763d13cc475fa447d14365ba9ac52f69d9adc16                                         │
│  │ Owner: Account Address ( 0x31b9bdb2d50def6e6e2326113763d13cc475fa447d14365ba9ac52f69d9adc16 )                      │
│  │ ObjectType: 0xb8e912d9a861f658a45a1b31c7fff3348a10bbe5b1fb2077ab242427f947e22d::virtualbank::AdminCap              │
│  │ Version: 61                                                                                                        │
│  │ Digest: AYoiJUXtFaKegt1DkkAzgDvWpKpTo2PJcCBoC3wUvVcM                                                               │
│  └──                                                                                                                  │
│  ┌──                                                                                                                  │
│  │ ObjectID: 0x9650b740636d565c7bb2eb468c720801ef2fd834ac8ab1336f98b9a3ec4db030                                       │
│  │ Sender: 0x31b9bdb2d50def6e6e2326113763d13cc475fa447d14365ba9ac52f69d9adc16                                         │
│  │ Owner: Immutable                                                                                                   │
│  │ ObjectType: 0x2::coin::CoinMetadata<0xb8e912d9a861f658a45a1b31c7fff3348a10bbe5b1fb2077ab242427f947e22d::rmb::RMB>  │
│  │ Version: 61                                                                                                        │
│  │ Digest: 2rZRbfNnWgcxt9bPEUmtJGsH8CsUUaPiLouAjF9zTKT7                                                               │
│  └──                                                                                                                  │
│  ┌──                                                                                                                  │
│  │ ObjectID: 0xcbb5b062ea95369f0f51fb7094b49e0a933b44477690dbbdbde87e311960c27c                                       │
│  │ Sender: 0x31b9bdb2d50def6e6e2326113763d13cc475fa447d14365ba9ac52f69d9adc16                                         │
│  │ Owner: Account Address ( 0x31b9bdb2d50def6e6e2326113763d13cc475fa447d14365ba9ac52f69d9adc16 )                      │
│  │ ObjectType: 0x2::coin::TreasuryCap<0xb8e912d9a861f658a45a1b31c7fff3348a10bbe5b1fb2077ab242427f947e22d::usd::USD>   │
│  │ Version: 61                                                                                                        │
│  │ Digest: 4SQpHuUd3AL1H1FKzTyZ89UBoKEwZDKzDnB2fasCbzTF                                                               │
│  └──                                                                                                                  │
│  ┌──                                                                                                                  │
│  │ ObjectID: 0xee3867040521900fbe72167fe2d86f1f69b34bea35a69ec0927d363de93f798a                                       │
│  │ Sender: 0x31b9bdb2d50def6e6e2326113763d13cc475fa447d14365ba9ac52f69d9adc16                                         │
│  │ Owner: Immutable                                                                                                   │
│  │ ObjectType: 0x2::coin::CoinMetadata<0xb8e912d9a861f658a45a1b31c7fff3348a10bbe5b1fb2077ab242427f947e22d::usd::USD>  │
│  │ Version: 61                                                                                                        │
│  │ Digest: CR8seCVdZUkmgL55CzaCYTmkLYgSauTByieRJSpBLfrb                                                               │
│  └──                                                                                                                  │
│ Mutated Objects:                                                                                                      │
│  ┌──                                                                                                                  │
│  │ ObjectID: 0x939c99a6dfa75c064b30ed24da678a2ab8b5e2713bd89a7e3ab9609f1e8730cd                                       │
│  │ Sender: 0x31b9bdb2d50def6e6e2326113763d13cc475fa447d14365ba9ac52f69d9adc16                                         │
│  │ Owner: Account Address ( 0x31b9bdb2d50def6e6e2326113763d13cc475fa447d14365ba9ac52f69d9adc16 )                      │
│  │ ObjectType: 0x2::coin::Coin<0x2::sui::SUI>                                                                         │
│  │ Version: 61                                                                                                        │
│  │ Digest: HKQ7UAx51EH5yVt42H2tHC1CL5Fts48wnqH8yN3FzLgp                                                               │
│  └──                                                                                                                  │
│ Published Objects:                                                                                                    │
│  ┌──                                                                                                                  │
│  │ PackageID: 0xb8e912d9a861f658a45a1b31c7fff3348a10bbe5b1fb2077ab242427f947e22d                                      │
│  │ Version: 1                                                                                                         │
│  │ Digest: 3hVgkHP7WKohSs6FPYmt7qsPezprTqssMCzm1UjikUYs                                                               │
│  │ Modules: rmb, usd, virtualbank                                                                                     │
│  └──                                                                                                                  │
╰───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────╯
...

export ADMIN_CAP_ID=0x56d9f62a9f7d478e11d770f3296911e9aa2a504c8e474f2e680efc77f10b2703
export PACKAGE_ID=0xb8e912d9a861f658a45a1b31c7fff3348a10bbe5b1fb2077ab242427f947e22d
export RECIPIENT_ID=0x31b9bdb2d50def6e6e2326113763d13cc475fa447d14365ba9ac52f69d9adc16
export RMB_ID=0x1e98e504d2b34129399425ccb3ab11ec5ae5f5aa5d347f1360b1a5418567633f
export USD_ID=0xcbb5b062ea95369f0f51fb7094b49e0a933b44477690dbbdbde87e311960c27c

```

### 6. mint coins 
mint RMB and USD to the bank

```bash
 $ sui client call --gas-budget 100000000 \
 --package  0x2 \
 --module coin \
 --function mint_and_transfer \
 --type-args $PACKAGE_ID::rmb::RMB \
 --args $RMB_ID 100000000000 $RECIPIENT_ID

 ...

╭──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────╮
│ Object Changes                                                                                                       │
├──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┤
│ Created Objects:                                                                                                     │
│  ┌──                                                                                                                 │
│  │ ObjectID: 0x98e91d13d7cd61ed735db56c06903973c931be2f0c3d336f39b6c26b1c7bbe37                                      │
│  │ Sender: 0x31b9bdb2d50def6e6e2326113763d13cc475fa447d14365ba9ac52f69d9adc16                                        │
│  │ Owner: Account Address ( 0x31b9bdb2d50def6e6e2326113763d13cc475fa447d14365ba9ac52f69d9adc16 )                     │
│  │ ObjectType: 0x2::coin::Coin<0xb8e912d9a861f658a45a1b31c7fff3348a10bbe5b1fb2077ab242427f947e22d::rmb::RMB>         │
│  │ Version: 62                                                                                                       │
│  │ Digest: EWM9yAyA2AH68eMe31A5UVmo9v7YhQccdFFBbJd9iMAA                                                              │
│  └──                                                                                                                 │
│ Mutated Objects:                                                                                                     │
│  ┌──                                                                                                                 │
│  │ ObjectID: 0x1e98e504d2b34129399425ccb3ab11ec5ae5f5aa5d347f1360b1a5418567633f                                      │
│  │ Sender: 0x31b9bdb2d50def6e6e2326113763d13cc475fa447d14365ba9ac52f69d9adc16                                        │
│  │ Owner: Account Address ( 0x31b9bdb2d50def6e6e2326113763d13cc475fa447d14365ba9ac52f69d9adc16 )                     │
│  │ ObjectType: 0x2::coin::TreasuryCap<0xb8e912d9a861f658a45a1b31c7fff3348a10bbe5b1fb2077ab242427f947e22d::rmb::RMB>  │
│  │ Version: 62                                                                                                       │
│  │ Digest: FiqJDwjnHKy3fGww4tk2ytEf46QwRnm2c5i2RGwsP4nW                                                              │
│  └──                                                                                                                 │
│  ┌──                                                                                                                 │
│  │ ObjectID: 0x939c99a6dfa75c064b30ed24da678a2ab8b5e2713bd89a7e3ab9609f1e8730cd                                      │
│  │ Sender: 0x31b9bdb2d50def6e6e2326113763d13cc475fa447d14365ba9ac52f69d9adc16                                        │
│  │ Owner: Account Address ( 0x31b9bdb2d50def6e6e2326113763d13cc475fa447d14365ba9ac52f69d9adc16 )                     │
│  │ ObjectType: 0x2::coin::Coin<0x2::sui::SUI>                                                                        │
│  │ Version: 62                                                                                                       │
│  │ Digest: 9x4jVveivTXCozzsSXbP9xcqijHb4ymhVRooTHWJW8HP                                                              │
│  └──                                                                                                                 │
╰──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────╯
 ...

 export COIN_A=0x98e91d13d7cd61ed735db56c06903973c931be2f0c3d336f39b6c26b1c7bbe37


$ sui client call --gas-budget 100000000 \
 --package  0x2 \
 --module coin \
 --function mint_and_transfer \
 --type-args $PACKAGE_ID::usd::USD \
 --args $USD_ID 100000000000 $RECIPIENT_ID

 ...
 ╭──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────╮
│ Object Changes                                                                                                       │
├──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┤
│ Created Objects:                                                                                                     │
│  ┌──                                                                                                                 │
│  │ ObjectID: 0xa6b4eb8d717190932a14c7a5db5963e7ab32db677f75f6c3fbd557c351867ee9                                      │
│  │ Sender: 0x31b9bdb2d50def6e6e2326113763d13cc475fa447d14365ba9ac52f69d9adc16                                        │
│  │ Owner: Account Address ( 0x31b9bdb2d50def6e6e2326113763d13cc475fa447d14365ba9ac52f69d9adc16 )                     │
│  │ ObjectType: 0x2::coin::Coin<0xb8e912d9a861f658a45a1b31c7fff3348a10bbe5b1fb2077ab242427f947e22d::usd::USD>         │
│  │ Version: 63                                                                                                       │
│  │ Digest: 45KGVMyP8EmGZgfGdPxAhS4rvrdRMukAwoRXn6vJjhE2                                                              │
│  └──                                                                                                                 │
│ Mutated Objects:                                                                                                     │
│  ┌──                                                                                                                 │
│  │ ObjectID: 0x939c99a6dfa75c064b30ed24da678a2ab8b5e2713bd89a7e3ab9609f1e8730cd                                      │
│  │ Sender: 0x31b9bdb2d50def6e6e2326113763d13cc475fa447d14365ba9ac52f69d9adc16                                        │
│  │ Owner: Account Address ( 0x31b9bdb2d50def6e6e2326113763d13cc475fa447d14365ba9ac52f69d9adc16 )                     │
│  │ ObjectType: 0x2::coin::Coin<0x2::sui::SUI>                                                                        │
│  │ Version: 63                                                                                                       │
│  │ Digest: FMgPZHp2fpBwUrJC2HnCwKUs2NeiJjCzdEGopbx7JqWo                                                              │
│  └──                                                                                                                 │
│  ┌──                                                                                                                 │
│  │ ObjectID: 0xcbb5b062ea95369f0f51fb7094b49e0a933b44477690dbbdbde87e311960c27c                                      │
│  │ Sender: 0x31b9bdb2d50def6e6e2326113763d13cc475fa447d14365ba9ac52f69d9adc16                                        │
│  │ Owner: Account Address ( 0x31b9bdb2d50def6e6e2326113763d13cc475fa447d14365ba9ac52f69d9adc16 )                     │
│  │ ObjectType: 0x2::coin::TreasuryCap<0xb8e912d9a861f658a45a1b31c7fff3348a10bbe5b1fb2077ab242427f947e22d::usd::USD>  │
│  │ Version: 63                                                                                                       │
│  │ Digest: 3oc1Xvu26KFpTxBonj11xVDeir3EiZeh3AMvnsGbYBur                                                              │
│  └──                                                                                                                 │
╰──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────╯
 ...

export COIN_B=0xa6b4eb8d717190932a14c7a5db5963e7ab32db677f75f6c3fbd557c351867ee9

```

### 7. Initialize a new bank

```bash
$ sui client call --function initialize --package $PACKAGE_ID --module virtualbank --args $ADMIN_CAP_ID $COIN_A $COIN_B 7 --type-args $PACKAGE_ID::rmb::RMB  $PACKAGE_ID::usd::USD --gas-budget 10000000

...
                                                         │
│  ┌──                                                                                                                                                                                                                                                              │
│  │ ObjectID: 0x84825cf4bbed848d0c9f06358d045d1894bb23ac52b891fdbbf64e0fd1e52527                                                                                                                                                                                   │
│  │ Sender: 0x31b9bdb2d50def6e6e2326113763d13cc475fa447d14365ba9ac52f69d9adc16                                                                                                                                                                                     │
│  │ Owner: Shared                                                                                                                                                                                                                                                  │
│  │ ObjectType: 0xb8e912d9a861f658a45a1b31c7fff3348a10bbe5b1fb2077ab242427f947e22d::virtualbank::Bank<0xb8e912d9a861f658a45a1b31c7fff3348a10bbe5b1fb2077ab242427f947e22d::rmb::RMB, 0xb8e912d9a861f658a45a1b31c7fff3348a10bbe5b1fb2077ab242427f947e22d::usd::USD>  │
│  │ Version: 65                                                                                                                                                                                                                                                    │
│  │ Digest: J7aSUdvihxMEZgZYntmdMUnVsuvAj7iyjU5EK16hhz5k                                                                                                                                                                                                           │
│  └──                                                                                        

...

╭───────────────────────────────────────────────────────────────────────────────────────────────────────────────╮
│ Transaction Block Events                                                                                      │
├───────────────────────────────────────────────────────────────────────────────────────────────────────────────┤
│  ┌──                                                                                                          │
│  │ EventID: EWLZpG4jSMoHvqUULwM2bxJbPyvSrYfAPr6s9QxBQaV1:0                                                    │
│  │ PackageID: 0xb8e912d9a861f658a45a1b31c7fff3348a10bbe5b1fb2077ab242427f947e22d                              │
│  │ Transaction Module: virtualbank                                                                            │
│  │ Sender: 0x31b9bdb2d50def6e6e2326113763d13cc475fa447d14365ba9ac52f69d9adc16                                 │
│  │ EventType: 0xb8e912d9a861f658a45a1b31c7fff3348a10bbe5b1fb2077ab242427f947e22d::virtualbank::BankInitialize │
│  │ ParsedJSON:                                                                                                │
│  │   ┌─────────┬────────────────────────────────────────────────────────────────────┐                         │
│  │   │ bank_id │ 0x84825cf4bbed848d0c9f06358d045d1894bb23ac52b891fdbbf64e0fd1e52527 │                         │
│  │   ├─────────┼────────────────────────────────────────────────────────────────────┤                         │
│  │   │ rate    │ 7                                                                  │                         │
│  │   └─────────┴────────────────────────────────────────────────────────────────────┘                         │
│  └──                                                                                                          │
╰───────────────────────────────────────────────────────────────────────────────────────────────────────────────╯

...

export BANK_ID=0x84825cf4bbed848d0c9f06358d045d1894bb23ac52b891fdbbf64e0fd1e52527

```

### 8. Adds amounts of two different coins to a bank account.

```bash
$ sui client call --gas-budget 100000000 \
 --package  0x2 \
 --module coin \
 --function mint_and_transfer \
 --type-args $PACKAGE_ID::rmb::RMB \
 --args $RMB_ID 10000000 $RECIPIENT_ID

 ...
╭──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────╮
│ Object Changes                                                                                                       │
├──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┤
│ Created Objects:                                                                                                     │
│  ┌──                                                                                                                 │
│  │ ObjectID: 0x549c1f5fd87d6715b2e998c5bfac1a027c76b7190d0af69d297b63e45b86bdb9                                      │
│  │ Sender: 0x31b9bdb2d50def6e6e2326113763d13cc475fa447d14365ba9ac52f69d9adc16                                        │
│  │ Owner: Account Address ( 0x31b9bdb2d50def6e6e2326113763d13cc475fa447d14365ba9ac52f69d9adc16 )                     │
│  │ ObjectType: 0x2::coin::Coin<0xb8e912d9a861f658a45a1b31c7fff3348a10bbe5b1fb2077ab242427f947e22d::rmb::RMB>         │
│  │ Version: 67                                                                                                       │
│  │ Digest: 5YiRpe39FHJvNdxnVF5LhrnqPefmKHQK4kUttAxtq2kz                                                              │
│  └──                                                                                                                 │
 ...


 $ sui client call --gas-budget 100000000 \
 --package  0x2 \
 --module coin \
 --function mint_and_transfer \
 --type-args $PACKAGE_ID::usd::USD \
 --args $USD_ID 1000000 $RECIPIENT_ID

 ...
╭──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────╮
│ Object Changes                                                                                                       │
├──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┤
│ Created Objects:                                                                                                     │
│  ┌──                                                                                                                 │
│  │ ObjectID: 0x2ed837354373059d7b2d720bfa3d6f26fc9a64e1c0ad946fb37cf7bc6117538b                                      │
│  │ Sender: 0x31b9bdb2d50def6e6e2326113763d13cc475fa447d14365ba9ac52f69d9adc16                                        │
│  │ Owner: Account Address ( 0x31b9bdb2d50def6e6e2326113763d13cc475fa447d14365ba9ac52f69d9adc16 )                     │
│  │ ObjectType: 0x2::coin::Coin<0xb8e912d9a861f658a45a1b31c7fff3348a10bbe5b1fb2077ab242427f947e22d::usd::USD>         │
│  │ Version: 68                                                                                                       │
│  │ Digest: DjmdGDA6EFxzdpzdg5NZYMi9kD6iJm5upMsw6uDLadoZ                                                              │
│  └──                                                                                                                 │
 ...

export COIN_A=0x549c1f5fd87d6715b2e998c5bfac1a027c76b7190d0af69d297b63e45b86bdb9
export COIN_B=0x2ed837354373059d7b2d720bfa3d6f26fc9a64e1c0ad946fb37cf7bc6117538b

$ sui client call --function add --package $PACKAGE_ID --module virtualbank --args $COIN_A $COIN_B $BANK_ID --type-args $PACKAGE_ID::rmb::RMB  $PACKAGE_ID::usd::USD --gas-budget 10000000

...
╭─────────────────────────────────────────────────────────────────────────────────────────────────────────╮
│ Transaction Block Events                                                                                │
├─────────────────────────────────────────────────────────────────────────────────────────────────────────┤
│  ┌──                                                                                                    │
│  │ EventID: EU2E81zTsYm57dv3pkTUaqsoAvsuD6iTFa1z32VACWsv:0                                              │
│  │ PackageID: 0xb8e912d9a861f658a45a1b31c7fff3348a10bbe5b1fb2077ab242427f947e22d                        │
│  │ Transaction Module: virtualbank                                                                      │
│  │ Sender: 0x31b9bdb2d50def6e6e2326113763d13cc475fa447d14365ba9ac52f69d9adc16                           │
│  │ EventType: 0xb8e912d9a861f658a45a1b31c7fff3348a10bbe5b1fb2077ab242427f947e22d::virtualbank::AddCoins │
│  │ ParsedJSON:                                                                                          │
│  │   ┌────────────────┬──────────────┐                                                                  │
│  │   │ coin_a_balance │ 100010000000 │                                                                  │
│  │   ├────────────────┼──────────────┤                                                                  │
│  │   │ coin_b_balance │ 100001000000 │                                                                  │
│  │   └────────────────┴──────────────┘                                                                  │
│  └──                                                                                                    │
╰─────────────────────────────────────────────────────────────────────────────────────────────────────────╯
...

```

### 9. Executes a swap operation from coin type RMB to coin type USD within a bank.

```bash
$ sui client call --gas-budget 100000000 \
 --package  0x2 \
 --module coin \
 --function mint_and_transfer \
 --type-args $PACKAGE_ID::rmb::RMB \
 --args $RMB_ID 10000000 $RECIPIENT_ID

...
╭──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────╮
│ Object Changes                                                                                                       │
├──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┤
│ Created Objects:                                                                                                     │
│  ┌──                                                                                                                 │
│  │ ObjectID: 0x64330d5a3f028fd36825f52cd5f7d072974d5b5094baec626519109434e7fd90                                      │
│  │ Sender: 0x31b9bdb2d50def6e6e2326113763d13cc475fa447d14365ba9ac52f69d9adc16                                        │
│  │ Owner: Account Address ( 0x31b9bdb2d50def6e6e2326113763d13cc475fa447d14365ba9ac52f69d9adc16 )                     │
│  │ ObjectType: 0x2::coin::Coin<0xb8e912d9a861f658a45a1b31c7fff3348a10bbe5b1fb2077ab242427f947e22d::rmb::RMB>         │
│  │ Version: 70                                                                                                       │
│  │ Digest: 5iShhynioeiXb7uaEtYDzs7y44pSkMq5kwhx1PjrFmA3                                                              │
│  └──                                                                                                                 │
...

export COIN_A=0x64330d5a3f028fd36825f52cd5f7d072974d5b5094baec626519109434e7fd90

$ sui client call --function swap_a_b --package $PACKAGE_ID --module virtualbank --args $COIN_A $BANK_ID --type-args $PACKAGE_ID::rmb::RMB  $PACKAGE_ID::usd::USD --gas-budget 10000000

...
╭──────────────────────────────────────────────────────────────────────────────────────────────────────────╮
│ Transaction Block Events                                                                                 │
├──────────────────────────────────────────────────────────────────────────────────────────────────────────┤
│  ┌──                                                                                                     │
│  │ EventID: 2wvdnrSpdZSAnUMe4LNKmZEQpMfJPEjM4VVhgD7QXmuz:0                                               │
│  │ PackageID: 0xb8e912d9a861f658a45a1b31c7fff3348a10bbe5b1fb2077ab242427f947e22d                         │
│  │ Transaction Module: virtualbank                                                                       │
│  │ Sender: 0x31b9bdb2d50def6e6e2326113763d13cc475fa447d14365ba9ac52f69d9adc16                            │
│  │ EventType: 0xb8e912d9a861f658a45a1b31c7fff3348a10bbe5b1fb2077ab242427f947e22d::virtualbank::SwapCoins │
│  │ ParsedJSON:                                                                                           │
│  │   ┌────────────────┬──────────────┐                                                                   │
│  │   │ coin_a_balance │ 100020000000 │                                                                   │
│  │   ├────────────────┼──────────────┤                                                                   │
│  │   │ coin_b_balance │ 99931000000  │                                                                   │
│  │   ├────────────────┼──────────────┤                                                                   │
│  │   │ swap_type      │ 0            │                                                                   │
│  │   └────────────────┴──────────────┘                                                                   │
│  └──                                                                                                     │
╰──────────────────────────────────────────────────────────────────────────────────────────────────────────╯
...

```

### 10. Administered function to initiate a withdrawal process from a bank.

```bash
$ sui client call --function withdraw --package $PACKAGE_ID --module virtualbank --args $ADMIN_CAP_ID $BANK_ID --type-args $PACKAGE_ID::rmb::RMB  $PACKAGE_ID::usd::USD --gas-budget 10000000

╭──────────────────────────────────────────────────────────────────────────────────────────────────────────────╮
│ Transaction Block Events                                                                                     │
├──────────────────────────────────────────────────────────────────────────────────────────────────────────────┤
│  ┌──                                                                                                         │
│  │ EventID: FuqXzyso5ibzFEKbjFqdwBv2EuJfeJThCskHaw6McjgF:0                                                   │
│  │ PackageID: 0xb8e912d9a861f658a45a1b31c7fff3348a10bbe5b1fb2077ab242427f947e22d                             │
│  │ Transaction Module: virtualbank                                                                           │
│  │ Sender: 0x31b9bdb2d50def6e6e2326113763d13cc475fa447d14365ba9ac52f69d9adc16                                │
│  │ EventType: 0xb8e912d9a861f658a45a1b31c7fff3348a10bbe5b1fb2077ab242427f947e22d::virtualbank::WithdrawCoins │
│  │ ParsedJSON:                                                                                               │
│  │   ┌────────────────┬──────────────┐                                                                       │
│  │   │ coin_a_balance │ 100020000000 │                                                                       │
│  │   ├────────────────┼──────────────┤                                                                       │
│  │   │ coin_b_balance │ 99931000000  │                                                                       │
│  │   └────────────────┴──────────────┘                                                                       │
│  └──                                                                                                         │
╰──────────────────────────────────────────────────────────────────────────────────────────────────────────────╯

```