Download oh-my-fish:
  git.latest:
    - name: https://github.com/oh-my-fish/oh-my-fish
    - target: {{ pillar['home'] }}/.config/respawn/files/omf
    - user: {{ pillar['user'] }}

Install oh-my-fish:
  cmd.script:
    - name: {{ pillar['home'] }}/.config/respawn/files/omf/bin/install
    - args: --offline
    - runas: {{ pillar['user'] }}
    - creates: {{ pillar['home'] }}/.local/share/omf

Install agnoster theme:
  cmd.run:
    - runas: {{ pillar['user'] }}
    - shell: /usr/bin/fish
    - name: omf install agnoster
    - onchanges:
      - cmd: Install oh-my-fish
