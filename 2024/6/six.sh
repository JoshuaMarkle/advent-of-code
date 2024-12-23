#!/bin/bash

# I actually could not for the life of me figure out this problem
# This code is basically a commented version from tkr-sh
# https://github.com/tkr-sh/aoc-2024/blob/main/06/first.sh

# Find the position of the guard (^)
IFS=':' read y x line <<< $(rg --column -n '\^' < input)

# Make the map
width=$(wc -m <<< "$line")
map=$(<input)

# Rotation counter (0: up, 1: right, 2: down, 3: left)
rot=0

# Start the simulation
while [ $x -gt 0 ] && [ $x -le $width ] && [ $y -gt 0 ] && [ $y -le $width ]; do
    # Check if the current position is a wall (#)
    if [[ $(sed -n "${y}p" <<< "$map" | cut -c $x) == '#' ]]; then
        # If facing vertically, adjust x; if horizontally, adjust y
        if [ $((rot % 2)) -eq 1 ]; then
            x=$((x + rot - 2))
        else
            y=$((y - rot + 1))
        fi

        # Rotate 90 degrees to the right
        rot=$(( (rot + 1) % 4 ))
    else
        # Mark the current position as visited (replace with X)
        map=$(sed "${y}s/./X/${x}" <<< "$map")
    fi

    # Move forward based on the current direction
    if [ $((rot % 2)) -eq 1 ]; then
        x=$((x - rot + 2))
    else
        y=$((y + rot - 1))
    fi
done

# Count the number of visited positions (X)
rg -o 'X' <<< "$map" | wc -l
