#!/bin/bash

# Check for input file
if [ ! -e "input" ]; then
	echo "no input lol"
	exit
fi

safe=0

# loop through input
while IFS= read -r line; do
	# Create array
	read -a arr <<< "$line"
	n=${#arr[@]}

	# Setup looping vars
	((safe++))
	increasing=1
	decreasing=1

	# Loop through line 
	for ((i = 0; i < n - 1; i++)); do
		# Check if the difference is increasing or decreasing
		diff=$((arr[i+1] - arr[i]))
		if [ $diff -gt 0 ]; then
			decreasing=0
		elif [ $diff -lt 0 ]; then
			increasing=0
		fi
		
		# If the array is not increasing or decreasing; break out
		if [ $increasing -eq 0 ] && [ $decreasing -eq 0 ]; then
			((safe--))
			break
		fi

		# Check the difference amount
		if [ $diff -lt 0 ]; then
			diff=$((-diff))
		fi
		if [ $diff -lt 1 ] || [ $diff -gt 3 ]; then
			((safe--))
			break
		fi
	done
done < input

echo $safe
