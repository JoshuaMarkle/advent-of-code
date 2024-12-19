#!/bin/bash

# Check for an input file
input="input"
if [ ! -e "$input" ]; then
    echo "Input file not found"
    exit 1
fi

# Create two lists
list1=()
list2=()

# Fill both lists
while read -r var1 var2; do
    list1+=("$var1")
    list2+=("$var2")
done < "$input"

# Sort both lists
IFS=$'\n' sorted_list1=($(printf "%s\n" "${list1[@]}" | sort -n))
IFS=$'\n' sorted_list2=($(printf "%s\n" "${list2[@]}" | sort -n))

# Pair smallest of list1 to smallest of list2 and calculate differences
final_result=0
for i in "${!sorted_list1[@]}"; do
    diff=$((sorted_list1[i] - sorted_list2[i]))
    if [ $diff -lt 0 ]; then
        diff=$((diff * -1))
    fi
    final_result=$((final_result + diff))
done

# Output the final result
echo $final_result
