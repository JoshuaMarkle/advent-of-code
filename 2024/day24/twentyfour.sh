#!/bin/bash

declare -A wires
declare -a queue

# Read input
reading_values=true
while IFS= read -r line; do
    if [[ -z "$line" ]]; then
        reading_values=false
        continue
    fi

    if $reading_values; then
		# Parse wire initial values
        if [[ "$line" =~ ([a-z0-9]+):[[:space:]]([01]) ]]; then
            wires["${BASH_REMATCH[1]}"]="${BASH_REMATCH[2]}"
        fi
    else
        # Add gates to the queue
        queue+=("$line")
    fi
done < input

# Small function to find a wire's value
resolve_wire() {
    local wire=$1
    if [[ "$wire" =~ ^[01]$ ]]; then
        # Direct value
        echo "$wire"
    elif [[ -n "${wires[$wire]}" ]]; then
        # Cached value
        echo "${wires[$wire]}"
    else
        # Not resolved
        echo ""
    fi
}

# Process the gates
while [ ${#queue[@]} -gt 0 ]; do
    equation="${queue[0]}"
    queue=("${queue[@]:1}") # Pop the first element

    # Gate
    if [[ "$equation" =~ ([a-z0-9]+)\ ([A-Z]+)\ ([a-z0-9]+)\ \-\>\ ([a-z0-9]+) ]]; then
        op1="${BASH_REMATCH[1]}"
        operator="${BASH_REMATCH[2]}"
        op2="${BASH_REMATCH[3]}"
        result="${BASH_REMATCH[4]}"

        # Operands
        value1=$(resolve_wire "$op1")
        value2=$(resolve_wire "$op2")

        # Are both ops defined
        if [[ -n "$value1" && -n "$value2" ]]; then
            case "$operator" in
                AND)
                    wires["$result"]=$((value1 & value2))
                    ;;
                OR)
                    wires["$result"]=$((value1 | value2))
                    ;;
                XOR)
                    wires["$result"]=$((value1 ^ value2))
                    ;;
            esac
        else
            # Add to queue if unresolved
            queue+=("$equation")
        fi
    fi
done

# Combine bits (starting with z) and find output
final=""
for key in $(printf "%s\n" "${!wires[@]}" | grep '^z' | sort); do
    final="${wires[$key]}$final"
done
echo "Decimal: $((2#$final))"
