# alist
A script that lists out all of the apps installed on macOS from the app store, homebrew, and elsewhere...
___

⛔️ 2025-04-07 - As of macOS Sequoia 15.4 the mas cli tool used to get app store info is doa but I found a [script]([url](https://github.com/mas-cli/mas/issues/724#issuecomment-2778539607)) that may replace this dependacey.

```bash
#!/bin/bash
# Source: https://github.com/mas-cli/mas/issues/724#issuecomment-2778539607
/usr/bin/mdfind -onlyin /Applications 'kMDItemAppStoreHasReceipt=1' -0 \
  | /usr/bin/xargs -0 /usr/bin/mdls -attr kMDItemAppStoreAdamID -attr kMDItemDisplayName \
  | while read -r id_line; do
      id=${id_line#*= }
      read -r name_line
      name=${name_line#*= }
      echo "App Store $name, id: $id"
done | /usr/bin/sort
```
output: 
```
App Store "Accelerate.app", id: 1459809092
App Store "AdGuard for Safari.app", id: 1440147259
App Store "Any File Info.app", id: 731859284
App Store "Bonjourr Startpage.app", id: 1615431236
App Store "DaVinci Resolve.app", id: 571213070
App Store "Desk Clock.app", id: 1253066126
App Store "FlipClock.app", id: 1181028777
App Store "FormApp.app", id: 1544827472
App Store "Image2Icon.app", id: 992115977
App Store "Noir.app", id: 1592917505
App Store "Notify for Spotify.app", id: 1517312650
App Store "Numbers.app", id: 409203825
App Store "Pages.app", id: 409201541
App Store "Pixelmator Pro.app", id: 1289583905
App Store "Pure Paste.app", id: 1611378436
App Store "ScreenFlow 9.app", id: 1475796517
App Store "Swift Playground.app", id: 1496833156
App Store "Trello.app", id: 1278508951
App Store "Userscripts.app", id: 1463298887
App Store "Wake Up Time Pro.app", id: 516371849
App Store "Xcode.app", id: 497799835
```

___
Just copy and paste this into your terminal then press enter... go on, you can trust me😉


``` bash
# Define color and formatting codes
BOLD="\033[1m"
RED="\033[31m"
ORANGE="\033[38;5;208m"
RESET="\033[0m"

clear && printf "%s\n\n" "**************************************************************"
# Download the script
curl -s -o alist.zsh https://raw.githubusercontent.com/insasquatchcountry/alist/refs/heads/main/alist.zsh
if [ $? -ne 0 ]; then
    printf "${BOLD}${RED}ERROR: FAILED TO DOWNLOAD THE SCRIPT.${RESET}\n"
    return
fi

# Make the script executable
chmod u+x alist.zsh
if [ $? -ne 0 ]; then
    printf "${BOLD}${RED}ERROR: FAILED TO MAKE THE SCRIPT EXECUTABLE.${RESET}\n"
    return
fi

# Prompt for confirmation before running the script
printf "${BOLD}The script alist.zsh has been downloaded and is ready to run.${RESET}\n"
printf "\n"
printf "${ORANGE}            Do you wish to continue? (y/n): ${RESET}"
read confirmation
if [[ ! "$confirmation" =~ ^[Yy]$ ]]; then
    printf "\n"
    printf "Script execution canceled.\n"
    printf "\n"
    printf "%s\n" "**************************************************************"
    return
fi

printf "\n"
printf "%s\n" "**************************************************************"

# Run the script
./alist.zsh
if [ $? -ne 0 ]; then
    printf "${BOLD}${RED}ERROR: THE SCRIPT DID NOT EXECUTE SUCCESSFULLY.${RESET}\n"
    return
fi
```
___

## Script Breakdown
via GPT-4o mini

This script automates the process of downloading, preparing, and executing the `alist.zsh` script from a GitHub repository. It includes error handling and user prompts for a better user experience. Below is a detailed explanation of each section of the script.

### 1. Define Color and Formatting Codes

```bash
BOLD="\033[1m"
RED="\033[31m"
ORANGE="\033[38;5;208m"
RESET="\033[0m"
```

- **Purpose**: This section defines ANSI escape codes for text formatting.
  - `BOLD`: Makes text bold.
  - `RED`: Sets text color to red.
  - `ORANGE`: Sets text color to orange (using 256-color mode).
  - `RESET`: Resets text formatting to default.

### 2. Download the Script

```bash
curl -s -o alist.zsh https://raw.githubusercontent.com/insasquatchcountry/alist/refs/heads/main/alist.zsh
if [ $? -ne 0 ]; then
    printf "${BOLD}${RED}ERROR: FAILED TO DOWNLOAD THE SCRIPT.${RESET}\n"
    return
fi
```

- **Purpose**: This section downloads the `alist.zsh` script from the specified GitHub URL.
  - `curl -s -o alist.zsh`: Uses `curl` to silently download the file and save it as `alist.zsh`.
  - The `if` statement checks if the previous command was successful. If not, it prints an error message in bold red and returns from the script.

### 3. Make the Script Executable

```bash
chmod u+x alist.zsh
if [ $? -ne 0 ]; then
    printf "${BOLD}${RED}ERROR: FAILED TO MAKE THE SCRIPT EXECUTABLE.${RESET}\n"
    return
fi
```

- **Purpose**: This section changes the permissions of the downloaded script to make it executable.
  - `chmod u+x alist.zsh`: Adds execute permission for the user (owner) of the file.
  - The `if` statement checks if the command was successful. If not, it prints an error message in bold red and returns from the script.

### 4. Prompt for Confirmation Before Running the Script

```bash
printf "${BOLD}The script alist.zsh has been downloaded and is ready to run.${RESET}\n"
printf "${ORANGE}Do you want to continue? (y/n): ${RESET}"
read confirmation
if [[ ! "$confirmation" =~ ^[Yy]$ ]]; then
    printf "Script execution canceled.\n"
    return
fi
```

- **Purpose**: This section informs the user that the script is ready to run and prompts for confirmation.
  - The first `printf` statement displays a message in bold indicating that the script is ready.
  - The second `printf` statement prompts the user in orange to confirm whether they want to continue.
  - The `read` command captures the user's input.
  - The `if` statement checks if the input is not "y" or "Y". If the user chooses not to continue, it prints a cancellation message and returns from the script.

### 5. Run the Script

```bash
./alist.zsh
if [ $? -ne 0 ]; then
    printf "${BOLD}${RED}ERROR: THE SCRIPT DID NOT EXECUTE SUCCESSFULLY.${RESET}\n"
    return
fi
```

- **Purpose**: This section executes the downloaded script.
  - `./alist.zsh`: Runs the script.
  - The `if` statement checks if the execution was successful. If not, it prints an error message in bold red and returns from the script.

---

### Summary

This script provides a user-friendly way to download, prepare, and execute the `alist.zsh` script while incorporating error handling and user confirmation. The use of color formatting enhances the visibility of important messages, making it easier for users to understand the script's status and any issues that may arise.

# Sample Output
(see .pdf for clickable links etc.)

![Sample Output](alist_output.png)



