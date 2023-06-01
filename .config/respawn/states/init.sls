include:
  - .cheat
  - .GH
  - .respawn
  - .ZSH
  - .vscode
  {% if grains['os'] == 'MacOS' %}
  - .defaults
  - .dock
  {% elif grains['os_family'] == 'Debian' %}
  - .Homebrew
  - .auth_stuff
  - .python3
  - .snap_store
  - .flatpak
  {% endif %}
