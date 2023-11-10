-- lua_add {{{
require('Comment').setup({
  pre_hook = function(ctx)
    return require('ts_context_commentstring.internal').calculate_commentstring()
  end
})
-- }}}
