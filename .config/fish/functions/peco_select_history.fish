function peco_select_history
    if test (count $argv) = 0
        set peco_flags --layout=bottom-up
    else
        set peco_flags --layout=bottom-up --query "$argv"
    end

    history merge

    # NOTE: 複数行コマンドに対する対応
    #  fish はデフォルトでは改行文字を区切り文字として扱うため、
    #  複数行コマンドの各行を分けて解釈してしまう。
    #  そのため以下の手順で対応している。
    #
    #  1. 履歴を NUL 文字区切りで返す
    #  2. 複数行コマンドの改行文字をエスケープして一行にまとめる
    #  3. NUL 文字で区切った履歴をもとに戻す
    #  4. pecoる
    #  5. 結果を代入
    history -z | string join '⏎ ' | string split0 | peco $peco_flags | read foo

    if [ $foo ]
        # エスケープした改行をもとに戻してコマンドラインへ渡す
        commandline (string split '⏎' $foo)
    else
        commandline ''
    end
end
