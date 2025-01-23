#!/bin/zsh

# brew list --cask | tr '\n' ' ' | xargs brew home && brew leaves | tr '\n' ' ' | xargs brew home
# the above will open a the home page of all the apps installed via homebrew

# get all core formulae
brew info --json --eval-all| jq -r '.[].name' > all-formulae

# list all cli programs installed via homebrew
brew leaves > leaves 
cat leaves all-formulae | sort -f | uniq -d > core
cat leaves core | sort -f | uniq -u > tapped
# formulae version data
<core xargs -I % curl https://formulae.brew.sh/api/formula/%.json | jq -r .versions.stable > lout
paste -d " " core lout > vleaf
cat vleaf tapped | sort -f > vtleaf
sed 's/$/ (Homebrew)/' vtleaf > vtleaflab

# list all GUI programs installed via homebrew
brew list --casks >> casks

# list all GUI apps installed via App Store
mas list | sed 's/[[:space:]]\{1,\}[^[:space:]]\{1,\}$//' | sed 's/[^[:space:]]*[[:space:]]*//' | sort -f > store
<store sed 's/$/ (App Store)/' > storelab

# list all apps in  
ls -p /Applications | grep -e .app | sed 's/.app\///' |sort -f > folder

echo "\n**Homebrew Formulae**\n\n" > installed && cat vtleaf >> installed 
echo "\n\n**Homebrew Casks**\n\n" >> installed && cat casks >> installed
echo "\n\n**App Store**\n\n" >> installed && cat store >> installed
echo "\n\n**Applications Folder**\n\n" >> installed && cat folder >> installed


# formatting

<casks sed 's/-/ /g' | tr '[:upper:]' '[:lower:]' | sort -f > fcasks
<store sed 's/-/ /g' | tr '[:upper:]' '[:lower:]' | sort -f > fstore
<folder sed 's/-/ /g' | tr '[:upper:]' '[:lower:]' | sort -f > ffolder

# filtering
cat fstore ffolder | sort -f | uniq -u > ustore
cat ustore fcasks | sort -f | uniq -u > ucaskroom
cat ucaskroom fcasks | sort -f | uniq -d > doubles
cat doubles ucaskroom | sort -f | uniq -u > uloners
# source: https://stackoverflow.com/a/1541178
awk '{for(i=1;i<=NF;i++){ $i=toupper(substr($i,1,1)) substr($i,2) }}1' uloners > fuloners

# cask version data
<casks xargs -I % curl https://formulae.brew.sh/api/cask/%.json | jq -r .version > cout
paste -d " " casks cout > vcasks
sed 's/$/ (Cask)/' vcasks > caskslab

filename="_AppList"
timestamp=$(date -I)
extension=".txt"
new_filename="${timestamp}${filename}${extension}"
date > $new_filename
echo "" >> $new_filename
cat storelab vtleaflab caskslab fuloners | sort -f >> $new_filename
cat installed >> $new_filename

rm casks caskslab core cout doubles fcasks ffolder folder fstore fuloners installed leaves lout store storelab tapped ucaskroom uloners ustore vcasks vleaf vtleaf vtleaflab