Install fish shell:
  pkg.installed:
    - name: fish 

Download oh-my-fish:
  git.latest:
    - name: https://github.com/oh-my-fish/oh-my-fish
    - target: {{ pillar['home'] }}/.config/respawn/files/omf
    - user: {{ pillar['user'] }}
    - onchanges:
      - pkg: Install fish shell

Install oh-my-fish:
  cmd.script:
    - name: {{ pillar['home'] }}/.config/respawn/files/omf/bin/install
    - args: --offline
    - runas: {{ pillar['user'] }}
    - creates: {{ pillar['home'] }}/.local/share/omf
    - onchanges:
      - git: Download oh-my-fish

Install budspencer theme:
  cmd.run:
    - runas: {{ pillar['user'] }}
    - shell: {{ pillar['fish'] }}
    - name: omf install budspencer
    - onchanges:
      - cmd: Install oh-my-fish

Change to fish shell:
  cmd.run:
    - runas: {{ pillar['user'] }}
    - shell: {{ pillar['bash'] }}
    - name: sudo chsh -s `which fish` {{ pillar['user'] }} 
    - onchanges:
      - cmd: Install budspencer theme
