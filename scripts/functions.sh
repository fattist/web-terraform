#!/usr/bin/env bash
coloredEcho () {
    local exp=$1;
    local color=$2;
    if ! [[ $color =~ '^[0-9]$' ]] ; then
       case $(echo $color | tr '[:upper:]' '[:lower:]') in
        black) color=0 ;;
        red) color=1 ;;
        green) color=2 ;;
        yellow) color=3 ;;
        blue) color=4 ;;
        magenta) color=5 ;;
        cyan) color=6 ;;
        white|*) color=7 ;; # white or invalid color
       esac
    fi
    tput setaf $color;
    echo $exp;
    tput sgr0;
}

exit_on_error () {
    if [ ${1} != 0 ]; then
        coloredEcho "${2}" red
        exit ${1}
    fi
}

exit_on_completion() {
    if [ ${1} != 0 ]; then
        coloredEcho "${2}" green
        exit ${1}
    fi
}

prompt_to_continue() {
  read -p $1 -n 1 -r
  if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    exit_on_error 1 "${PROMPT_ERROR}"
  fi
}
