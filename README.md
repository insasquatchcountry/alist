# alist
My solution to list out all of the apps installed on macOS from the app store, homebrew, or otherwise



## SAMPLE OUTPUT

2025-01-23_AppList.txt

```
Thu Jan 23 05:47:33 PST 2025

Accelerate (App Store)
Alfred 5
alfred 5.5.1,2273 (Cask)
Amphetamine (App Store)
Any File Info (App Store)
appcleaner 3.6.8 (Cask)
ares 141 (Cask)
betterdisplay 3.3.2 (Cask)
calibre 7.24.0 (Cask)
cliclick 5.1 (Homebrew)
cmake 3.31.4 (Homebrew)
cmatrix 2.0 (Homebrew)
cool-retro-term 1.2.0 (Cask)
cowsay 3.8.4 (Homebrew)
curseforge 1.270.1-0 (Cask)
daisydisk 4.31 (Cask)
DaVinci Resolve (App Store)
ddrescue 1.29 (Homebrew)
discord 0.0.333 (Cask)
dockey 1.2 (Cask)
emacs 29.4 (Homebrew)
fcanas/tap/mirror-displays (Homebrew)
ffmpeg 7.1 (Homebrew)
Focuswriter
fzf 0.58.0 (Homebrew)
gimp 2.10.38,1 (Cask)
github 3.4.15-3fea2a10 (Cask)
Github Desktop
google-chrome 132.0.6834.111 (Cask)
Guitar Pro 8
guitar-pro 8.1.3-121 (Cask)
hammerspoon 1.0.0 (Cask)
handbrake 1.9.0 (Cask)
imagemagick 7.1.1-43 (Homebrew)
imageoptim 1.9.3 (Cask)
inkscape 1.4.028868 (Cask)
instaloader 4.14 (Homebrew)
ipython 8.31.0 (Homebrew)
iStat Menus (App Store)
Karabiner Eventviewer
karabiner-elements 15.3.0 (Cask)
loopback 2.4.5 (Cask)
Magnet (App Store)
Marktext
mas 1.9.0 (Homebrew)
mechvibes 2.3.6-hotfix,2.3.6 (Cask)
msdl 1.2.7-r2 (Homebrew)
neofetch 7.1.0 (Homebrew)
newsboat 2.38 (Homebrew)
node 23.6.1 (Homebrew)
Noir (App Store)
Notify for Spotify (App Store)
Numbers (App Store)
obsidian 1.7.7 (Cask)
Pages (App Store)
Pcsx2 V2.2.0
pv 1.9.27 (Homebrew)
qt 6.7.3 (Homebrew)
r 4.4.2 (Homebrew)
rust 1.84.0 (Homebrew)
Safari.app
shpotify 2.1 (Homebrew)
speedtest-cli 2.1.3 (Homebrew)
spotify 1.2.55.235 (Cask)
steam 4.0 (Cask)
sublime-text 4192 (Cask)
testdisk 7.2 (Homebrew)
tldr 1.6.1 (Homebrew)
tor-browser 14.0.4 (Cask)
transmission 4.0.6 (Cask)
tree 2.2.1 (Homebrew)
typespeed 0.6.5 (Homebrew)
utimer 0.4 (Homebrew)
vlc 3.0.21 (Cask)
wget 1.25.0 (Homebrew)
wkhtmltopdf 0.12.6-2 (Cask)
yt-dlp 2025.1.15 (Homebrew)
zint 2.13.0 (Homebrew)

**Homebrew Formulae**


cliclick 5.1
cmake 3.31.4
cmatrix 2.0
cowsay 3.8.4
ddrescue 1.29
emacs 29.4
fcanas/tap/mirror-displays
ffmpeg 7.1
fzf 0.58.0
imagemagick 7.1.1-43
instaloader 4.14
ipython 8.31.0
mas 1.9.0
msdl 1.2.7-r2
neofetch 7.1.0
newsboat 2.38
node 23.6.1
pv 1.9.27
qt 6.7.3
r 4.4.2
rust 1.84.0
shpotify 2.1
speedtest-cli 2.1.3
testdisk 7.2
tldr 1.6.1
tree 2.2.1
typespeed 0.6.5
utimer 0.4
wget 1.25.0
yt-dlp 2025.1.15
zint 2.13.0


**Homebrew Casks**


alfred
appcleaner
ares
betterdisplay
calibre
cool-retro-term
curseforge
daisydisk
discord
dockey
gimp
github
google-chrome
guitar-pro
hammerspoon
handbrake
imageoptim
inkscape
karabiner-elements
loopback
mechvibes
obsidian
spotify
steam
sublime-text
tor-browser
transmission
vlc
wkhtmltopdf


**App Store**


Accelerate
Amphetamine
Any File Info
DaVinci Resolve
iStat Menus
Magnet
Noir
Notify for Spotify
Numbers
Pages


**Applications Folder**


Accelerate
Alfred 5
Amphetamine
Any File Info
AppCleaner
ares
BetterDisplay
calibre
cool-retro-term
CurseForge
DaisyDisk
DaVinci Resolve
Discord
dockey
FocusWriter
GIMP
GitHub Desktop
Google Chrome
Guitar Pro 8
Hammerspoon
HandBrake
ImageOptim
Inkscape
iStat Menus
Karabiner-Elements
Karabiner-EventViewer
Loopback
Magnet
MarkText
Mechvibes
Noir
Notify for Spotify
Numbers
Obsidian
Pages
PCSX2-v2.2.0
Safari.app
Spotify
Steam
Sublime Text
Tor Browser
Transmission
VLC
```
## Other useful brew tool

brew desc <formula>

brew info <formula>

brew deps <formula>

brew uses --installed <formula>

### source: https://github.com/orgs/Homebrew/discussions/4033#discussioncomment-4362170
brew info --cask --json=v2 $(brew ls --cask) | jq -r '.casks[]|select(.auto_updates==true)|.token'

### source: https://superuser.com/a/1851597/1170970
brew list --leaves | fzf --cycle --tmux --preview 'brew info {}'  --info=inline-right --ellipsis=… --tabstop=4 --highlight-line
