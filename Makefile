DOTFILE_PATH := $(shell pwd)

$(HOME)/.%: %
	// I would like to be prompted for my email address here and replace <email> on the .gitconfig file
	@read -p "Enter your email address: " email
	@sed -i "s/<email>/$${email}/g" $(DOTFILE_PATH)/$^
	ln -sf $(DOTFILE_PATH)/$^ $@

git: $(HOME)/.gitconfig $(HOME)/.gitignore
zsh: $(HOME)/.zshrc

$(HOME)/.config/ghostty/config:
	mkdir -p $(HOME)/.config/ghostty
	ln -sf $(DOTFILE_PATH)/ghostty.config $(HOME)/.config/ghostty/config

ghostty: $(HOME)/.config/ghostty/config

$(HOME)/.config/zed/settings.json:
	mkdir -p $(HOME)/.config/zed
	ln -sf $(DOTFILE_PATH)/zed_settings.jsonc $(HOME)/.config/zed/settings.json

zed: $(HOME)/.config/zed/settings.json

all: git zsh kitty ghostty zed
