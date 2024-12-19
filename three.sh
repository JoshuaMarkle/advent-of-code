#!/bin/bash

if [ ! -e "input" ]; then
    echo "no input file lol"
    exit 1
fi

input=$(cat input)
regex="(mul\([0-9]+,[0-9]+\))" # Capture "mul(number,number)"
matches=$(grep -oE "$regex" input) # All matches
sum=0

# Loop over matches
while read -r match; do
	read -r num1 num2 <<< "$(echo "$match" | grep -oE '[0-9]+' | tr '\n' ' ')"
	sum=$((sum + (num1 * num2)))
done <<< $matches

echo $sum
