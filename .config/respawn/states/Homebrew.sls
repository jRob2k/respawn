Install Homebrew:
  cmd.script:
    - source: https://raw.githubusercontent.com/Homebrew/install/master/install.sh
    - env: 
      - CI: 1
    - creates: /home/linuxbrew/.linuxbrew/bin/brew
   
