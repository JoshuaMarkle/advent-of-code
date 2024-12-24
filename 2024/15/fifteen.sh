#!/bin/bash

map=()
moves=""
ci=-1
cj=-1

# Read the input
while IFS= read -r line; do
    if [[ $line == \#* ]]; then
        map+=("$line")
    else
        moves+=$(echo -n "$line" | tr -d '\n')
    fi
done < input
height=${#map[@]}
width=${#map[0]}

# Find the starting position
for ((i = 0; i < height; i++)); do
    row=${map[$i]}
    for ((j = 0; j < width; j++)); do
        if [[ ${row:j:1} == "@" ]]; then
            ci=$i
            cj=$j
            map[$i]="${row:0:j}.${row:$((j+1))}"
            break 2
        fi
    done
done

# Look at each move
for ((k = 0; k < ${#moves}; k++)); do
    move=${moves:$k:1}
    case $move in
    '>') # Move right
        if ((cj + 1 < width)); then
            next=${map[$ci]:$((cj+1)):1}
            if [[ $next == "." ]]; then
                cj=$((cj + 1))
            elif [[ $next == "O" ]]; then
                for ((m = cj + 2; m < width; m++)); do
                    block=${map[$ci]:$m:1}
                    if [[ $block == "#" ]]; then
                        break
                    elif [[ $block == "." ]]; then
                        map[$ci]="${map[$ci]:0:$m}O${map[$ci]:$((m+1))}"
                        map[$ci]="${map[$ci]:0:$((cj+1))}.${map[$ci]:$((cj+2))}"
                        cj=$((cj + 1))
                        break
                    fi
                done
            fi
        fi
        ;;
    '<') # Move left
        if ((cj - 1 >= 0)); then
            next=${map[$ci]:$((cj-1)):1}
            if [[ $next == "." ]]; then
                cj=$((cj - 1))
            elif [[ $next == "O" ]]; then
                for ((m = cj - 2; m >= 0; m--)); do
                    block=${map[$ci]:$m:1}
                    if [[ $block == "#" ]]; then
                        break
                    elif [[ $block == "." ]]; then
                        map[$ci]="${map[$ci]:0:$m}O${map[$ci]:$((m+1))}"
                        map[$ci]="${map[$ci]:0:$((cj-1))}.${map[$ci]:$cj}"
                        cj=$((cj - 1))
                        break
                    fi
                done
            fi
        fi
        ;;
    'v') # Move down
        if ((ci + 1 < height)); then
            next=${map[$((ci+1))]:$cj:1}
            if [[ $next == "." ]]; then
                ci=$((ci + 1))
            elif [[ $next == "O" ]]; then
                for ((m = ci + 2; m < height; m++)); do
                    block=${map[$m]:$cj:1}
                    if [[ $block == "#" ]]; then
                        break
                    elif [[ $block == "." ]]; then
                        map[$m]="${map[$m]:0:$cj}O${map[$m]:$((cj+1))}"
                        map[$((ci+1))]="${map[$((ci+1))]:0:$cj}.${map[$((ci+1))]:$((cj+1))}"
                        ci=$((ci + 1))
                        break
                    fi
                done
            fi
        fi
        ;;
    '^') # Move up
        if ((ci - 1 >= 0)); then
            next=${map[$((ci-1))]:$cj:1}
            if [[ $next == "." ]]; then
                ci=$((ci - 1))
            elif [[ $next == "O" ]]; then
                for ((m = ci - 2; m >= 0; m--)); do
                    block=${map[$m]:$cj:1}
                    if [[ $block == "#" ]]; then
                        break
                    elif [[ $block == "." ]]; then
                        map[$m]="${map[$m]:0:$cj}O${map[$m]:$((cj+1))}"
                        map[$((ci-1))]="${map[$((ci-1))]:0:$cj}.${map[$((ci-1))]:$((cj+1))}"
                        ci=$((ci - 1))
                        break
                    fi
                done
            fi
        fi
        ;;
    esac
done

# Calculate the sum of GPS coordinates
sum=0
for ((i = 0; i < height; i++)); do
    row=${map[$i]}
    for ((j = 0; j < width; j++)); do
        if [[ ${row:j:1} == "O" ]]; then
            sum=$((sum + i * 100 + j))
        fi
    done
done

# Output the result
echo "$sum"
