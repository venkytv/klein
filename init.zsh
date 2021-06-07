setopt nopromptbang prompt{cr,percent,sp,subst}

zstyle ':zim:duration-info' format ' %F{242}(%d)%f'

autoload -Uz add-zsh-hook
add-zsh-hook preexec duration-info-preexec
add-zsh-hook precmd duration-info-precmd

# Git info
_GIT_COLOR=209
_GIT_FORMAT_COLOR=226
_GIT_ALERT_COLOR=196
zstyle ':zim:git-info:branch' format '%b'
zstyle ':zim:git-info:commit' format '%c'
zstyle ':zim:git-info:remote' format '%R'
zstyle ':zim:git-info:behind' format '%F{${_GIT_FORMAT_COLOR}}⇣%f'
zstyle ':zim:git-info:ahead' format '%F{${_GIT_FORMAT_COLOR}}⇡%f'
zstyle ':zim:git-info:diverged' format '%F{${_GIT_ALERT_COLOR}}⇵%f'
zstyle ':zim:git-info:dirty' format '%F{${_GIT_FORMAT_COLOR}}*%f'
zstyle ':zim:git-info:keys' format \
    'prompt'  '%F{${_GIT_COLOR}}<git:%f%b%c%A%B%V%D%F{${_GIT_COLOR}}>%f ' \
    'rprompt' '%F{${_GIT_COLOR}}<%R>%f '

add-zsh-hook precmd git-info

_VENV_COLOR=119
venv-preexec() {
	[[ -n "$VIRTUAL_ENV" ]] \
		&& __venv_prompt="%F{${_VENV_COLOR}}<venv:%f${VIRTUAL_ENV:t}%F{${_VENV_COLOR}}>%f " \
		|| __venv_prompt=
}
add-zsh-hook precmd venv-preexec

_MEXENV_COLOR=227
mexenv-preexec() {
	[[ -n "$__MEXENV__" ]] \
		&& __mexenv_prompt="mexenv:%F{${_MEXENV_COLOR}}${__MEXENV__}%f" \
		|| __mexenv_prompt=
}
add-zsh-hook precmd mexenv-preexec

_CLOUDLET_COLOR=blue
cloudlet-preexec() {
	[[ -n "$__CLOUDLET__" ]] \
		&& __cloudlet_prompt="%F{${_CLOUDLET_COLOR}}<cloudlet:%f${__CLOUDLET__}%F{${_CLOUDLET_COLOR}}>%f " \
		|| __cloudlet_prompt=
}
add-zsh-hook precmd cloudlet-preexec

_PROMPT_COLOR=227
_PWD_COLOR=223
_TIME_COLOR=229
_BG_COLOR=136
_ERR_COLOR=160
PS1='
%B%F{${_PWD_COLOR}}%~%f%(?.. %F{${_ERR_COLOR}}<rc:%f%?%F{${_ERR_COLOR}}>%f)%(1j. %F{${_BG_COLOR}}<bg:%f%j%F{${_BG_COLOR}}>%f.) ${(e)git_info[prompt]}${__venv_prompt}${__cloudlet_prompt}${duration_info}
${__mexenv_prompt}%(?.%F{${_PROMPT_COLOR}›%f.%F{${_ERR_COLOR}»%f)%b '
RPROMPT='%B${(e)git_info[rprompt]}%F{${_TIME_COLOR}}[%w %*]%f%b'
