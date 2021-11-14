local gl = require('galaxyline')
local gls = gl.section
local diagnostic = require('galaxyline.provider_diagnostic')
gl.short_line_list = { 'fern' }

function LspWarning()
  local count = diagnostic.get_diagnostic_warn()
  return count == nil and '' or "  W:" .. count
end
function LspError()
  local count = diagnostic.get_diagnostic_error()
  return count == nil and '' or "  E:" .. count
end
function LspHint()
  local count = diagnostic.get_diagnostic_hint()
  return count == nil and '' or "  H:" .. count
end
function LspInfo()
  local count = diagnostic.get_diagnostic_info()
  return count == nil and '' or "  I:" .. count
end

local colors = {
  bg = '#282c34',
  fg = '#092236',
  white = '#c3ccdc',
  yellow = '#fabd2f',
  cyan = '#008080',
  darkblue = '#092236',
  green = '#afd700',
  orange = '#FF8800',
  purple = '#ae81ff',
  magenta = '#d16d9e',
  grey = '#c0c0c0',
  blue = '#82aaff',
  cadetblue = '#a1aab8',
  slateblue = '#2c3043'
}

local buffer_not_empty = function()
  if vim.fn.empty(vim.fn.expand('%:t')) ~= 1 then
    return true
  end
  return false
end

gls.left[1] = {
  FirstElement = {
    provider = function() return ' ' end,
    highlight = { colors.blue, colors.blue }
  }
}
gls.left[2] = {
  ViMode = {
    provider = function()
      local alias = { n = 'NORMAL', i = 'INSERT', c = 'COMMAND', V = 'L-VISUAL', [''] = 'B-VISUAL', v = 'VISUAL', s = 'SELECT', t = 'TEMRINAL', R = 'REPLACE', r = 'REPLACE' }
      return alias[vim.fn.mode()] .. ' '
    end,
    separator_highlight = { colors.blue, colors.slateblue },
    highlight = { colors.fg, colors.blue, 'bold' },
  }
}

gls.left[3] = {
  SkkStatus = {
    provider = function()
      local alias = { [''] = 'A', hira = 'あ', kata = 'ア', hankata = 'ｱ' }
      return '  ' .. alias[vim.g['skkeleton#mode']] .. ' '
    end,
    separator = ' ',
    separator_highlight = { colors.blue, colors.slateblue },
    highlight = { colors.fg, colors.blue, 'bold' },
  },
}

gls.left[4] = {
  DiffAdd = {
    provider = 'DiffAdd',
    icon = '+',
    highlight = { colors.white, colors.slateblue },
  }
}

gls.left[5] = {
  DiffModified = {
    provider = 'DiffModified',
    icon = '~',
    highlight = { colors.white, colors.slateblue },
  }
}

gls.left[6] = {
  DiffRemove = {
    provider = 'DiffRemove',
    icon = '-',
    highlight = { colors.white, colors.slateblue },
  }
}

gls.left[7] = {
  GitBranch = {
    provider = 'GitBranch',
    condition = buffer_not_empty,
    separator = '  ',
    highlight = { colors.white, colors.slateblue },
    separator_highlight = { colors.white, colors.slateblue },
    icon = '  '
  }
}

gls.left[8] = {
  FileName = {
    provider = 'FileName',
    condition = buffer_not_empty,
    highlight = { colors.white, colors.slateblue }
  }
}

gls.right[1] = {
  FileTypeName = {
    provider = function() return require('galaxyline.provider_buffer').get_buffer_filetype():lower() .. ' ' end,
    condition = buffer_not_empty,
    highlight = { colors.white, colors.slateblue },
  }
}

gls.right[2] = {
  FileIcon = {
    provider = 'FileIcon',
    condition = buffer_not_empty,
    highlight = { require('galaxyline.provider_fileinfo').get_file_icon_color, colors.slateblue },
  }
}

gls.right[3] = {
  FileEncode = {
    provider = function() return require('galaxyline.provider_fileinfo').get_file_encode():lower() end,
    highlight = { colors.white, colors.slateblue },
    separator = '',
    separator_highlight = { colors.white, colors.slateblue } 
  }
}

gls.right[4]= {
  FileFormatIcon = {
    provider = function()
      return vim.fn['WebDevIconsGetFileFormatSymbol']()
    end,
    separator = ' ',
    separator_highlight = { colors.white, colors.slateblue },
    highlight = { colors.white, colors.slateblue },
  }
}

gls.right[5] = {
  Percent = {
    provider = 'LinePercent',
    separator = ' ',
    separator_highlight = { colors.blue, colors.slateblue },
    highlight = { colors.fg, colors.blue },
  }
}

gls.right[6] = {
  LineInfo = {
    provider = 'LineColumn',
    highlight = { colors.fg, colors.blue },
  }
}

gls.right[7] = {
  DiagnosticError = {
    provider = LspError,
    separator = ' ',
    separator_highlight = { colors.slateblue, colors.blue },
    highlight = { colors.white, colors.slateblue }
  }
}

gls.right[8] = {
  DiagnosticWarn = {
    provider = LspWarning,
    highlight = { colors.white, colors.slateblue },
  }
}

gls.right[9] = {
  DiagnosticHint = {
    provider = LspHint,
    highlight = { colors.white, colors.slateblue },
  }
}

gls.right[10] = {
  DiagnosticInfo = {
    icon = 'I: ',
    provider = LspInfo,
    highlight = { colors.white, colors.slateblue },
  }
}

gls.right[11] = {
  Space = {
    provider = function () return ' ' end,
    highlight = { colors.slateblue, colors.slateblue }
  }
}

gls.short_line_left[1] = {
  FirstElement = {
    provider = function() return '▋' end,
    highlight = { colors.blue, colors.blue }
  }
}

gls.short_line_left[2] = {
  BufferType = {
    provider = { 'FileTypeName', function() return ' ' end },
    separator = '',
    separator_highlight = { colors.blue, colors.slateblue },
    highlight = { colors.fg, colors.blue, 'bold' }
  }
}
