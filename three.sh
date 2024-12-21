#!/bin/bash

printf "3. Write a shell script to display the average rating for each genre.\n"

# File paths
SHOW_DETAILS="ShowDetails.txt"
USER_DETAILS="UserDetailsCombined.txt"

# Temporary file to store combined data
TEMP_FILE="combined_data.txt"

# Clear the temporary file if it exists and add the header
echo "ShowID,Genre,Actors,Director,Release_Year,Synopsis,UserID,Age,Location,SUBSCRIPTION,WatchDate,Ratings" > "$TEMP_FILE"

# Joining files based on MovieID and ShowID
tail -n +2 "$USER_DETAILS" | while IFS=, read -r UserID Age Location SUBSCRIPTION MovieID WatchDate Ratings; do
    grep "^$MovieID," "$SHOW_DETAILS" | while IFS=, read -r ShowID Genre Actors Director Release_Year Synopsis; do
        echo "$ShowID,$Genre,$Actors,$Director,$Release_Year,$Synopsis,$UserID,$Age,$Location,$SUBSCRIPTION,$WatchDate,$Ratings" >> "$TEMP_FILE"
    done
done

# Calculating average ratings per genre
awk -F, '
{
    genre[$2] += $12
    count[$2]++
}
END {
    print "Genre,Average_Rating"
    for (g in genre) {
        printf "%s,%.2f\n", g, genre[g] / count[g]
    }
}' "$TEMP_FILE"

# Cleanup
rm "$TEMP_FILE"

printf "\n"
