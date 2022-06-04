{% if grains['os_family'] == "Debian" %}
Install GH Repo:
  cmd.run:
    - unless: which gh
    - runas: {{ pillar['user'] }}
    - cwd: /
    - name: curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
    - name: echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
    - creates: /usr/share/keyrings/githubcli-archive-keyring.gpg
{% endif %}

Install GH:
  pkg.installed:
    - name: gh 
