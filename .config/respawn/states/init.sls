include:
  - .fish
  - .oh_my_fish
  {% if grains['os'] == 'MacOS' %}
  - .defaults
  - .dock
  {% elif grains['os_family'] == 'RedHat' %}
  - .yum
  {% endif %}
