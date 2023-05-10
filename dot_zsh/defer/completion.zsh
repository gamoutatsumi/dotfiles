exists gh && eval "$(gh completion --shell zsh)" && compdef _gh gh
exists deno && eval "$(deno completions zsh)" && compdef _deno deno
exists kubectl && eval "$(kubectl completion zsh)" && compdef __start_kubectl kc
exists helm && eval "$(helm completion zsh)"
exists stern && eval "$(stern --completion zsh)"
exists aws_completer && complete -C "$(which aws_completer)" aws
exists kubebuilder && eval "$(kubebuilder completion zsh)" && compdef _kubebuilder kubebuilder
exists rtx && eval "$(rtx completion zsh)" && compdef _rtx rtx
exists aqua && eval "$(aqua completion zsh)"
exists bw && eval "$(bw completion --shell zsh)" && compdef _bw bw
