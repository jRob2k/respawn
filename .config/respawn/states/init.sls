include:
  - .spacevim
  - .fish
  - .powerline_fonts
  - .pipenv
  - .vscode
  {% if grains['os'] == 'MacOS' %}
  - .defaults
  - .dock
  {% elif grains['os_family'] == 'Debian' %}
  - .gnome_keyring
  - .python3
  {% endif %}
