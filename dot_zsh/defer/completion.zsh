if ! type _get_comp_words_by_ref >/dev/null 2>&1; then
if [[ -z ${ZSH_VERSION:+set} ]]; then
_get_comp_words_by_ref ()
{
	local exclude cur_ words_ cword_
	if [ "$1" = "-n" ]; then
		exclude=$2
		shift 2
	fi
	__git_reassemble_comp_words_by_ref "$exclude"
	cur_=${words_[cword_]}
	while [ $# -gt 0 ]; do
		case "$1" in
		cur)
			cur=$cur_
			;;
		prev)
			prev=${words_[$cword_-1]}
			;;
		words)
			words=("${words_[@]}")
			;;
		cword)
			cword=$cword_
			;;
		esac
		shift
	done
}
else
_get_comp_words_by_ref ()
{
	while [ $# -gt 0 ]; do
		case "$1" in
		cur)
			cur=${COMP_WORDS[COMP_CWORD]}
			;;
		prev)
			prev=${COMP_WORDS[COMP_CWORD-1]}
			;;
		words)
			words=("${COMP_WORDS[@]}")
			;;
		cword)
			cword=$COMP_CWORD
			;;
		-n)
			# assume COMP_WORDBREAKS is already set sanely
			shift
			;;
		esac
		shift
	done
}
fi
fi

exists aws_completer && complete -C "$(which aws_completer)" aws
exists openstack && eval "$(openstack complete |sed 's;local comp="${!i}";local comp="${(P)i}";')"
