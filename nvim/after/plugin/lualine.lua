require('lualine').setup {
  options = {
    theme = 'material',
    -- icons_enabled = false,
    -- component_separators = '|',
    -- section_separators = ''
    globalstatus = true,
  },
  sections = {
      lualine_a = { 'mode' },
      lualine_b = { 'branch', 'diff', 'diagnostics' },
      lualine_c = { 'buffers' },
      lualine_x = { 'encoding', 'fileformat', 'filetype' },
      lualine_y = { 'progress', 'searchcount' },
      lualine_z = { 'location' },
  }
}
