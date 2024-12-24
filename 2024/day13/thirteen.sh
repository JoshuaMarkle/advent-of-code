#!/bin/bash

# Thought process
# Button A (X_a, Y_a), Button B (X_b, Y_b), Prize (X_p, Y_p)
# a * X_a + b * X_b = X_p
# a * Y_a + b * Y_b = Y_p
# Cost = 3a + b (minimize the cost)
# Loop over a in [0, max_presses] and b in [0, max_presses]
# 	Check (a * X_a + b * X_b == X_p) and (a * Y_a + b * Y_b == Y_p)
# 	Update min_cost if condition is met
# 	Sum costs and count prizes won

total=0
max_presses=100

# Read and process the input file
while IFS= read -r line; do
	# Skip empty lines
	if [[ -z "$line" ]]; then continue; fi

	# Button A
	if [[ "$line" =~ Button\ A:\ X\+([0-9]+),\ Y\+([0-9]+) ]]; then
		X_a="${BASH_REMATCH[1]}"
		Y_a="${BASH_REMATCH[2]}"
		continue
	fi

	# Button B
	if [[ "$line" =~ Button\ B:\ X\+([0-9]+),\ Y\+([0-9]+) ]]; then
		X_b="${BASH_REMATCH[1]}"
		Y_b="${BASH_REMATCH[2]}"
		continue
	fi

	# Prize + actual math
	if [[ "$line" =~ Prize:\ X=([0-9]+),\ Y=([0-9]+) ]]; then
		X_p="${BASH_REMATCH[1]}"
		Y_p="${BASH_REMATCH[2]}"

		min_cost=999999 # Big number lol
		best_a=-1
		best_b=-1

		# Iterate over values of a and b
		for ((a=0; a<=max_presses; a++)); do
			for ((b=0; b<=max_presses; b++)); do
				# Check if this combo reaches the prize
				if ((a * X_a + b * X_b == X_p && a * Y_a + b * Y_b == Y_p)); then
					cost=$((3 * a + b))
					if ((cost < min_cost)); then
						min_cost=$cost
						best_a=$a
						best_b=$b
					fi
				fi
			done
		done

		# If a solution is found - add to total
		if ((min_cost < 999999)); then total=$((total + min_cost)); fi
	fi
done < input

echo "Min cost: $total"
