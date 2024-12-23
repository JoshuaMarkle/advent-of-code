#!/bin/bash

width=$(($(head -n1 input | wc -c) - 1))
height=$(wc -l < input)

# Read the map into an array
mapfile -t map < input

total_score=0
moves=("0,1" "0,-1" "1,0" "-1,0")

# Find valid starting positions (0s)
for ((y = 0; y < height; y++)); do
    for ((x = 0; x < width; x++)); do
        if [ "${map[$y]:$x:1}" -eq 0 ]; then
			# BFS through the map for trails
            visited=()
            queue=("$x,$y")
            reachable_nines=()

            while [ ${#queue[@]} -gt 0 ]; do
                IFS="," read -r cx cy <<< "${queue[0]}"
                queue=("${queue[@]:1}")

                # Skip if already visited
                pos=$((cx + cy * width))
                if [[ " ${visited[*]} " == *" $pos "* ]]; then
                    continue
                fi
                visited+=("$pos")

                # If this position is a 9, add to reachable nines
                if [ "${map[$cy]:$cx:1}" -eq 9 ]; then
                    if [[ ! " ${reachable_nines[*]} " =~ " $pos " ]]; then
                        reachable_nines+=("$pos")
                    fi
                fi

                # Add neighbors to the queue
                for move in "${moves[@]}"; do
                    IFS="," read -r dx dy <<< "$move"
                    nx=$((cx + dx))
                    ny=$((cy + dy))
                    if ((nx < 0 || nx >= width || ny < 0 || ny >= height)); then
                        continue
                    fi
                    neighbor_height=${map[$ny]:$nx:1}
                    current_height=${map[$cy]:$cx:1}
                    if [ "$neighbor_height" -eq $((current_height + 1)) ]; then
                        queue+=("$nx,$ny")
                    fi
                done
            done

            # Add the count of unique reachable 9s to the total score
            total_score=$((total_score + ${#reachable_nines[@]}))
        fi
    done
done

# Output the total score
echo $total_score
