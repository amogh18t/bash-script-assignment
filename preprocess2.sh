#!/bin/bash

# Input and output file paths
input_file="UserEngagementDetails.txt"
output_file="ued.txt"

# Process the input file and apply the cleaning rules
awk -F, '
BEGIN { OFS = "," }
NR == 1 {
    # Print the header as is
    print
    next
}
{
    # Skip empty records
    if (NF == 0 || $0 ~ /^[[:space:]]*$/) {
        next
    }
    
    # Skip records where user id is '?'
    if ($1 == "?") {
        next
    }
    
    # Remove special characters from completion percentage
    gsub(/[^0-9]/, "", $5)
    
    # If completion percentage is empty, replace it with 0
    if ($5 == "") {
        $5 = 0
    }
    
    print
}
' "$input_file" > "$output_file"

echo "Cleaned data has been saved to $output_file"
