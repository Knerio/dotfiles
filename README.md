# To restore on a new machine

```
git clone --bare https://github.com/knerio/dotfiles $HOME/.dotfiles
alias dotfiles='git --git-dir=$HOME/.dotfiles --work-tree=$HOME'
dotfiles checkout
```
