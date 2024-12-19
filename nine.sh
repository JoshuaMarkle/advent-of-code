#!/bin/bash

instructions=($(cat input | fold -w1))

# Loop through the original memory map
# Update checksum for known values
# Keep todo list for blank spots
# Loop through todo list and update checksum

# Create the memory string
file=true
files=()
todo=()
memory=()
index=0
i=0
for instruction in ${instructions[@]}; do
	((instruction++))
	if $file; then
		block+=($(seq -s. $instruction | sed 's/[0-9]/ /g' | sed "s/./$index /g"))
		memory+=($(seq -s. $instruction | sed 's/[0-9]//g' | tr "." $index))
		files=($block "${files[@]}")
		((index++))
		file=false
	else
		memory+=$(seq -s. $instruction | sed 's/[0-9]//g')
		todo+=($(seq $i 1 $((i + instruction - 2))))
		file=true
	fi
	i=$((i + instruction - 1))
done

echo ${memory[@]}
echo ${files[@]}
echo ${todo[@]}

# Do the checksum
sum=0
for ((i = 0; i < $((${#memory[@]} - 1)); i++)); do
	mem=${memory[$i]}
	if [ $mem != "." ]; then
		echo "$sum += $i * $mem"
		sum=$((sum + i * mem))
	else
		t=${todo[0]}
		sum=$((sum + ${todo[0]} * ${files[0]}))
		todo=${todo[@]:2}
		files=${files[@]:2}
	fi
done
