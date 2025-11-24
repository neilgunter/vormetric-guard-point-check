#!/bin/bash

# Variables
LOGFILE="guardpoint_test_log.txt"  # This is where all the results will be saved
GUARDPOINT="/path/to/your/guardpoint"  # Replace with the actual path of the guard point

# Function to log both to the screen and the log file
log() {
    echo "$1" | tee -a "$LOGFILE"
}

# Step 1: Ask for the Jira number and create a test description file
log "What is the Jira associated with this test?"
read jira
timestamp=$(date "+%Y-%m-%d %H:%M:%S")
echo "This is the empty guard test, with Jira number $jira, on $timestamp, to be used for testing the enable and disable of guard points." > test_description.txt
log "Created test description file: test_description.txt"

# Step 2: Ask the user to enable the guard point
log "Ensure the guard point is enabled on the DSM, and press ENTER."
read -p ""  # Wait for the user to press ENTER
log "Checking to see if the guard point is enabled..."

# Function to check the guard point status
check_guardpoint_status() {
    status=$(vmd -status -gp "$GUARDPOINT" | grep -w 'guarded')
    echo "$status"
}

# Keep checking if the guard point is enabled (guarded)
while [ -z "$(check_guardpoint_status)" ]; do
    log "Guard point is not yet guarded, waiting..."
    sleep 5
done
log "Guard point is enabled (guarded)."

# Step 3: Display the test file and ask if it shows clear text
cat test_description.txt | tee -a "$LOGFILE"
log "Did the guard point display clear text? (Y/N)"
read clear_text

# Step 4: Ask the user to disable the guard point
log "Disable the guard point on the DSM and press ENTER."
read -p ""  # Wait for the user to press ENTER
log "Checking to see if the guard point is disabled..."

# Keep checking if the guard point is disabled
while [ -n "$(check_guardpoint_status)" ]; do
    log "Guard point is still guarded, waiting..."
    sleep 5
done
log "Guard point is disabled (not guarded)."

# Step 5: Display the test file and ask if it shows cipher text
cat test_description.txt | tee -a "$LOGFILE"
log "Did the guard point display cipher text? (Y/N)"
read cipher_text

# Step 6: Ask the user to enable the guard point again
log "Ensure the guard point is enabled on the DSM, and press ENTER."
read -p ""  # Wait for the user to press ENTER
log "Checking to see if the guard point is enabled..."

# Keep checking if the guard point is enabled (guarded)
while [ -z "$(check_guardpoint_status)" ]; do
    log "Guard point is not yet guarded, waiting..."
    sleep 5
done
log "Guard point is enabled (guarded)."

# Step 7: Display the test file and ask if it shows clear text again
cat test_description.txt | tee -a "$LOGFILE"
log "Did the guard point display clear text? (Y/N)"
read clear_text_final

# Final Step: Check if the test passed or failed
if [[ "$clear_text" == "Y" && "$cipher_text" == "Y" && "$clear_text_final" == "Y" ]]; then
    log "Test is complete: When guarded, the text displayed as clear, and when the guard point was disabled, the text displayed as cipher."
else
    log "Test is incomplete or failed: Please review the steps."
fi

log "All output is saved in $LOGFILE"
