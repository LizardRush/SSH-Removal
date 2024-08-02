#!/bin/bash

# Search for potential SSH-related processes or similar applications
found_malware=false

# Define patterns for SSH and similar applications
search_patterns=("sshd" "putty" "openssh" "ssh-agent")

# Check for SSH-related processes
for pattern in "${search_patterns[@]}"; do
    if pgrep -f "$pattern" > /dev/null; then
        echo "Found: $pattern"
        found_malware=true
    fi
done

# Check for executed scripts (e.g., .sh, .py, .pl)
for script in *.sh *.py *.pl; do
    if [[ -e "$script" ]]; then
        echo "Found executed script: $script"
        found_malware=true
    fi
done

if $found_malware; then
    read -p "Uninstall these (y/n)? " uninstall
    if [[ "$uninstall" == "y" ]]; then
        for pattern in "${search_patterns[@]}"; do
            pkill -f "$pattern" 2>/dev/null
            if [[ $? -ne 0 ]]; then
                read -p "$pattern failed to uninstall, track requests (y/n)? " track
                if [[ "$track" == "y" ]]; then
                    echo "Tracking requests from $pattern..."
                    # Insert tracking logic here
                fi
            fi
        done

        for script in *.sh *.py *.pl; do
            if [[ -e "$script" ]]; then
                rm "$script" 2>/dev/null
                if [[ $? -ne 0 ]]; then
                    read -p "$script failed to uninstall, track requests (y/n)? " track
                    if [[ "$track" == "y" ]]; then
                        echo "Tracking requests from $script..."
                        # Insert tracking logic here
                    fi
                fi
            fi
        done
    fi
else
    echo "No SSH-related processes or executed scripts found."
fi
