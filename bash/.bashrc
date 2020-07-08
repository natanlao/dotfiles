alias g=git

__bash_prompt() {
	local RETVAL=$?
    local BRANCH=$(git rev-parse --abbrev-ref HEAD 2> /dev/null || echo -n "")
    PS1=""

    # user and host if remote
    if [ ! -z ${SSH_CLIENT+x} ] || [ ! -z ${SSH_TTY+x} ]; then
        PS1+="\u@\h "
    fi

    PS1+="$(tput setaf 2)\w$(tput sgr0)"

    # git branch
	if [ ! "${BRANCH}" == "" ]; then
        PS1+=" ${BRANCH}"
	fi

    # nonzero return value
	if [ $RETVAL -ne 0 ]; then
        PS1+=" $(tput setaf 1)[${RETVAL}]$(tput sgr0)"
    fi

    PS1+="\$ "
}

PROMPT_COMMAND=__bash_prompt
