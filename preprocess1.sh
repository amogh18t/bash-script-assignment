#!/bin/bash

# Function to process user details files
process_user_details() {
    local output_file="UserDetailsCombined.txt"

    # Check if output file already exists and delete if so
    [ -f "$output_file" ] && rm "$output_file"

    # Loop through each input file provided as arguments
    for input_file in "$@"; do
        # Check if input file exists
        if [ ! -f "$input_file" ]; then
            echo "Error: File '$input_file' does not exist."
            continue  # Skip this file and move to the next
        fi

        # Read each line from the input file
        while IFS= read -r line || [[ -n "$line" ]]; do
            # Skip empty lines or lines that start with a comma (indicating a missing entry)
            if [[ -z "$line" || "$line" == ","* ]]; then
                continue  # Skip empty or malformed lines
            fi

            # Replace consecutive white spaces with a single space
            cleaned_line=$(echo "$line" | sed 's/ \+/ /g')

            # Remove leading and trailing spaces
            cleaned_line=$(echo "$cleaned_line" | sed 's/^ *//;s/ *$//')

            # Split the line by comma or hash
            IFS=',#' read -r userid age location subscription watchhistory <<< "$cleaned_line"

            # Remove non-numeric characters from Age column
            age=$(echo "$age" | sed 's/[^0-9]//g')

            # Ensure Age is a valid number or replace it with a placeholder
            if [[ -z "$age" ]]; then
                continue
            fi

            # Convert Subscription column to uppercase
            subscription=$(echo "$subscription" | tr '[:lower:]' '[:upper:]')

            # Split the WatchHistory column into ShowID, TimeStamp, Rating
            IFS='|' read -ra histories <<< "$watchhistory"
            for history in "${histories[@]}"; do
                # Split each history entry by semicolon
                IFS=';' read -r showid timestamp rating <<< "$history"

                # Print each transformed record to the output file
                echo "$userid,$age,$location,$subscription,$showid,$timestamp,$rating" >> "$output_file"
            done
        done < "$input_file"
    done

    echo "Processing completed. The combined data is saved in $output_file."
}

# Usage example: call the function with input files
tr "#" "," < UserDetails1.txt > UserDetails1n.txt
tail -n +2 UserDetails2.dat > UserDetails2n.dat
process_user_details UserDetails1n.txt UserDetails2n.dat
rm UserDetails1n.txt UserDetails2n.dat

sed -i '1s/.*/UserID,Age,Location,SUBSCRIPTION,MovieID,WatchDate,Ratings/' UserDetailsCombined.txt
sed -i '/^,$/d' UserDetailsCombined.txt
sed -i '/^,,/d' UserDetailsCombined.txt

