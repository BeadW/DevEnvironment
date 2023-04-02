-- import blankline
local blankline_status, blankline = pcall(require, "indent_blankline")
if not blankline_status then
  return
end

vim.opt.termguicolors = true
vim.cmd([[highlight IndentBlanklineIndent1 guifg=#ff5189 gui=nocombine]])
vim.cmd([[highlight IndentBlanklineIndent2 guifg=#c2c292 gui=nocombine]])
vim.cmd([[highlight IndentBlanklineIndent3 guifg=#85dc85 gui=nocombine]])
vim.cmd([[highlight IndentBlanklineIndent4 guifg=#36c692 gui=nocombine]])
vim.cmd([[highlight IndentBlanklineIndent5 guifg=#74b2ff gui=nocombine]])
vim.cmd([[highlight IndentBlanklineIndent6 guifg=#ae81ff gui=nocombine]])

vim.opt.list = true
vim.opt.listchars:append("space:⋅")
--vim.opt.listchars:append("eol:↴")

blankline.setup({
  space_char_blankline = " ",
  char_highlight_list = {
    "IndentBlanklineIndent1",
    "IndentBlanklineIndent2",
    "IndentBlanklineIndent3",
    "IndentBlanklineIndent4",
    "IndentBlanklineIndent5",
    "IndentBlanklineIndent6",
  },
})
