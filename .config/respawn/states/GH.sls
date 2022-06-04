Install GH Repo:
  cmd.run:
    - unless: which gh
    - runas: {{ pillar['user'] }}
    - cwd: /
    - name: curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
    - unless: which gh

Install GH:
  pkg.installed:
    - name: gh 
    - onchanges:
      - cmd: Install GH Repo
