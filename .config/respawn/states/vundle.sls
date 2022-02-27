Install vundle:
  git.cloned:
    - name: https://github.com/VundleVim/Vundle.vim.git
    - user: {{ pillar['user'] }}
    - target: /home/yasuke/.vim/bundle/Vundle.vim
 
Install vundle plugins:
  cmd.run:
    - name: vim -c 'PluginInstall' -c 'qa!'
    - onchanges:
      - git: Install vundle