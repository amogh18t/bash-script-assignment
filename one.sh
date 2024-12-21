printf "1. Write a single Linux command to solve below requirements.\n"

printf "\ta. Display count of subscribers present in each subscription tier.\n"
tail -n +2 userdetailscombined.txt | cut -d, -f1,4 | sort | uniq | cut -d, -f2 | sort | uniq -c

printf "\tb. Display total number of subscribers between the age 20 to 30(both inclusive)\n\t"
grep -E '^[^,]+,(2[0-9]|30),' userdetailscombined.txt | cut -d, -f1 | sort | uniq | wc -l

printf "\tc. Display unique genres available in alphabetical order\n"
cut -d, -f2 ShowDetails.txt | tail -n +2 | sort -u

printf "\td. Display User ID, Show ID and completion percentage of the shows with second highest completion percentage\n\t"
cut -d',' -f1,2,5 UserEngagementDetails.txt | tr -d '%#' | tail -n +2 | sort -t',' -k3nr | tail -n +2 | head -n 1 | { IFS=',' read -r a b c; echo "$a, $b, Completion Percentage: $c"; }

printf "\te. Display the number of unique users who have watched each show or movie.\n\t"
cut -d',' -f1,5 userdetailscombined.txt | tail -n +2 | sort -u | cut -d',' -f1 | sort | uniq -c | grep -c "21"

printf "\n"
