Install zim:
  cmd.script:
    - name: https://raw.githubusercontent.com/zimfw/install/master/install.zsh
    - shell: {{ pillar['zsh'] }}
    - runas: {{ pillar['user'] }}

Install starship:
  cmd.run:
    - name: curl -fsSL https://starship.rs/install.sh | bash
    - shell: /bin/sh
    - runas: {{ pillar['user'] }}
    - onchanges:
      - cmd: Install zim
