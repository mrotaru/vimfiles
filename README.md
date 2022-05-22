# vim & nvim config

- basic vim/nvim configuration

## install
- `git clone git@github.com:mrotaru/vimfiles.git ~/.vim`
- uses vim's built-in `package` loader
- to install plugins/packages: `source ~/.vim/install-plugins.bash`
- settings and packages that are relevant to both `vim` and `nvim` are in `vimrc`
- nvim-specific config and packages in `init.vim`
- to load nvim config: `mkdir -p ~/.config/nvim && ln -s ~/.vim/init.vim ~/.config/nvim/init.vim`
- very basic LSP integration - uses built-in API
