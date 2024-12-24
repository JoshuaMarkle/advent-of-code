#!/bin/bash

# Preload rules into an associative array for faster lookup
declare -A rules
while IFS="|" read -r num1 num2; do
    rules["$num1,$num2"]=1
done < <(grep "|" input)

# Initialize sum
sum=0

# Process each line with ',' as delimiter
while IFS="," read -ra arr; do
    length=${#arr[@]}
    valid=1

    # Check all pairs in the array
    for ((i = 0; i < length && valid; i++)); do
        for ((j = i + 1; j < length; j++)); do
            key="${arr[j]},${arr[i]}"
            if [[ ${rules[$key]} ]]; then
                valid=0
                break 2
            fi
        done
    done

    # If invalid, skip this array
    if (( !valid )); then continue; fi

    # Add the middle element to the sum
    middle=$((length / 2))
    sum=$((sum + arr[middle]))
done < <(grep "," input)

echo $sum
