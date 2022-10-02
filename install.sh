#!/usr/bin/env bash
set -e
cd $(mktemp -d)


###
# DNF update e limpa arquivos temporários
###
dnf update -y
dnf upgrade -y
dnf clean all

###
# Repositório RpmFusion Free
###
sudo dnf install -y https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm 

###
# RpmFusion NonFree Repo
# Também inclui drivers Nvidia
###
if [ ! -z "$NONFREE" ]; then
	sudo dnf install -y https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
fi

###
# Instalação do Chrome
###
dnf install fedora-workstation-repositories
dnf config-manager --set-enabled google-chrome
dnf install google-chrome-stable -y

###
# install repo COPR
###
COPR=( jstaf/onedriver )
for repository in ${COPR[@]}; do
  dnf copr enable "repository" -y
done
dnf update -y

###
# DNF install
###
package_dnf=( steam onedriver bottles gnome-tweaks gparted lutris solaar)
sudo dnf install ${package_dnf[@]} -y

###
# Flatpak
###
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo -y
flatpak_package=( com.belmoussaoui.Authenticator com.calibre_ebook.calibre com.github.bajoja.indicator-kdeconnect com.github.tchx84.Flatseal com.mattjakeman.ExtensionManager com.spotify.Client com.visualstudio.code de.haeckerfelix.Shortwave io.github.peazip.PeaZip io.github.peazip.PeaZip.Addon md.obsidian.Obsidian org.onlyoffice.desktopeditors org.qbittorrent.qBittorrent org.telegram.desktop org.telegram.desktop.webview org.videolan.VLC re.sonny.Junction net.ankiweb.Anki com.usebottles.bottles io.github.seadve.Mousai)
flatpak install ${flatpak_package[@]} -y

###
# Snap
###
dnf install snapd -y
package_snap=( opera )
snap install ${package_snap[@]}

### --- to do

# Disable the Nouveau Driver
# echo "options nouveau modeset=0" >> /usr/lib/modprobe.d/blacklist-nouveau.conf
# sudo dracut --force 

# Downloads
# downloads=( )
# wget -nv -c ${downloads[@]}

### Incluir drivers 
# Nvidia (placa hibrida)
# Dropbox
# extensions (script)
