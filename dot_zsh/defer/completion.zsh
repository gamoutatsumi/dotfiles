exists gh && eval "$(gh completion --shell zsh)" && compdef _gh gh
exists deno && eval "$(deno completions zsh)" && compdef _deno deno
