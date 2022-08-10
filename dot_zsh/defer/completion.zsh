exists gh && eval "$(gh completion --shell zsh)" && compdef _gh gh
exists deno && eval "$(deno completions zsh)" && compdef _deno deno
exists kubectl && eval "$(kubectl completion zsh)" && compdef __start_kubectl kc
exists helm && eval "$(helm completion zsh)"
exists stern && eval "$(stern --completion zsh)"
