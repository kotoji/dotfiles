## dotfiles

## 使い方
以下のコマンドでシンボリックリンクを作成する
(既に存在する場合は上書きしない)
```
$ ./install.sh
```

## メモ
### fish
環境変数設定はホストごとに`.config/fish/conf.d/template/env.fish.<hostname>`という名前で分けて管理する。  
インストール時に`.config/fish/conf.d/env.fish`へシンボリックリンクが張られる。  
(ホストごとの設定ファイルが存在しない場合は空のファイルを作成したあとでシンボリックリンクを張る。)

### git
`~/.config/git/config.user` を作成する必要がある。  
ユーザー設定はここに書く。

### SpaceVim


### IntelliJ IDEA
