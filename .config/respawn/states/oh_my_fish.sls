Install oh-my-fish:
  cmd.script:
    - source: https://raw.githubusercontent.com/oh-my-fish/oh-my-fish/master/bin/install
    - args: --offline
    - runas: {{ pillar['user'] }}
    - creates: {{ pillar['home'] }}/.config/omf

Install agnoster theme:
  cmd.run:
    - runas: {{ pillar['user'] }}
    - shell: /usr/bin/fish
    - name: omf install agnoster
    - onchanges:
      - cmd: Install oh-my-fish
