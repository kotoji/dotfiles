function vim
    command nvim $argv
end

function vi
    command vim $argv
end

function gwt
    set -l GIT_CDUP_DIR (git rev-parse --show-cdup)
    git worktree add {$GIT_CDUP_DIr}git-worktrees/{$argv[-1]} $argv
end

function git-bloblessify
    # https://qiita.com/irgaly/items/0aace5cbd44aa4220733
    git repack -ad --filter=blob:none -filter-to=pack --no-write-bitmap-index
    git config remote.origin.promisor true
    git config remote.origin.partialclonefilter blob:none
    echo 'exec `rm pack-*.idx pack-*.pack pack-*.rev` yourself'
end
