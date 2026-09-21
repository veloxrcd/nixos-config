if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(
  os_icon
  dir
  vcs            # Keep this if you want Git status, or delete it if you don't
  newline
  prompt_char
)

POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(
  # Leave this entirely empty to clean up the right side
)

POWERLEVEL9K_MODE='nerdfont-v2'
POWERLEVEL9K_ICON_PADDING=none
POWERLEVEL9K_PROMPT_ADD_NEWLINE=true
POWERLEVEL9K_INSTANT_PROMPT=quiet

# Force the logo to specifically be NixOS instead of a generic Linux/Distro icon
typeset -g POWERLEVEL9K_OS_ICON_CONTENT_EXPANDED=' '

