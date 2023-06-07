Install Vim-Plug:
  cmd.run:
    - runas: {{ pillar['user'] }}
    - name: curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    - creates: ~/.vim/autoload/plug.vim
