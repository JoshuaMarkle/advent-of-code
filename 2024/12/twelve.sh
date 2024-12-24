#!/bin/bash

# Read the input + other stuff
mapfile -t map < input
width=${#map[0]}
height=${#map[@]}
directions=("-1,0" "1,0" "0,-1" "0,1")
declare -A visited
sum=0

# Loop through the map
for ((y=0; y<height; y++)); do
    for ((x=0; x<width; x++)); do
        # Skip if already visited
        if [[ "${visited[$y,$x]}" == "1" ]]; then continue; fi

        char="${map[$y]:$x:1}"

        # Skip empty space
        if [[ -z "$char" ]]; then continue; fi

        # Begin flood fill
        queue=("$x,$y")
        area=0
        perimeter=0

        while [ ${#queue[@]} -gt 0 ]; do
            # Pop the first element
            current=${queue[0]}
            queue=("${queue[@]:1}")
            IFS=',' read -r cx cy <<< "$current"

            # Skip if out of bounds
            if ((cx < 0 || cy < 0 || cx >= width || cy >= height)); then
                ((perimeter++))
                continue
            fi

			# Skip is already visited
            if [[ "${visited[$cy,$cx]}" == "1" ]]; then
                continue
            fi

            # Skip if not the same character
            if [[ "${map[$cy]:$cx:1}" != "$char" ]]; then
                ((perimeter++))
                continue
            fi

            visited["$cy,$cx"]=1
            ((area++))

            # Check all neighbors for perimeter
            for dir in "${directions[@]}"; do
                IFS=',' read -r dx dy <<< "$dir"
                nx=$((cx + dx))
                ny=$((cy + dy))
                if ((nx < 0 || ny < 0 || nx >= width || ny >= height)); then
                    ((perimeter++))
                elif [[ "${map[$ny]:$nx:1}" != "$char" ]]; then
                    ((perimeter++))
                else
                    queue+=("$nx,$ny")
                fi
            done
        done

        # Calculate the cost
        cost=$((area * perimeter))
        sum=$((sum + cost))

        # echo "Region $char: Area=$area, Perimeter=$perimeter, Cost=$cost"
    done
done

echo "Total Cost: $sum"
