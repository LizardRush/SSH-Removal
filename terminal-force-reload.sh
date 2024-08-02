#!/bin/bash

echo "Terminating all non-system EXE applications and terminal processes..."

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

# Close common terminal applications
for terminal in gnome-terminal xterm konsole terminal; do
    echo "Terminating terminal process: $terminal"
    pkill -f $terminal
done

echo "All non-system EXE applications and terminal processes have been terminated."
