#!/bin/bash

width=71
height=71
mapfile -t walls < <(head -n 1024 input)

# --- Make the map --- #

# Make map of dots
map=()
for ((i = 0; i < height; i++)); do
    map+=("$(printf '.%.0s' $(seq 1 $width))")
done

# Add a # at every position
for position in "${walls[@]}"; do
    IFS="," read -r row col <<< "$position"
    if [ $row -ge 0 ] && [ $row -lt $height ] && [ $col -ge 0 ] && [ $col -lt $width ]; then
        map[$row]="${map[$row]:0:$col}#${map[$row]:$((col + 1))}"
    fi
done

# Print the final map
for line in "${map[@]}"; do
    echo "$line"
done

# --- Implement BFS I guess --- #

movement=("1,0" "0,-1" "0,1" "-1,0")
queue=("0,0")
declare -A visited
visited["0,0"]=1
depth=0

# BFS Loop
while [ ${#queue[@]} -gt 0 ]; do
	# echo searching $depth
	# echo "Queue: ${queue[@]}"
    current_level_size=${#queue[@]}
    for ((i = 0; i < current_level_size; i++)); do
        pos=${queue[0]}
        queue=("${queue[@]:1}") # Pop the first element
        IFS="," read -r x y <<< "$pos"

        # Check if goal is reached
        if [ "$pos" = "70,70" ]; then
            echo "Reached goal in $depth steps."
            exit 0
        fi

        # Explore neighbors
        for move in "${movement[@]}"; do
            IFS="," read -r mx my <<< "$move"
            nx=$((x + mx))
            ny=$((y + my))

            # Validate new position
            if [ $nx -ge 0 ] && [ $nx -lt $height ] && [ $ny -ge 0 ] && [ $ny -lt $width ]; then
                if [ "${map[$nx]:$ny:1}" = "." ] && [ -z "${visited["$nx,$ny"]}" ]; then
                    queue+=("$nx,$ny")
                    visited["$nx,$ny"]=1
                fi
            fi
        done
    done
    ((depth++))
done

echo "No path found."
exit 1
