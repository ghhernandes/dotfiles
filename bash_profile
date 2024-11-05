# .bash_profile

# Get the aliases and functions
if [ -f ~/.bashrc ]; then
    . ~/.bashrc
fi

if [[ -z "${OPENAPI_API_KEY}" && -e "$HOME/.config/gpt/token" ]]; then
    export OPENAI_API_KEY="$(head -1 "$HOME/.config/gpt/token")"
fi

# User specific environment and startup programs
#
export EDITOR=nvim
export LANG=en_US.UTF-8


export PATH=$PATH:/usr/local/go/bin
export PATH=$PATH:$HOME/go/bin
