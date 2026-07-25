local function pywal_theme()
  local c = vim.g.pywal
  if not c then return "auto" end
  return {
    normal = {
      a = { bg = c.color4, fg = c.color0, gui = "bold" },
      b = { bg = c.color8, fg = c.fg },
      c = { bg = c.bg, fg = c.fg },
    },
    insert = {
      a = { bg = c.color2, fg = c.color0, gui = "bold" },
      b = { bg = c.color8, fg = c.fg },
      c = { bg = c.bg, fg = c.fg },
    },
    visual = {
      a = { bg = c.color3, fg = c.color0, gui = "bold" },
      b = { bg = c.color8, fg = c.fg },
      c = { bg = c.bg, fg = c.fg },
    },
    command = {
      a = { bg = c.color5, fg = c.color0, gui = "bold" },
      b = { bg = c.color8, fg = c.fg },
      c = { bg = c.bg, fg = c.fg },
    },
    replace = {
      a = { bg = c.color1, fg = c.color0, gui = "bold" },
      b = { bg = c.color8, fg = c.fg },
      c = { bg = c.bg, fg = c.fg },
    },
    terminal = {
      a = { bg = c.color2, fg = c.color0, gui = "bold" },
      b = { bg = c.color8, fg = c.fg },
      c = { bg = c.bg, fg = c.fg },
    },
    inactive = {
      a = { bg = c.bg, fg = c.color8, gui = "bold" },
      b = { bg = c.bg, fg = c.color8 },
      c = { bg = c.bg, fg = c.color8 },
    },
  }
end

return {
  {
    "nvim-lualine/lualine.nvim",
    opts = function(_, opts)
      opts.theme = pywal_theme()
      opts.sections = opts.sections or {}
      opts.sections.lualine_x = { "filetype" }
    end,
  },
}
