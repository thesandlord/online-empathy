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

CAST=$(sed -n '/Do you want to submit this empathy session?/q;p' .session.cast | gzip | base64 -w0)

NAME=$(cat steps.yaml | shyaml get-value name)

ID=$(cat steps.yaml | shyaml get-value id)

#echo '{"email":"'"$EMAIL"'", "role":"'"$ROLE"'", "rate":"'"$RATE"'", "understand":"'"$UNDERSTAND"'", "gaps":"'"$GAPS"'", "additional":"'"$ADDITIONAL"'", "cast":"'"$CAST"'"}';
curl -s -d '{"challenge_name":"'"$NAME"'", "challenge_id":"'"$ID"'", "email":"'"$EMAIL"'", "role":"'"$ROLE"'", "rate":"'"$RATE"'", "understand":"'"$UNDERSTAND"'", "gaps":"'"$GAPS"'", "additional":"'"$ADDITIONAL"'", "cast":"'"$CAST"'"}' -H "Content-Type: application/json" -X POST \
    http://submit-3shqsftkcq-uc.a.run.app > /dev/null
clear
echo "Session Saved! Thank you!"