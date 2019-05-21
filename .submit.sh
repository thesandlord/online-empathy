EMAIL=$(gcloud config get-value core/account 2> /dev/null)

exec 3>&1;

ROLE=$(dialog --inputbox "What is your role on the team?" 0 0 2>&1 1>&3);

RATE=$(dialog --menu "How would you rate the challenge?" 0 0 5 \
    1 "1 Needs Work" \
    2 "2" \
    3 "3" \
    4 "4" \
    5 "5 Fantastic" \
    2>&1 1>&3);

dialog --yesno "Did this challenge help you understand our customers better?" 0 0 2>&1 1>&3;
UNDERSTAND=$?;

GAPS=$(dialog --checklist "What immediate gaps did you discover in the product?" 0 0 5 \
    1 "Gaps in Documentation" off \
    2 "Features that weren't necessary" off \
    3 "Features that should be prioritized" off \
    4 "Missing Key Features" off \
    5 "Unknown Bugs" off \
    2>&1 1>&3);

ADDITIONAL=$(dialog --inputbox "Additional Feedback:" 0 100 2>&1 1>&3);

exec 3>&-;
#echo $ROLE $RATE $UNDERSTAND $GAPS $ADDITIONAL;
curl -s -d '{"email":"'"$EMAIL"'", "role":"'"$ROLE"'", "rate":"'"$RATE"'", "understand":"'"$UNDERSTAND"'", "gaps":"'"$GAPS"'", "additional":"'"$ADDITIONAL"'"}' -H "Content-Type: application/json" -X POST \
    http://localhost:8080 > /dev/null
clear
echo "Session Saved! Thank you!"