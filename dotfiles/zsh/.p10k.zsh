if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(
  os_icon
  dir
  vcs
  newline
  prompt_char
)

POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(
  status
  command_execution_time
  background_jobs
  direnv
  nix_shell
)

POWERLEVEL9K_MODE='nerdfont-v2'
POWERLEVEL9K_ICON_PADDING=none
POWERLEVEL9K_PROMPT_ADD_NEWLINE=true
POWERLEVEL9K_INSTANT_PROMPT=quiet
