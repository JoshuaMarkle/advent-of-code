#!/bin/bash

# Find all unique characters
mapfile -t unique_chars < <(grep -o . input | sort -u | tr -d .)

# Get map bounds
width=$(head -n1 input | awk '{print length}')
height=$(wc -l < input)

# Track all marked antinodes
marked_antinodes=()

# For each character, gather all positions, calculate all antinodes
sum=0
for char in "${unique_chars[@]}"; do
    # Find all positions of the character
    positions=()
    row=0
    while IFS= read -r line; do
        for col in $(seq 0 $((width - 1))); do
            if [ "${line:col:1}" == "$char" ]; then
                positions+=("$row,$col")
            fi
        done
        ((row++))  # Increment row index
    done < input

    # Find all of the antinodes
    n=${#positions[@]}
    for ((i = 0; i < n; i++)); do
        for ((j = i + 1; j < n; j++)); do
            IFS="," read -r x1 y1 <<< "${positions[i]}"
            IFS="," read -r x2 y2 <<< "${positions[j]}"

            xdiff=$((x1 - x2))
            ydiff=$((y1 - y2))

            # Function to check if an antinode is valid
            is_valid_antinode() {
                local ax=$1
                local ay=$2

                # Check if the antinode is already in positions
                for pos in "${positions[@]}"; do
                    IFS="," read -r px py <<< "$pos"
                    if [ "$px" -eq "$ax" ] && [ "$py" -eq "$ay" ]; then
                        return 1 # Not valid
                    fi
                done

                # Check if the antinode is already in marked_antinodes
                for marked in "${marked_antinodes[@]}"; do
                    IFS="," read -r mx my <<< "$marked"
                    if [ "$mx" -eq "$ax" ] && [ "$my" -eq "$ay" ]; then
                        return 1 # Not valid
                    fi
                done

                return 0 # Valid
            }

            # Antinode 1
            ax1=$((x1 + xdiff))
            ay1=$((y1 + ydiff))
            if [ $ax1 -ge 0 ] && [ $ax1 -lt $height ] && [ $ay1 -ge 0 ] && [ $ay1 -lt $width ]; then
                if is_valid_antinode "$ax1" "$ay1"; then
                    ((sum++))
                    marked_antinodes+=("$ax1,$ay1")
                fi
            fi

            # Antinode 2
            ax2=$((x2 - xdiff))
            ay2=$((y2 - ydiff))
            if [ $ax2 -ge 0 ] && [ $ax2 -lt $height ] && [ $ay2 -ge 0 ] && [ $ay2 -lt $width ]; then
                if is_valid_antinode "$ax2" "$ay2"; then
                    ((sum++))
                    marked_antinodes+=("$ax2,$ay2")
                fi
            fi

            # echo "$x1,$y1 - $x2,$y2 - $xdiff,$ydiff - $ax1,$ay1 - $ax2,$ay2"
        done
    done
done

echo "$sum"
