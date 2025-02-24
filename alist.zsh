#!/bin/zsh

printf "%b" "\e[1;34m     ___       __       __       _______.___________.\e[0m\n"
printf "%b" "\e[1;34m    /   \     |  |     |  |     /       |           |\e[0m\n"
printf "%b" "\e[1;34m   /  ^  \    |  |     |  |    |   (----'---|  |----'\e[0m\n"
printf "%b" "\e[1;34m  /  /_\  \   |  |     |  |     \   \       |  |     \e[0m\n"
printf "%b" "\e[1;34m /  _____  \  |  '----.|  | .----)   |      |  |     \e[0m\n"
printf "%b" "\e[1;34m/__/     \__\ |_______||__| |_______/       |__|     \e[0m\n"
printf "\033[1m Sauce: \e[1;31mhttps://github.com/insasquatchcountry/alist\e[0m\n%s"
date

# Check if brew is installed
if ! command -v brew &> /dev/null; then
    printf "\033[1m\e[1;31m ERROR: \e[0mHomebrew could not be found. Please install it to continue.\n"
printf "For more info, visit → https://brew.sh\n"
    return
fi

# Check if mas is installed
if ! command -v mas &> /dev/null; then
    printf "\033[1m\e[1;31m ERROR: \e[0mmas could not be found.\n" 
printf "Please install it to continue → brew install mas\n\n"
brew info mas
    return
fi

# Find Ambiguously Sourced Apps
# Step 1: Get the list of installed App Store apps
app_store_apps=$(mas list | awk '{$1=""; $NF=""; sub(/^ *| *$/, ""); print}' | sed 's/^[ \t]*//;s/[ \t]*$//' | sort -f)

# Normalize App Store apps
normalized_app_store_apps=$(echo "$app_store_apps" | tr '[:upper:]' '[:lower:]' | sed 's/[ -]//g')

# Output the results
# printf "\033[1mFrom App Store:\033[0m\n%s\n\n" "$app_store_apps"

# Step 2: Get the list of installed Homebrew casks
brew_casks=$(brew list --cask | sort -f)

# Normalize Homebrew casks
normalized_brew_casks=$(echo "$brew_casks" | tr '[:upper:]' '[:lower:]' | sed 's/[ -]//g')

# Output the results
# printf "\033[1mHomebrew Casks:\033[0m\n%s\n\n" "$brew_casks"

# Step 3: Get the list of applications in the /Applications folder
applications_folder=$(ls -p /Applications | grep -e .app/ | sed 's/.app\///' | sort -f)

# Normalize applications
normalized_applications_folder=$(echo "$applications_folder" | tr '[:upper:]' '[:lower:]' | sed 's/[ -]//g')

# Output the results
# printf "Applications in /Applications folder:\n%s\n\n" "$applications_folder"

# Step 4: Filter out App Store apps and Homebrew casks
minus_store_and_brew=$(echo "$normalized_applications_folder" | grep -v -F -f <(echo "$normalized_app_store_apps") | grep -v -F -f <(echo "$normalized_brew_casks"))

# Convert the filtered list back to the original format for output
final_minus_store_and_brew=$(echo "$minus_store_and_brew" | sed 's/_/ /g')

# Output the results
printf "\n\033[1m⚠️ Apps In Applications Folder With \e[1;31mSources Unclear\e[0m:\n%s\n\n" "$final_minus_store_and_brew"


# Get the list of installed App Store apps first
printf "\033[1mFrom  App Store:\033[0m\n%s"
mas list | while IFS= read -r line; do
    # Extract the app ID
    app_id=$(echo "$line" | awk '{print $1}')
    
    # Extract the app name without the first and last elements using awk
    app_name=$(echo "$line" | awk '{$1=""; $NF=""; sub(/ *$/, ""); print $0}' | xargs)  # Remove the first and last fields and trim whitespace

    # Get app info using mas
    app_info=$(mas info "$app_id" 2>/dev/null)
    if [ -n "$app_info" ]; then
        # Extract the URL from the app info
        app_url=$(echo "$app_info" | grep -o 'https://apps.apple.com[^ ]*')
        if [ -n "$app_url" ]; then
            # Print the app name and URL in the desired format
            printf "%-20s %s\n" "$app_name" "$app_url"
        else
            printf "%s URL not found\n" "$app_name"
        fi
    else
        printf "%-20s Not found - likely an older version than is currently available in the app store%s\n" "$app_name"
    fi
done | sort  # Sort the output alphabetically

printf "\n\033[1mHomebrew🍺 Casks:\033[0m\n%s"
brew info -q --json=v2 $(brew ls --cask -q) | jq -r '.casks[] | [.token, .homepage] | @tsv' | column -t
# alt for spaces instead of columns
# brew info -q --json=v2 $(brew ls --cask -q) | jq -r '.casks[] | [.token, .homepage] | @tsv' | awk -v OFS=' ' '{ print $1, $2 }'

printf "\n\033[1mHomebrew🍺 Leaves:\033[0m\n%s"
brew info -q --json=v2 $(brew leaves) | jq -r '.formulae[] | [.full_name, .homepage] | @tsv' | column -t
# alt for spaces instead of columns
# brew info -q --json=v2 $(brew leaves) | jq -r '.formulae[] | [.full_name, .homepage] | @tsv' | awk -v OFS=' ' '{ print $1, $2 }'


# Print the command to open all homepages
printf "\n"
printf "\033[1m⚠️ FYI this could be \e[1;31mA LOT\e[0m of tabs so... you've been warned 👀\n%s"
printf "\033[1mTo open all of these homepages in your browser, copy and paste and run this command:\033[0m\n\n%s"
printf "brew home $((brew list --cask; brew leaves) | tr '\n' ' ' )\n\n"
