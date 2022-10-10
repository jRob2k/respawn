#This takes about 5 minutes to run without any output, so don't kill it. 
{% if grains['os_family'] == 'Debian' %}
# Need a different install method for Linuxbrew on arm. 
# Right now this is failing because even homebrew apparently requires a specific version of ruby, and at this point it's a rabbit hole.
#{% if grains['osarch'] == 'arm64' %}
#Install Ruby:
#  pkg.installed:
#    - name: ruby
#
#Install arm Homebrew:
#  cmd.run:
#    - names:
#      - git clone https://github.com/Homebrew/brew /home/linuxbrew/.linuxbrew/Homebrew
#    - creates: /home/linuxbrew/.linuxbrew/Homebrew
#  require:
#    - file: Create install dir
#
#Add Linuxbrew to Path:
#  cmd.run:
#    - names:
#      - eval "$(/home/linuxbrew/.linuxbrew/Homebrew/bin/brew shellenv)"
#      - brew update --force --quiet
#      - chmod -R go-w "$(brew --prefix)/share/zsh"
#    - require:
#      - cmd: Install arm Homebrew
#{% else %}
# Recommended install method for all other linux archs
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

#{% endif %}   
