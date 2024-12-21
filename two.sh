#!/bin/bash
printf "2. Write a shell script to display the show ID, which are watched with less than 50% average completion rate.\n"
# File containing the user engagement details
input_file="ued.txt"

# Arrays to store Show IDs, total completion percentages, and counts
show_ids=()
show_completion=()
show_count=()

# Function to get the index of a show ID in the show_ids array
get_show_index() {
  local show_id="$1"
  for i in "${!show_ids[@]}"; do
    if [[ "${show_ids[$i]}" == "$show_id" ]]; then
      echo "$i"
      return
    fi
  done
  echo -1
}

# Read the input file line by line
while IFS=',' read -r user_id show_id playback_started playback_stopped completion_percent; do
  # Skip the header line
  if [[ "$user_id" == "UserID" ]]; then
    continue
  fi

  # Get the index of the show ID
  index=$(get_show_index "$show_id")

  # If the show ID is not found, add it to the arrays
  if [[ "$index" -eq -1 ]]; then
    show_ids+=("$show_id")
    show_completion+=(completion_percent)
    show_count+=(1)
  else
    # Update the total completion percentage and count for the show ID
    show_completion[$index]=$((show_completion[$index] + completion_percent))
    show_count[$index]=$((show_count[$index] + 1))
  fi
done < "$input_file"

# Calculate and display the Show IDs with less than 50% average completion rate
echo "Show IDs with less than 50% average completion rate:"
for i in "${!show_ids[@]}"; do
  total_completion=${show_completion[$i]}
  count=${show_count[$i]}
  average_completion=$((total_completion / count))

  if (( average_completion < 50 )); then
    echo "${show_ids[$i]}"
  fi
done

printf "\n"
