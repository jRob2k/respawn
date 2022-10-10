Install Nano:
  
Create cheat dir:
  file.directory:
    - name: /opt/cheat
    - user: root
    - dir_mode: 755
    - file_mode: 755
    - recurse:
      - user
      - mode

Download cheat:
  cmd.run:
    {% if grains['os_family'] == 'Debian' and grains['osarch'] == 'amd64' %}
    - name: curl -fsSL "https://github.com/cheat/cheat/releases/latest/download/cheat-linux-amd64.gz" | gunzip > /opt/cheat/cheat
    {% elif grains['os_family'] == 'Debian' and grains['osarch'] == 'arm64' %}
    - name: curl -fsSL "https://github.com/cheat/cheat/releases/latest/download/cheat-linux-arm64.gz" | gunzip > /opt/cheat/cheat
    {% endif %}
    - creates: /opt/cheat/cheat

{% if not salt['file.directory_exists' ]('/opt/cheat/cheat') %}
Add to PATH:
  file.symlink:
    - name: /usr/local/bin/cheat
    - target: /opt/cheat/cheat
{% endif %}
