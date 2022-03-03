include:
  - .spacevim
  - .fish
  - .oh_my_fish
  - .powerline_fonts
  - .pipenv
  {% if grains['os'] == 'MacOS' %}
  - .defaults
  - .dock
  {% elif grains['os_family'] == 'Debian' %}
  - .gnome_keyring
  {% endif %}
