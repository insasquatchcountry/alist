#!/bin/zsh

printf "%b" "\e[1;34m     ___       __       __       _______.___________.\e[0m\n"
printf "%b" "\e[1;34m    /   \     |  |     |  |     /       |           |\e[0m\n"
printf "%b" "\e[1;34m   /  ^  \    |  |     |  |    |   (----'---|  |----'\e[0m\n"
printf "%b" "\e[1;34m  /  /_\  \   |  |     |  |     \   \       |  |     \e[0m\n"
printf "%b" "\e[1;34m /  _____  \  |  '----.|  | .----)   |      |  |     \e[0m\n"
printf "%b" "\e[1;34m/__/     \__\ |_______||__| |_______/       |__|     \e[0m\n\n"
date

# brew list --cask | tr '\n' ' ' | xargs brew home && brew leaves | tr '\n' ' ' | xargs brew home
# the above will open a the home page of all the apps installed via homebrew

# Function to check if a command exists
check_command() {
    if ! command -v "$1" &> /dev/null; then
        printf "%s could not be found. Please install it to continue.\n" "$1"
        exit 1
    fi
}

# Check if mas and brew are installed
check_command mas
check_command brew


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
            printf "%s (App Store): %s\n" "$app_name" "$app_url"
        else
            printf "%s (App Store): URL not found\n" "$app_name"
        fi
    else
        printf "%s (App Store): Not found (likely an older version than is currently available in the app store)\n" "$app_name"
    fi
done | sort  # Sort the output alphabetically

# Print a new line
printf "\n"
printf "\033[1mHomebrew🍺 Casks and Leaves:\033[0m\n%s"

# Get the list of installed casks
casks=$(brew list --cask)

# Get the list of leaves (non-cask formulae)
leaves=$(brew leaves)

# Combine both lists into one
combined_list=$(echo "$casks"; echo "$leaves")

# Initialize an array to hold the brew home commands
brew_home_commands=()

# Loop through each item in the combined list
while IFS= read -r item; do
    # Check if the item is a valid cask
    if brew list --cask | grep -q "^$item\$"; then
        # Get the homepage URL for the cask, suppressing warnings
        homepage=$(brew info --cask "$item" 2>/dev/null | sed -n '2p')  # Get the second line which contains the URL
        if [ -n "$homepage" ]; then
            printf "%s (Cask): %s\n" "$item" "$homepage"
            brew_home_commands+=("$item")
        else
            printf "%s (Cask): Not found or no homepage available\n" "$item"
        fi 
    # Check if the item is a valid formula
    elif brew list --formula | grep -q "^$item\$"; then
        # Get the homepage URL for the formula, suppressing warnings
        homepage=$(brew info "$item" 2>/dev/null | sed -n '3p')  # Get the third line which contains the URL
        homepage=$(echo "$homepage" | awk '{print $1}')  # Extract the URL part
        if [[ "$homepage" == "http"* ]]; then
            printf "%s (Formula): %s\n" "$item" "$homepage"
            brew_home_commands+=("$item")
        else
            printf "%s (Formula): No homepage available\n" "$item"
        fi
    # Check if the item is a valid formula from a tap
    elif brew info "$item" &>/dev/null; then
        homepage=$(brew info "$item" 2>/dev/null | sed -n '3p')  # Get the third line which contains the URL
        homepage=$(echo "$homepage" | awk '{print $1}')  # Extract the URL part
        if [[ "$homepage" == "http"* ]]; then
            printf "%s (Tapped Formula): %s\n" "$item" "$homepage"
            brew_home_commands+=("$item")
        else
            printf "%s (Tapped Formula): No homepage available\n" "$item"
        fi
    else
        printf "%s: Not found\n" "$item"
    fi
done <<< "$combined_list"

# Print the command to open all homepages
if [ ${#brew_home_commands[@]} -gt 0 ]; then
    printf "\n"
    printf "\033[1m⚠️ FYI this could be \e[1;31mA LOT\e[0m of tabs so... you've been warned 👀\n%s"
    printf "\033[1mTo open all of these homepages in your browser, copy and paste and run this command:\033[0m\n%s"
    printf "brew home ${brew_home_commands[*]}\n"
else
    printf "\n"
    printf "\033[1mNo valid casks or formulas found.\033[0m\n%s"
fi

# this last part could likel be replace with 
# printf "brew home $((brew list --cask; brew leaves) | tr '\n' ' ' )\n"
# Also if I can have it curl the info for all the casks and formula at once, that greatly reduce runtime
