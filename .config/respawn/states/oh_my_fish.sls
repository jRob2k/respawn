Install oh-my-fish:
  cmd.script:
    - name: https://raw.githubusercontent.com/oh-my-fish/oh-my-fish/master/bin/install
    - shell: /bin/fish
    - runas: {{ pillar['user'] }}
    - creates: {{ pillar['home'] }}/.oh-my-fish

Install agnoster theme:
  cmd.run:
    - name: fish && omf install agnoster
    - onchanges:
      - cmd: Install oh-my-fish

chsh to fish:
  cmd.run:
    - name: chsh -s $(which fish) {{ pillar['user'] }}
    - onchanges:
      - cmd: Install agnoster theme
