#!/bin/bash

# Make array of available towels & designs
IFS=", " read -r -a patterns < <(grep ',' input)
mapfile -t designs < <(tail -n $(($(wc -l < input) - 2)) input)

# Declare memoization array
declare -A memo

test_design() {
    local design=$1

    # Base case
    if [[ -z "$design" ]]; then
        return 0
    fi

    # Check memoized results
    if [[ -n "${memo["$design"]}" ]]; then
        return "${memo["$design"]}"
    fi

    # Loop through available patterns
    local n=${#design}
    for pattern in "${patterns[@]}"; do
        # Check if the pattern is too long
        local p=${#pattern}
        if [ $p -gt $n ]; then continue; fi

        # Direct substring comparison
        if [[ "${design:0:$p}" == "$pattern" ]]; then
            new_design="${design:$p}"
            test_design "$new_design"
            if [ $? -eq 0 ]; then 
                memo["$design"]=0
                return 0
            fi
        fi
    done

    # No patterns work
    memo["$design"]=1
    return 1
}

# Find the validity of each design
possible=0
for test in "${designs[@]}"; do
    test_design "$test"
    if [ $? -eq 0 ]; then
        echo "YES : $test"
        ((possible++))
    else
        echo "NO : $test"
    fi
done

echo $possible
