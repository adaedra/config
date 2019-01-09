# Prompt
if [ "$TERM_PROGRAM" != 'vscode' ]; then
    function precmd() {
        git rev-parse --is-inside-work-tree >/dev/null 2>&1 || return

        _git_branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)
        [ -z "${_git_branch}" -o "${_git_branch}" = "HEAD" ] && _git_branch="(detached)"
        _git_project=$(basename $(git rev-parse --git-dir))
        [ "$_git_project" = ".git" ] && _git_project=$(basename $PWD)
        _git_changes=$(echo $(git status --porcelain -uno | wc -l))

        print
        print -n -P " %F{243}${_git_project} ›%f "
        if [ "${_git_branch[1]}" = '(' ]; then
            _git_commit=$(git rev-parse --short HEAD 2>/dev/null)

            if [ -n "${_git_commit}" ]; then
                print -n -P "%F{red} ${_git_commit} (detached)%f"
            else
                print -n -P "%F{red}(empty)%f"
            fi
        elif [ "$_git_changes" -ne 0 ]; then
            print -n -P "%F{yellow} ${_git_branch} ◆ ${_git_changes}%f"
        else
            print -n -P "%F{green} ${_git_branch}%f"
        fi
        print
    }
fi

PROMPT=" %(?.%F{green}.%F{red})›%f "

if which exa 2>&1 >/dev/null; then
    alias ls='exa --group-directories-first'
else
    alias ls='ls -FGh'
fi
alias ll='ls -l'

# nvm
if [ -f ~/.nvm/nvm.sh ]; then
    export NVM_DIR="$HOME/.nvm"
    source ~/.nvm/nvm.sh
fi

# rbenv
which rbenv >/dev/null 2>&1 && eval "$(rbenv init -)"

# rustup
if [ -d ~/.cargo ]; then
    path+=(~/.cargo/bin)
fi
