#This takes about 5 minutes to run without any output, so don't kill it. 
{% if grains['os_family'] == 'Debian' %}
Install Homebrew:
  cmd.script:
    - source: https://raw.githubusercontent.com/Homebrew/install/master/install.sh
    - env: 
      - CI: 1
    - runas: {{ pillar['user'] }}
    - creates: /home/linuxbrew/.linuxbrew/bin/brew

Add Homebrew to Path:
  cmd.run:
    - runas: {{ pillar['user'] }}
    - names:
      - test -d ~/.linuxbrew && eval "$(~/.linuxbrew/bin/brew shellenv)"
      - test -d /home/linuxbrew/.linuxbrew && eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
      - test -r ~/.zshenv && echo "eval \"\$($(brew --prefix)/bin/brew shellenv)\"" >> ~/.zshenv
      - echo "eval \"\$($(brew --prefix)/bin/brew shellenv)\"" >> ~/.zshrc
    - unless: which brew
    - require:
      - cmd: Install Homebrew

{% endif %}

