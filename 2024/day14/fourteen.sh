#!/bin/bash

# Define grid dimensions
width=101
height=103
halfwidth=$((width / 2))
halfheight=$((height / 2))

# Initialize quadrant counts
quads=(0 0 0 0)

# Read and process the input
while IFS=" " read -r pos vel; do
    # Parse position and velocity
    IFS="=" read -r _ pos <<< "$pos"
    IFS="=" read -r _ vel <<< "$vel"
    IFS="," read -r x y <<< "$pos"
    IFS="," read -r vx vy <<< "$vel"

    # Simulate position after 100
    x=$((((x + vx * 100) % width + width) % width))
    y=$((((y + vy * 100) % height + height) % height))
    # echo "robot is at $x,$y"

    # Skip robots on dividing lines
    if [ $x -eq $halfwidth ] || [ $y -eq $halfheight ]; then
        continue
    fi

    # Determine quadrant
    if [ $x -lt $halfwidth ] && [ $y -lt $halfheight ]; then
        ((quads[0]++)) # Top-left
    elif [ $x -gt $halfwidth ] && [ $y -lt $halfheight ]; then
        ((quads[1]++)) # Top-right
    elif [ $x -lt $halfwidth ] && [ $y -gt $halfheight ]; then
        ((quads[2]++)) # Bottom-left
    elif [ $x -gt $halfwidth ] && [ $y -gt $halfheight ]; then
        ((quads[3]++)) # Bottom-right
    fi
done < input

# Output quadrant counts
echo "Top-left: ${quads[0]}"
echo "Top-right: ${quads[1]}"
echo "Bottom-left: ${quads[2]}"
echo "Bottom-right: ${quads[3]}"

# Compute safety factor
safety_factor=1
for quad in "${quads[@]}"; do
    safety_factor=$((safety_factor * quad))
done

echo "Safety Factor: $safety_factor"
