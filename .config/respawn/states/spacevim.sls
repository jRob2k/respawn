Install SpaceVim:
  cmd.run:
    - runas: {{ pillar['user'] }}
    - name: curl -sLf https://spacevim.org/install.sh | bash

