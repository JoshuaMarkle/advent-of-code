#!/bin/bash

# Thought process
# For each blank space, assign it a number (distance to the end)
# For each wall, find difference between left/right and top/bottom (2 cheats)
#
# S#...
# .#.#.
# ...#E
#
# S#432
# 9#5#1
# 876#0
#
# S6...
# .4.4.
# ...4E

mapfile -t map < input
width=$(($(head -n1 input | wc -c) - 1))
height=$(wc -l < input)

# Find starting and ending positions
start=""
end=""
for ((x=0; x<width; x++)); do
	for ((y=0; y<height; y++)); do
		if [ "${map[$y]:$x:1}" == "S" ]; then 
			start="$x,$y"
			row="${map[$y]}"
			map[$y]="${row:0:$x}.${row:$((x + 1))}"
		fi
		if [ "${map[$y]:$x:1}" == "E" ]; then 
			end="$x,$y"
			row="${map[$y]}"
			map[$y]="${row:0:$x}.${row:$((x + 1))}"
		fi
	done
done

# echo "Start - $start"
# echo "End - $end"

# BFS through map (assign each blank a distance)
movement=("1,0" "0,-1" "0,1" "-1,0")
queue=($end)
declare -A visited
visited[$end]=1
declare -A distance
distance[$end]=0
depth=0
while [ ${#queue[@]} -gt 0 ]; do
	# echo searching $depth
	# echo "Queue: ${queue[@]}"
    current_level_size=${#queue[@]}
    for ((i = 0; i < current_level_size; i++)); do
        pos=${queue[0]}
        queue=("${queue[@]:1}")
        IFS="," read -r x y <<< "$pos"

		distance[$pos]=$depth

        # Explore neighbors
        for move in "${movement[@]}"; do
            IFS="," read -r mx my <<< "$move"
            nx=$((x + mx))
            ny=$((y + my))

            # Validate new position
            if [ $nx -ge 0 ] && [ $nx -lt $height ] && [ $ny -ge 0 ] && [ $ny -lt $width ]; then
                if [ "${map[$ny]:$nx:1}" = "." ] && [ -z "${visited["$nx,$ny"]}" ]; then
					queue+=("$nx,$ny")
					visited["$nx,$ny"]=1
                fi
            fi
        done
    done
    ((depth++))
done

# Using the new numbered map, find all possible "cheats"
# Check left/right and top/bottom of each wall, find difference
# Sum up all cheats that save at least distance 100
sum=0
for ((x=0; x<width; x++)); do
	for ((y=0; y<height; y++)); do
		# Check for walls
		if [ "${map[$y]:$x:1}" = "#" ]; then
			# Check top/bottom
			if [ "${map[$((y+1))]:$x:1}" = "." ] && [ "${map[$((y-1))]:$x:1}" = "." ]; then
				# Find the difference
				diff=$((${distance["$x,$((y+1))"]} - ${distance["$x,$((y-1))"]}))
				if [ $diff -lt 0 ]; then diff=$((-diff)); fi
				diff=$((diff - 2)) # 2 steps off
				if [ $diff -ge 100 ]; then ((sum++)); fi
			fi

			# Check left/right
			if [ "${map[$y]:$((x+1)):1}" = "." ] && [ "${map[$y]:$((x-1)):1}" = "." ]; then
				# Find the difference
				diff=$((${distance["$((x+1)),$y"]} - ${distance["$((x-1)),$y"]}))
				if [ $diff -lt 0 ]; then diff=$((-diff)); fi
				diff=$((diff - 2)) # 2 steps off
				if [ $diff -ge 100 ]; then ((sum++)); fi
			fi
		fi
	done
done

echo $sum
