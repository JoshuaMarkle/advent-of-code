#!/bin/bash

# Make the map
width=$(($(head -n1 input | wc -c) - 1))
height=$(wc -l < input)
mapfile -t map < input

# Other vars
directions=("1,1" "1,0" "1,-1" "0,1" "0,-1" "-1,1" "-1,0" "-1,-1")
word="XMAS"
total=0

# for each position; for each direction; check valid word
for ((x=0; x<height; x++)); do
    for ((y=0; y<width; y++)); do
        for dir in "${directions[@]}"; do
            IFS="," read -r dirx diry <<< "$dir"

			# Check if valid
            valid=true
            for ((i=0; i<${#word}; i++)); do
                posx=$((x + dirx * i))
                posy=$((y + diry * i))

				# Check bounds (optimization)
                if ((posx < 0 || posy < 0 || posx >= height || posy >= width)); then
                    valid=false
                    break
                fi

				# Check if matches XMAS
                line=${map[posx]}
                char=${line:posy:1}
                if [ "$char" != "${word:i:1}" ]; then
                    valid=false
                    break
                fi
            done
            if $valid; then ((total++)); fi
        done
    done
done

echo $total
