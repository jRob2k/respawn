Install flatpak:
  pkg.installed:
    - names:
      - flatpak
      - gnome-software-plugin-flatpak

Flatpak remote add:
  cmd.run:
    - name: flatpak remote-add --if-not-exists flathub https://flathub.flatpakrepo
    - require:
      - pkg: Install flatpak
