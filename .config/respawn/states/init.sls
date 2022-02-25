include:
  - .fish
  - .oh_my_fish
  - .vundle
  {% if grains['os'] == 'MacOS' %}
  - .defaults
  - .dock
  {% elif grains['os_family'] == 'RedHat' %}
  - .yum
  {% endif %}
