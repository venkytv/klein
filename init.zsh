setopt nopromptbang prompt{cr,percent,sp,subst}

zstyle ':zim:duration-info' format ' %F{242}(%d)%f'

autoload -Uz add-zsh-hook
add-zsh-hook preexec duration-info-preexec
add-zsh-hook precmd duration-info-precmd

# Colours
: ${KLEIN_GIT_COLOR:=209}
: ${KLEIN_GIT_FORMAT_COLOR:=226}
: ${KLEIN_GIT_ALERT_COLOR:=196}
: ${KLEIN_GIT_DOWN_COLOR:=118}
: ${KLEIN_GIT_UP_COLOR:=196}
: ${KLEIN_VENV_COLOR:=119}
: ${KLEIN_MEXENV_COLOR:=227}
: ${KLEIN_CLOUDLET_COLOR:=blue}
: ${KLEIN_PROMPT_COLOR:=227}
: ${KLEIN_PWD_COLOR:=223}
: ${KLEIN_TIME_COLOR:=229}
: ${KLEIN_BG_COLOR:=136}
: ${KLEIN_ERR_COLOR:=160}

# Git info
zstyle ':zim:git-info:branch' format '%b'
zstyle ':zim:git-info:commit' format '%c'
zstyle ':zim:git-info:remote' format '%R'
zstyle ':zim:git-info:behind' format '%F{${KLEIN_GIT_DOWN_COLOR}}⇣⇣%f'
zstyle ':zim:git-info:ahead' format '%F{${KLEIN_GIT_UP_COLOR}}⇡⇡%f'
zstyle ':zim:git-info:diverged' format '%F{${KLEIN_GIT_UP_COLOR}}⇡%F{KLEIN_GIT_DOWN_COLOR}⇣%f'
zstyle ':zim:git-info:dirty' format '%F{${KLEIN_GIT_FORMAT_COLOR}}**%f'
zstyle ':zim:git-info:keys' format \
    'prompt'  '%F{${KLEIN_GIT_COLOR}}<git:%f%b%c%A%B%V%D%F{${KLEIN_GIT_COLOR}}>%f ' \
    'rprompt' '%F{${KLEIN_GIT_COLOR}}<%R>%f '

add-zsh-hook precmd git-info

venv-preexec() {
	[[ -n "$VIRTUAL_ENV" ]] \
		&& __venv_prompt="%F{${KLEIN_VENV_COLOR}}<venv:%f${VIRTUAL_ENV:t}%F{${KLEIN_VENV_COLOR}}>%f " \
		|| __venv_prompt=
}
add-zsh-hook precmd venv-preexec

mexenv-preexec() {
	[[ -n "$__MEXENV__" ]] \
		&& __mexenv_prompt="mexenv:%F{${KLEIN_MEXENV_COLOR}}${__MEXENV__}-${__REGION__}%f" \
		|| __mexenv_prompt=
}
add-zsh-hook precmd mexenv-preexec

cloudlet-preexec() {
	[[ -n "$__CLOUDLET__" ]] \
		&& __cloudlet_prompt="%F{${KLEIN_CLOUDLET_COLOR}}<cloudlet:%f${__CLOUDLET__}%F{${KLEIN_CLOUDLET_COLOR}}>%f " \
		|| __cloudlet_prompt=
}
add-zsh-hook precmd cloudlet-preexec

kubectx-preexec() {
	local color="$KLEIN_MEXENV_COLOR"
	local kubectx=$( __current_kubectx )
	[[ -n "$__MEXENV__" && "$kubectx" != "${__MEXENV__}-${__REGION__}" ]] && color="$KLEIN_ERR_COLOR"
	__kubectx_prompt="%F{${color}}<kube:%f${kubectx}%F{${color}}>%f "
}
add-zsh-hook precmd kubectx-preexec

PS1='
%B%F{${KLEIN_PWD_COLOR}}%~%f%(?.. %F{${KLEIN_ERR_COLOR}}<rc:%f%?%F{${KLEIN_ERR_COLOR}}>%f)%(1j. %F{${KLEIN_BG_COLOR}}<bg:%f%j%F{${KLEIN_BG_COLOR}}>%f.) ${(e)git_info[prompt]}${__kubectx_prompt}${__venv_prompt}${__cloudlet_prompt}${duration_info}
${__mexenv_prompt}%(?.%F{${KLEIN_PROMPT_COLOR}›%f.%F{${KLEIN_ERR_COLOR}»%f)%b '
RPROMPT='%B${(e)git_info[rprompt]}%F{${KLEIN_TIME_COLOR}}[%w %*]%f%b'
