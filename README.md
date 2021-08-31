# vim & nvim config

- basic vim configuration; vim 8 is assumed
- `git clone git@github.com:mrotaru/vimfiles.git ~/.vim`
- no plugin manager used by default - just built-in packages
- to install plugins/packages: `source ~/.vim/install-plugins.bash`

## nvim
- nvim 0.6+ is assumed
- almost all configuration is in the vimrc - the nvim init essentially sources the vim config
- `mkdir -p ~/.config/nvim && ln -s ~/.vim/init.vim ~/.config/nvim/init.vim`
