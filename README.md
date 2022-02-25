```
      ___           ___           ___           ___           ___           ___           ___     
     /\  \         /\  \         /\  \         /\  \         /\  \         /\__\         /\__\    
    /::\  \       /::\  \       /::\  \       /::\  \       /::\  \       /:/ _/_       /::|  |   
   /:/\:\  \     /:/\:\  \     /:/\ \  \     /:/\:\  \     /:/\:\  \     /:/ /\__\     /:|:|  |   
  /::\~\:\  \   /::\~\:\  \   _\:\~\ \  \   /::\~\:\  \   /::\~\:\  \   /:/ /:/ _/_   /:/|:|  |__ 
 /:/\:\ \:\__\ /:/\:\ \:\__\ /\ \:\ \ \__\ /:/\:\ \:\__\ /:/\:\ \:\__\ /:/_/:/ /\__\ /:/ |:| /\__\
 \/_|::\/:/  / \:\~\:\ \/__/ \:\ \:\ \/__/ \/__\:\/:/  / \/__\:\/:/  / \:\/:/ /:/  / \/__|:|/:/  /
    |:|::/  /   \:\ \:\__\    \:\ \:\__\        \::/  /       \::/  /   \::/_/:/  /      |:/:/  / 
    |:|\/__/     \:\ \/__/     \:\/:/  /         \/__/        /:/  /     \:\/:/  /       |::/  /  
    |:|  |        \:\__\        \::/  /                      /:/  /       \::/  /        /:/  /   
     \|__|         \/__/         \/__/                       \/__/         \/__/         \/__/    
~~~~~~~~~~~~~~~These are my config files. There are many like them, but these are mine~~~~~~~~~~~
```
# Overview
This repo is how I manage my config files and basic packages on the *nix systems I use. You're welcome future me!

# Bootstrap
This script will install some packages and config files and setcha up to run `respawn`.
```
cd ~/ && curl -o /tmp/bootstrap-respawn.sh -L "https://raw.githubusercontent.com/jRob2k/respawn/main/.config/respawn/bootstrap.sh" && bash /tmp/bootstrap-respawn.sh
```
# Using Respawn
Respawn is just git and salt. After installing with the bootstrap script, the following commands will work. 

Force git to overwrite respawn installation
`respawn -f`

# Credits
Inspiration drawn from...
- https://github.com/sheagcraig/dotfiles
- https://git.sr.ht/~sircmpwn/dotfiles
    - https://drewdevault.com/2019/12/30/dotfiles.html
