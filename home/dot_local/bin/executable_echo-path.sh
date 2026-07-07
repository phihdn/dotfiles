#!/bin/bash

# Display PATH in a human-friendly format

echo "Current PATH directories:"
echo "========================"
echo ""

# Split PATH by colon and display each directory on a new line with numbering
IFS=':' read -ra PATHS <<< "$PATH"
for i in "${!PATHS[@]}"; do
    printf "%2d: %s\n" $((i+1)) "${PATHS[$i]}"
done

echo ""
echo "Total directories: ${#PATHS[@]}"