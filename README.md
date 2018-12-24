# tsk
a simple task manager in haskell

```zsh
# print task items
tsk
# add item
tsk add "todo: blah blah"
# remove item
tsk done item
# reset task list
tsk reset
```

for vim bindnings, add
```vim
nnoremap <M-h> :!tsk<CR>
nnoremap <M-a> :!tsk add ""<Left>
nnoremap <M-d> :!tsk done<space>
```
to yout vimrc
