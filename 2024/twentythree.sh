#!/bin/bash

mapfile -t connections < input
declare -A graph

# Build the graph using adjacency lists
for connection in "${connections[@]}"; do
    IFS="-" read -r a b <<< "$connection"
    graph["$a"]+="$b "
    graph["$b"]+="$a "
done

# Declare a set for unique triangles
declare -A triangles

# Find all triangles
for node in "${!graph[@]}"; do
    neighbors=(${graph[$node]})
    for ((i = 0; i < ${#neighbors[@]}; i++)); do
        n1="${neighbors[i]}"
        for ((j = i + 1; j < ${#neighbors[@]}; j++)); do
            n2="${neighbors[j]}"
            # Check if n1 and n2 are connected
            if [[ " ${graph[$n1]} " == *" $n2 "* ]]; then
                # Create a unique sorted triangle key
                sorted_triangle=$(echo -e "$node\n$n1\n$n2" | sort | tr "\n" "-")
                sorted_triangle=${sorted_triangle%-}
                triangles["$sorted_triangle"]=1
            fi
        done
    done
done

# Filter triangles containing a node starting with 't'
count=0
for triangle in "${!triangles[@]}"; do
    if [[ "$triangle" == *"t"* ]]; then
        ((count++))
        echo "$triangle"
    fi
done

echo "Triangles containing 't': $count"
