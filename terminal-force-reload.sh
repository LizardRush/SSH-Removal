#!/bin/bash

echo "Terminating all non-system applications..."

# Get the list of all running processes excluding system processes
for pid in $(ps -e -o pid=); do
    # Get the process name and its owner
    process_info=$(ps -p $pid -o comm=,uid=)
    process_name=$(echo $process_info | cut -d' ' -f1)
    uid=$(echo $process_info | cut -d' ' -f2)

    # Check if the process is not a system process (UID 0)
    if [[ $uid -ne 0 ]]; then
        echo "Terminating process: $process_name"
        kill -9 $pid 2>/dev/null
    fi
done

echo "All non-system applications have been terminated."
