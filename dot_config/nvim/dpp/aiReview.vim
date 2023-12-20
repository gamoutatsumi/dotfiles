" hook_source {{{
call ai_review#config(#{ chat_gpt: #{model:'gpt-4', azure: #{ use: v:true, url: 'http://127.0.0.1:8080', api_vewsion: 'v1' }} })
" }}}
