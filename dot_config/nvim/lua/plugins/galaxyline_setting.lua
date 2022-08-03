local gl = require('galaxyline')
local gls = gl.section
local diagnostic = require('galaxyline.providers.diagnostic')
local fileinfo = require('galaxyline.providers.fileinfo')
local buffer = require('galaxyline.providers.buffer')
local vcs = require('galaxyline.providers.vcs')
local condition = require('galaxyline.condition')
gl.short_line_list = { 'fern' }

function LspWarning()
  local count = diagnostic.get_diagnostic_warn()
  return (not count or count == "") and '' or "  W:" .. count
end

function LspError()
  local count = diagnostic.get_diagnostic_error()
  return (not count or count == "") and '' or "  E:" .. count
end

function LspHint()
  local count = diagnostic.get_diagnostic_hint()
  return (not count or count == "") and '' or "  H:" .. count
end

function LspInfo()
  local count = diagnostic.get_diagnostic_info()
  return (not count or count == "") and '' or "  I:" .. count
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

gls.left[1] = {
  FirstElement = {
    provider = function() return ' ' end,
    highlight = { colors.blue, colors.blue }
  }
}
gls.left[2] = {
  ViMode = {
    provider = function()
      local alias = { n = 'NORMAL', i = 'INSERT', c = 'COMMAND', V = 'L-VISUAL', [''] = 'B-VISUAL', v = 'VISUAL',
        s = 'SELECT', t = 'TEMRINAL', R = 'REPLACE', r = 'REPLACE' }
      return alias[vim.fn.mode()] .. ' '
    end,
    separator_highlight = { colors.blue, colors.slateblue },
    highlight = { colors.fg, colors.blue, 'bold' },
  }
}

gls.left[3] = {
  SkkStatus = {
    provider = function()
      local alias = { [''] = 'A', hira = 'あ', kata = 'ア', hankata = 'ｱ', zenkaku = "Ａ" }
      return '  ' .. alias[vim.g['skkeleton#mode']] .. ' '
    end,
    separator = ' ',
    separator_highlight = { colors.blue, colors.slateblue },
    highlight = { colors.fg, colors.blue, 'bold' },
  },
}

gls.left[4] = {
  DiffAdd = {
    provider = vcs.diff_add,
    icon = '+',
    highlight = { colors.white, colors.slateblue },
  }
}

gls.left[5] = {
  DiffModified = {
    provider = vcs.diff_modified,
    icon = '~',
    highlight = { colors.white, colors.slateblue },
  }
}

gls.left[6] = {
  DiffRemove = {
    provider = vcs.diff_remove,
    icon = '-',
    highlight = { colors.white, colors.slateblue },
  }
}

gls.left[7] = {
  GitBranch = {
    provider = vcs.get_git_branch,
    condition = condition.buffer_not_empty,
    separator = '  ',
    highlight = { colors.white, colors.slateblue },
    separator_highlight = { colors.white, colors.slateblue },
    icon = '  '
  }
}

gls.left[8] = {
  FileName = {
    provider = fileinfo.get_current_file_name,
    condition = condition.buffer_not_empty,
    highlight = { colors.white, colors.slateblue }
  }
}

gls.right[1] = {
  FileTypeName = {
    provider = function() return buffer.get_buffer_filetype():lower() .. ' ' end,
    condition = condition.buffer_not_empty,
    highlight = { colors.white, colors.slateblue },
  }
}

gls.right[2] = {
  FileIcon = {
    provider = fileinfo.get_file_icon,
    condition = condition.buffer_not_empty,
    highlight = { fileinfo.get_file_icon_color, colors.slateblue },
  }
}

gls.right[3] = {
  FileEncode = {
    provider = function() return fileinfo.get_file_encode():lower() end,
    highlight = { colors.white, colors.slateblue },
    separator = '',
    separator_highlight = { colors.white, colors.slateblue }
  }
}

gls.right[4] = {
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
    provider = fileinfo.current_line_percent,
    separator = ' ',
    separator_highlight = { colors.blue, colors.slateblue },
    highlight = { colors.fg, colors.blue },
  }
}

gls.right[6] = {
  LineInfo = {
    provider = fileinfo.line_column,
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
    provider = LspInfo,
    highlight = { colors.white, colors.slateblue },
  }
}

gls.right[11] = {
  Space = {
    provider = function() return ' ' end,
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
