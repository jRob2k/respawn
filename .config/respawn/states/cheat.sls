Create cheat dir:
  file.directory:
    - name: /opt/cheat

Download cheat:
  cmd.run:
    {% if grains['os_family'] == 'Debian' and grains['osarch'] == 'amd64' %}
    - name: curl -fsSL "https://github.com/cheat/cheat/releases/latest/download/cheat-linux-amd64.gz" | gunzip > /opt/cheat/cheat
    {% endif %}
    - creates: /opt/cheat/cheat

Add to PATH:
  file.symlink:
    - name: /usr/local/bin/cheat
    - target: /opt/cheat/cheat
