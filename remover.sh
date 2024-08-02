#!/bin/bash

# Fetch the search patterns from the URL
url="https://raw.githubusercontent.com/LizardRush/SSH-Removal/main/searchfor.txt"
search_patterns=($(curl -s "$url"))

found_malware=false
found_connections=false

# Check for SSH-related processes
for pattern in "${search_patterns[@]}"; do
    if pgrep -f "$pattern" > /dev/null; then
        echo "Found process: $pattern"
        found_malware=true
    fi
done

# Check for active SSH connections
if netstat -tuln | grep ":22" > /dev/null; then
    echo "Active SSH connections found."
    found_connections=true
fi

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

if $found_connections; then
    read -p "Track active SSH connections (y/n)? " track
    if [[ "$track" == "y" ]]; then
        netstat -tuln | grep ":22"
    fi
fi
