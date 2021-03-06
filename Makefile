# Functions
install_ = stow -t $(HOME) -R $1
link_ = for f in $1; do ln -sf $$(realpath $$f) $(2)/.$$(basename $$f); done

install: yay wget emacs asdf fonts-install submodules stow fasd zsh tpm zsh-syntax-highlighting enpass arc-theme arch-update ag docker docker-compose apps app-indicator steam
	$(call install_,git)
	$(call install_,irb)
	$(call install_,ruby)
	$(call install_,ctags)
	$(call install_,tmux)
	$(call install_,vimify)
	$(call install_,zsh)
	$(call install_,prezto)
	$(call install_,bin)
	$(call install_,emacs)
	$(call link_,./prezto/.zprezto/runcoms/z*,$(HOME))
	echo 'for config_file ($(HOME)/.zsh/*.zsh) source $$config_file' >> ~/.zshrc
	mkdir -p $(HOME)/.zsh.before
	mkdir -p $(HOME)/.zsh.after
	mkdir -p $(HOME)/.zsh.prompts
	chsh -s /usr/bin/zsh
	make fonts-install

wget:
	sudo pacman -S --needed --noconfirm wget

fonts-install: fira-code
	mkdir -p $(HOME)/.fonts
	cp ./fonts/* $(HOME)/.fonts
	fc-cache -vf $(HOME)/.fonts

submodules:
	git submodule update --init --recursive
	git submodule update --recursive

/usr/bin/stow:
	sudo pacman -S --needed stow

stow: /usr/bin/stow

/usr/bin/fasd:
	yay -S -a --norebuild --noconfirm fasd

fasd: /usr/bin/fasd

/usr/bin/zsh:
	sudo pacman -S --needed zsh

zsh: /usr/bin/zsh

~/.asdf:
	git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.4.0

~/.zsh.after/asdf.zsh:
	mkdir ~/.zsh.after
	touch ~/.zsh.after/asdf.zsh
	echo -e '\n. $(HOME)/.asdf/asdf.sh' >> ~/.zsh.after/asdf.zsh
	echo -e '\n. $(HOME)/.asdf/completions/asdf.bash' >> ~/.zsh.after/asdf.zsh

asdf-clojure: ~/.asdf/plugins/clojure/bin/install

~/.asdf/plugins/clojure/bin/install:
	asdf plugin-add clojure https://github.com/vic/asdf-clojure.git

asdf-elixir: ~/.asdf/plugins/elixir/bin/install

~/.asdf/plugins/elixir/bin/install:
	asdf plugin-add elixir https://github.com/asdf-vm/asdf-elixir.git

asdf-erlang: ~/.asdf/plugins/erlang/bin/install

~/.asdf/plugins/erlang/bin/install:
	asdf plugin-add erlang https://github.com/asdf-vm/asdf-erlang.git

asdf-golang: ~/.asdf/plugins/golang/bin/install

~/.asdf/plugins/golang/bin/install:
	asdf plugin-add golang https://github.com/kennyp/asdf-golang.git

asdf-ruby: ~/.asdf/plugins/ruby/bin/install

~/.asdf/plugins/ruby/bin/install:
	asdf plugin-add ruby https://github.com/asdf-vm/asdf-ruby.git

asdf-rust: ~/.asdf/plugins/rust/bin/install

~/.asdf/plugins/rust/bin/install:
	asdf plugin-add rust https://github.com/code-lever/asdf-rust.git

asdf-nodejs: ~/.asdf/plugins/nodejs/bin/install

~/.asdf/plugins/nodejs/bin/install:
	asdf plugin-add nodejs https://github.com/asdf-vm/asdf-nodejs.git

asdf: ~/.asdf ~/.zsh.after/asdf.zsh asdf-languages

tpm: ~/.tmux/plugins/tpm

~/.tmux/plugins/tpm:
	git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

asdf-languages:
	. $(HOME)/.asdf/asdf.sh
	make asdf-clojure
	make asdf-elixir
	make asdf-erlang
	make asdf-golang
	make asdf-ruby
	make asdf-rust
	make asdf-nodejs

emacs: ~/.emacs.d

~/.emacs.d:
	git clone https://github.com/syl20bnr/spacemacs ~/.emacs.d

/usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh:
	yay -S -a --norebuild --noconfirm zsh-syntax-highlighting-git

zsh-syntax-highlighting: /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

enpass:
	yay -S -a --norebuild --noconfirm enpass-bin

arc-theme:
	yay -S -a --norebuild --noconfirm arc-gtk-theme

arch-update:
	yay -S -a --norebuild --noconfirm gnome-shell-extension-arch-update

fira-code:
	sudo pacman -S --needed otf-fira-code

ag:
	sudo pacman -S --needed --noconfirm the_silver_searcher

docker: /etc/docker/daemon.json
	sudo pacman -S --needed --noconfirm docker
	sudo systemctl enable docker
	sudo systemctl start docker
	sudo gpasswd -a duke docker

/etc/docker/daemon.json:
	echo '{ "storage-driver": "overlay2" }' | sudo tee -a /etc/docker/daemon.json

docker-compose: /usr/local/bin/docker-compose

/usr/local/bin/docker-compose:
	sudo curl -L "https://github.com/docker/compose/releases/download/1.24.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose && chmod +x /usr/local/bin/docker-compose

apps:
	sudo pacman -S --needed --noconfirm firefox-developer-edition
	sudo pacman -S --needed --noconfirm telegram-desktop
	sudo pacman -S --needed --noconfirm flatpak && flatpak install flathub com.slack.Slack
	sudo pacman -S --needed --noconfirm htop
	sudo pacman -S --needed --noconfirm ansible
	yay -S -a --norebuild --noconfirm --needed spotify
	yay -S -a --norebuild --noconfirm --needed gcsf-git
	yay -S -a --norebuild --nocorfirm --needed slack
	gcsf login $(USER)
	mkdir -p ~/drive
	sudo sed -i 's/#user_allow_other/user_allow_other/g' /etc/fuse.conf
	gcsf mount ~/drive -s $(USER)

app-indicator:
	mkdir -p ~/.local/share/gnome-shell/extensions && git clone git@github.com:ubuntu/gnome-shell-extension-appindicator.git ~/.local/share/gnome-shell/extensions/appindicatorsupport@rgcjonas.gmail.com && gnome-shell-extension-tool -e appindicatorsupport@rgcjonas.gmail.com

steam:
	flatpak --user remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo && flatpak --user install flathub com.valvesoftware.Steam && flatpak override com.valvesoftware.Steam --filesystem=$(HOME)

yay: /usr/bin/yay

/usr/bin/yay:
  git clone https://aur.archlinux.org/yay.git /tmp/yay && cd /tmp/yay && makepkg -si
