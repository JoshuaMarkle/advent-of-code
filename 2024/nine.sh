#!/bin/bash

input=$(cat input)

# Parse input into data pairs (file size, free space)
data=()
for ((i=0; i<${#input}; i+=2)); do
    file_size=${input:$i:1}
    free_space=0
    if (( i + 1 < ${#input} )); then
        free_space=${input:$((i + 1)):1}
    fi
    data+=("$file_size,$free_space")
done

# Create blocks layout from parsed data
declare -a blocks
file_id=0
for entry in "${data[@]}"; do
    IFS=',' read -r file_size free_space <<< "$entry"
    for ((j=0; j<file_size; j++)); do
        blocks+=("$file_id")
    done
    for ((j=0; j<free_space; j++)); do
        blocks+=(".")
    done
    ((file_id++))
done

# Compact the files in the blocks array
read_ptr=$((${#blocks[@]} - 1))
write_ptr=0

# Find the first free space
while [[ ${blocks[$write_ptr]} != "." ]]; do
    ((write_ptr++))
done

# Compacting logic
while (( read_ptr >= write_ptr )); do
    if [[ ${blocks[$read_ptr]} != "." ]]; then
        blocks[$write_ptr]=${blocks[$read_ptr]}
        blocks[$read_ptr]="."
        ((write_ptr++))
        # Advance write_ptr to the next free space
        while [[ $write_ptr -lt ${#blocks[@]} && ${blocks[$write_ptr]} != "." ]]; do
            ((write_ptr++))
        done
    fi
    ((read_ptr--))
done

# Compute checksum
checksum=0
for ((i=0; i<${#blocks[@]}; i++)); do
    if [[ ${blocks[$i]} != "." ]]; then
        checksum=$((checksum + i * ${blocks[$i]}))
    fi
done

echo "Checksum: $checksum"
