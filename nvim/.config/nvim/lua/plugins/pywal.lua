local M = {}

function M.setup()
  local colors = {}
  local ok, result = pcall(dofile, vim.fn.expand("~/.cache/wal/colors-nvim.lua"))
  if ok and result then
    colors = result
  end

  local theme = {}

  if colors.special then
    theme.bg = colors.special.background
    theme.fg = colors.special.foreground
  end

  if colors.colors then
    theme.color0 = colors.colors.color0
    theme.color1 = colors.colors.color1
    theme.color2 = colors.colors.color2
    theme.color3 = colors.colors.color3
    theme.color4 = colors.colors.color4
    theme.color5 = colors.colors.color5
    theme.color6 = colors.colors.color6
    theme.color7 = colors.colors.color7
    theme.color8 = colors.colors.color8
    theme.color9 = colors.colors.color9
    theme.color10 = colors.colors.color10
    theme.color11 = colors.colors.color11
    theme.color12 = colors.colors.color12
    theme.color13 = colors.colors.color13
    theme.color14 = colors.colors.color14
    theme.color15 = colors.colors.color15
  end

  vim.g.pywal = theme

  if theme.bg then
    vim.api.nvim_set_hl(0, "Normal", { bg = theme.bg, fg = theme.fg })
    vim.api.nvim_set_hl(0, "NormalFloat", { bg = theme.bg, fg = theme.fg })
    vim.api.nvim_set_hl(0, "WinSeparator", { fg = theme.color4 })
    vim.api.nvim_set_hl(0, "CursorLine", { bg = theme.color8 })
    vim.api.nvim_set_hl(0, "LineNr", { fg = theme.color8 })
    vim.api.nvim_set_hl(0, "CursorLineNr", { fg = theme.fg })
    vim.api.nvim_set_hl(0, "Comment", { fg = theme.color8, italic = true })
    vim.api.nvim_set_hl(0, "String", { fg = theme.color2 })
    vim.api.nvim_set_hl(0, "Number", { fg = theme.color3 })
    vim.api.nvim_set_hl(0, "Boolean", { fg = theme.color3 })
    vim.api.nvim_set_hl(0, "Float", { fg = theme.color3 })
    vim.api.nvim_set_hl(0, "Function", { fg = theme.color4 })
    vim.api.nvim_set_hl(0, "Keyword", { fg = theme.color5 })
    vim.api.nvim_set_hl(0, "Conditional", { fg = theme.color5 })
    vim.api.nvim_set_hl(0, "Repeat", { fg = theme.color5 })
    vim.api.nvim_set_hl(0, "Operator", { fg = theme.color6 })
    vim.api.nvim_set_hl(0, "Type", { fg = theme.color3 })
    vim.api.nvim_set_hl(0, "Identifier", { fg = theme.color6 })
    vim.api.nvim_set_hl(0, "Constant", { fg = theme.color5 })
    vim.api.nvim_set_hl(0, "PreProc", { fg = theme.color5 })
    vim.api.nvim_set_hl(0, "Special", { fg = theme.color4 })
    vim.api.nvim_set_hl(0, "Todo", { bg = theme.color3, fg = theme.bg })
    vim.api.nvim_set_hl(0, "Visual", { bg = theme.color8 })
    vim.api.nvim_set_hl(0, "Pmenu", { bg = theme.color0, fg = theme.fg })
    vim.api.nvim_set_hl(0, "PmenuSel", { bg = theme.color4, fg = theme.bg })
    vim.api.nvim_set_hl(0, "Search", { bg = theme.color3, fg = theme.bg })
    vim.api.nvim_set_hl(0, "IncSearch", { bg = theme.color4, fg = theme.bg })
    vim.api.nvim_set_hl(0, "MatchParen", { bg = theme.color4 })
    vim.api.nvim_set_hl(0, "Error", { bg = theme.color1, fg = theme.color7 })
    vim.api.nvim_set_hl(0, "WarningMsg", { fg = theme.color3 })
    vim.api.nvim_set_hl(0, "Directory", { fg = theme.color4 })
    vim.api.nvim_set_hl(0, "Title", { fg = theme.color5, bold = true })
    vim.api.nvim_set_hl(0, "TabLine", { bg = theme.bg, fg = theme.color8 })
    vim.api.nvim_set_hl(0, "TabLineSel", { bg = theme.color4, fg = theme.bg })
    vim.api.nvim_set_hl(0, "TabLineFill", { bg = theme.bg })
    vim.api.nvim_set_hl(0, "StatusLine", { bg = theme.color8, fg = theme.fg })
    vim.api.nvim_set_hl(0, "StatusLineNC", { bg = theme.bg, fg = theme.color8 })
  end
end

return {
  {
    name = "pywal",
    dir = vim.fn.expand("~/.config/nvim"),
    lazy = false,
    priority = 1000,
    config = function()
      M.setup()
    end,
  },
}
