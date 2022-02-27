Download oh-my-fish:
  git.cloned:
    - target: https://github.com/oh-my-fish/oh-my-fish
    - creates: {{ pillar['home'] }}/.config/.oh-my-fish

Install oh-my-fish:
  cmd.run:
    - name: cd oh-my-fish && bin/install --offline
    - onchanges:
      - cmd: Download oh-my-fish

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
