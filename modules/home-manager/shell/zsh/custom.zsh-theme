PROMPT_CHAR=$
if [[ $(id -u) -eq 0 ]]; then
    PROMPT_CHAR=#
fi

function git_prompt_email() {
    if ! __git_prompt_git rev-parse --git-dir &> /dev/null; then
        return 0
    fi

    echo -n " %{$fg[yellow]%}($(git_current_user_email))%{$reset_color%}"
}

function direnv_prompt_info() {
    if [ -z "${DIRENV_FILE}" ]; then
        return 0
    fi

    echo -n " %{$fg[magenta]%}(env)%{$reset_color%}"
}

PROMPT=$'%{$fg_bold[green]%}%n@%m %{$fg[blue]%}%D{[%T]} %{$reset_color%}%{$fg[white]%}[%~]%{$reset_color%}$(git_prompt_info)$(git_prompt_email)$(direnv_prompt_info)\
%{$fg[blue]%}->%{$fg_bold[blue]%} ${PROMPT_CHAR}%{$reset_color%} '

ZSH_THEME_GIT_PROMPT_PREFIX=" %{$fg[green]%}["
ZSH_THEME_GIT_PROMPT_SUFFIX="]%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY=" %{$fg[red]%}*%{$fg[green]%}"
ZSH_THEME_GIT_PROMPT_CLEAN=""
