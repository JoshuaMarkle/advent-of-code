#!/bin/bash

shopt -s extglob

# Read input into an array
mapfile -t rocks < input
gen=()

# Simulate blinking 6 times
for ((i = 0; i < 25; i++)); do
    # echo "${rocks[@]}"
    for num in ${rocks[@]}; do
		# Remove leading 0s using black magic
		num=${num##+(0)}

        # Check if the number is 0
        if [[ -z "$num" ]]; then 
            gen+=(1)
			continue
		fi

        # Check if the number of digits is even
        num_length=${#num}
        even=$((num_length % 2))

        if [ "$even" -eq 0 ]; then
            midpoint=$((num_length / 2))
            gen+=("${num:0:midpoint}") # left
            gen+=("${num:midpoint}")   # right
        else
            gen+=($((num * 2024)))
        fi
    done

    rocks=("${gen[@]}")
    gen=()
done

echo "Final size: ${#rocks[@]}"
