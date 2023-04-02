-- set colorscheme to nightfly with protected call
-- in case it isn't installed
vim.g.moonflyTransparent = true
local status, _ = pcall(vim.cmd, "colorscheme moonfly")
if not status then
  print("Colorscheme not found!") -- print error if colorscheme not installed
  return
end
