VIMFILES="$HOME/vimfiles"
REPO="mrotaru/vimfiles"
VIMRC=".vimrc"

command -v git >/dev/null 2>&1 || { echo >&2 "git not found in path, exiting."; exit 1; }

if [ -d "$VIMFILES" ]; then
    echo "$VIMFILES already exists, trying to git pull...";
    cd "$VIMFILES" && git pull || exit 1;
else
    echo "Cloning $REPO..."
    git clone "git@github.com:$REPO" "$VIMFILES" >/dev/null 2>&1  || {
      echo "Could not clone via SSH, trying HTTPS..."
      git clone https://github.com/$REPO >/dev/null 2>&1 || { echo "Failed to clone, exiting."; exit 1; }
    }
fi

_SRC="$VIMFILES/$VIMRC"
_DST="$HOME/$VIMRC"
if [ -f "$_DST" -o -h "$_DST" ]; then
    echo "file already exists: $_DST"
else
    ln -s "$_SRC" "$HOME/$_DST"
fi

if [ -d "$VIMFILES/bundle/vundle" ]; then
    cd "$VIMFILES/bundle/vundle" && git pull || exit 1;
else
    git clone https://github.com/VundleVim/Vundle.vim.git $VIMFILES/bundle/vundle
fi

vim +PluginInstall +qall
