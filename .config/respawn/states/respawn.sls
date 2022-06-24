#Need to restart shell for this to take effect. This state will run when it doesn't find the respawn alias
Set respawn permissions:
  file.managed:
    - name: {{ pillar['respawn'] }} 
    - mode: 755
    - replace: False

Set respawn alias in zsh:
  cmd.run:
    - name: echo "alias respawn='{{ pillar['zsh'] }} {{ pillar['respawn'] }}'" >> {{ pillar['home'] }}/.zshrc
    - unless: grep -R "alias respawn=" ~/.zshrc

Set respawn alias in bash:
  cmd.run:
    - name: echo "alias respawn='{{ pillar['bash'] }} {{ pillar['respawn'] }}'" >> {{ pillar['home'] }}/.bashrc
    - unless: grep -R "alias respawn=" ~/.bashrc

