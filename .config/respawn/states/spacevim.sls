Install SpaceVim:
  cmd.run:
    - runas: {{ pillar['user'] }}
    - name: touch ~/.config/respawn/files/spacevim.installed && curl -sLf https://spacevim.org/install.sh | bash
    - creates: ~/.config/respawn/files/spacevim.installed
