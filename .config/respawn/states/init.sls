include:
  - .spacevim
  - .zim
  - .powerline_fonts
  - .pipenv
  - .vscode
  {% if grains['os'] == 'MacOS' %}
  - .defaults
  - .dock
  {% elif grains['os_family'] == 'Debian' %}
  - .auth_stuff
  - .python3
  {% endif %}
