#!/bin/bash

is_possible() {
	# Base case
	local array=("$@")
	local n=${#array[@]}
	if [ $n -eq 1 ]; then
		if [ "${array[0]}" -eq "$target" ]; then
			return 0
		else
			return 1
		fi
	fi

	# Check multiplication
	local mult=($((array[0] * array[1])) "${array[@]:2}")
	if is_possible "${mult[@]}"; then
		return 0
	fi

	# Check addition
	local add=($((array[0] + array[1])) "${array[@]:2}")
	if is_possible "${add[@]}"; then
		return 0
	fi

	return 1
}

# Loop through the input
sum=0
while read line; do
	# Get the input
	target=$(awk '{print $1}' <<< $line | tr -d ":")
	IFS=" " read -r -a arr <<< $(awk '{$1=""; print $0}' <<< $line)

	# Find all possible ways to multiply/add for target
	if is_possible "${arr[@]}"; then
		echo valid - $line
		sum=$((sum + $target))
	else
		echo invalid - $line
	fi
done < input

echo $sum
