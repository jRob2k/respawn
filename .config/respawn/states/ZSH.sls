Install ZSH:
  pkg.installed:
    - name: zsh

Install Starship:
  cmd.script:
    - source: https://starship.rs/install.sh
    - name: install.sh -y
    - creates: /usr/local/bin/starship
