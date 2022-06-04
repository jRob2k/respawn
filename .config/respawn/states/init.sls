include:
  - .respawn
  - .spacevim
  - .ZSH
  - .GH
  {% if grains['os'] == 'MacOS' %}
  - .defaults
  - .dock
  {% elif grains['os_family'] == 'Debian' %}
  - .Homebrew
  - .auth_stuff
  - .python3
  {% endif %}
