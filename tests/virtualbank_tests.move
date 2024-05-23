
#[test_only]
module virtualbank::virtualbank_tests {
    // uncomment this line to import the module
    // use virtualbank::virtualbank;

    const ENotImplemented: u64 = 0;

    #[test]
    fun test_virtualbank() {
        // pass
    }

    #[test, expected_failure(abort_code = ::virtualbank::virtualbank_tests::ENotImplemented)]
    fun test_virtualbank_fail() {
        abort ENotImplemented
    }
}

