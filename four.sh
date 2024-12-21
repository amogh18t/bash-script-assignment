#!/bin/bash

printf "4. Write a shell script to display the genre with minimum average completion rate.\n"

# Input file
input_file="ued.txt"

# Temp file to store intermediate data
temp_file="temp_data.txt"

# Ensure the temp file is empty
> "$temp_file"

# Extract unique ShowIDs from the input file, skipping the header
show_ids=$(tail -n +2 "$input_file" | cut -d',' -f2 | sort | uniq)

# Temp file to store genre averages
genre_avg_file="genre_averages.txt"
> "$genre_avg_file"

# Loop through each ShowID
for show_id in $show_ids; do
    # Extract lines with the current ShowID and get the CompletionPercent, skipping the header
    tail -n +2 "$input_file" | grep ",${show_id}," | cut -d',' -f5 > "$temp_file"

    # Initialize total and count
    total=0
    count=0

    # Calculate the total and count of completion percentages
    while read -r percent; do
        if [[ $percent =~ ^[0-9]+$ ]]; then
            total=$((total + percent))
            count=$((count + 1))
        else
            echo "Skipping invalid percentage: $percent"
        fi
    done < "$temp_file"

    # Calculate the average
    if [ $count -ne 0 ]; then
        average=$((total / count))
    else
        average=0
    fi

    # Print the result, skip shows with 0 average
    if [ $average -ne 0 ]; then
        echo "$show_id,$average" >> "$genre_avg_file"
    fi
done

# Find the ShowID with the minimum average completion rate
min_show=$(sort -t',' -k2 -n "$genre_avg_file" | head -n 1)

# Display the result
echo "Show with minimum average completion rate: $min_show"

# Cleanup
rm "$temp_file" "$genre_avg_file"

printf "\n"
