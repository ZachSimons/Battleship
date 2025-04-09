#!/bin/bash

# Recompile all SystemVerilog files before running simulations
echo "🛠  Compiling all .sv files..."
vlib work
vmap work work
vlog *.sv

# Default values
use_gui=false

# Argument parsing
if [ "$#" -ge 1 ]; then
    for arg in "$@"; do
        if [[ "$arg" == "-waves" ]]; then
            use_gui=true
        else
            single_test="$arg"
        fi
    done
fi

# Set test list
if [ -n "$single_test" ]; then
    tests=("$single_test")
    echo "▶️  Running single test: $single_test"
else
    tests=(
        basic_instr_tests.hex
        sqrt.hex
        jal_tests.hex
        loadstore.hex
        loadhaz.hex
        branch_test.hex
        custom_haz.hex
    )
    echo "▶️  Running full test suite"
fi

# Arrays to track results
passed=()
failed=()

for test in "${tests[@]}"; do
    testname="${test%.hex}"
    logfile="${testname}.log"

    echo "🔧 Running simulation for $test"

    if $use_gui && [ ${#tests[@]} -eq 1 ]; then
        # GUI mode (launch waveform viewer)
        vsim work.proc_tb \
            -L /cae/apps/data/quartus-20/modelsim_ase/altera/verilog/altera_mf \
            -voptargs="+acc" \
            +HEXFILE=$test +TEST=$testname
    else
        # Standard non-GUI mode with logging
        vsim work.proc_tb \
            -L /cae/apps/data/quartus-20/modelsim_ase/altera/verilog/altera_mf \
            -voptargs="+acc" \
            +HEXFILE=$test +TEST=$testname \
            -c -do "run -all; quit" | tee "$logfile"

        # Check if the log contains any error messages
        if grep -q " FAILED" "$logfile" || grep -q " Error loading design" "$logfile"; then
            echo "❌ Test FAILED: $testname"
            failed+=("$testname")
        else
            echo "✅ Test PASSED: $testname"
            passed+=("$testname")
        fi

        echo ""
    fi
done

# Final summary (only if full suite or logging was done)
if ! $use_gui || [ ${#tests[@]} -gt 1 ]; then
    echo "===================="
    echo "📝 Test Summary:"
    echo "===================="

    if [ ${#passed[@]} -ne 0 ]; then
        echo "✅ Passed tests:"
        for t in "${passed[@]}"; do
            echo "  - $t"
        done
    fi

    if [ ${#failed[@]} -ne 0 ]; then
        echo ""
        echo "❌ Failed tests:"
        for t in "${failed[@]}"; do
            echo "  - $t"
        done
        exit 1
    else
        echo ""
        echo "🎉 All tests passed!"
        exit 0
    fi
fi
