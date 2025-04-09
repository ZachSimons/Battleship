#!/bin/bash

# Recompile all SystemVerilog files before running simulations
echo "🛠  Compiling all .sv files..."
vlib work
vmap work work
vlog *.sv

# Check if a single test name was passed as an argument
if [ "$#" -eq 1 ]; then
    tests=("$1")
    echo "▶️  Running single test: $1"
else
    # List of hex files to simulate if no argument is passed
    tests=(
        basic_instr_tests.hex
        sqrt.hex
        jal_tests.hex
        loadstore.hex
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
    vsim work.proc_tb \
        -L /cae/apps/data/quartus-20/modelsim_ase/altera/verilog/altera_mf \
        -voptargs="+acc" \
        +HEXFILE=$test +TEST=$testname \
        -c -do "run -all; quit" | tee "$logfile"

    # Check if the log contains any error messages
    if grep -q "** FAILED" "$logfile"; then
        echo "❌ Test FAILED: $testname"
        failed+=("$testname")
    else
        echo "✅ Test PASSED: $testname"
        passed+=("$testname")
    fi

    echo ""
done

# Final summary
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
    exit 1  # Exit with error to indicate failure
else
    echo ""
    echo "🎉 All tests passed!"
    exit 0
fi
