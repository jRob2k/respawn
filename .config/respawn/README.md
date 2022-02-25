```
@@@@@@@    @@@@@@   @@@@@@@  @@@@@@@@  @@@  @@@       @@@@@@@@   @@@@@@   
@@@@@@@@  @@@@@@@@  @@@@@@@  @@@@@@@@  @@@  @@@       @@@@@@@@  @@@@@@@   
@@!  @@@  @@!  @@@    @@!    @@!       @@!  @@!       @@!       !@@       
!@!  @!@  !@!  @!@    !@!    !@!       !@!  !@!       !@!       !@!       
@!@  !@!  @!@  !@!    @!!    @!!!:!    !!@  @!!       @!!!:!    !!@@!!    
!@!  !!!  !@!  !!!    !!!    !!!!!:    !!!  !!!       !!!!!:     !!@!!!   
!!:  !!!  !!:  !!!    !!:    !!:       !!:  !!:       !!:            !:!  
:!:  !:!  :!:  !:!    :!:    :!:       :!:   :!:      :!:           !:!   
 :::: ::  ::::: ::     ::     ::        ::   :: ::::   :: ::::  :::: ::   
:: :  :    : :  :      :      :        :    : :: : :  : :: ::   :: : :    
```                                                                          
# Sup

First and foremost, this has been forked from Shea Craig's dotfiles project in git.

This repo is predominantly for practicing with SALT, but also to simplify setting up my dev environments on the various machines I work from. 

My intent is to configure this repo to work on the following platforms...
- macOS
- Debian 11
 - Within a Crostini container on a Chromebook and all of the restrictions that apply
  -  no modification of kernel headers
  -  potentially no KVM access
-  Ubuntu 20

# Getting Started

## Pseudo Bootstrap
- To install salt and gh client download and run this script with the "bootstrap option"
 - `curl -o /tmp/respawn.sh -L https://raw.githubusercontent.com/jRob2k/jrob_configs/master/respawn.sh && sudo sh /tmp/respawn.sh bootstrap`
- Sign into gh (probably optional if you don't plan on pushing any changes)
 - `gh auth login`
- clone this repo. I like to clone it to .config
 - `gh repo clone jRob2k/jrob_configs ~/.config/jrob_configs`

