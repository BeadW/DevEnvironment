require("brad.plugins-setup")
require("brad.core.options")
require("brad.core.keymaps")
require("brad.core.colorscheme")
require("brad.plugins.comment")
require("brad.plugins.nvim-tree")
require("brad.plugins.lualine")
require("brad.plugins.telescope")
require("brad.plugins.nvim-cmp")
require("brad.plugins.lsp.mason")
require("brad.plugins.lsp.lspsaga")
--require("brad.plugins.lsp.lspconfig")
require("brad.plugins.lsp.null-ls")
require("brad.plugins.autopairs")
require("brad.plugins.treesitter")
require("brad.plugins.gitsigns")
require("brad.plugins.indent-blankline")
require("lspconfig").eslint.setup({
  on_attach = function(client, bufnr)
    client.server_capabilities.documentFormattingProvider = true

    vim.api.nvim_create_autocmd("BufWritePre", {
      buffer = bufnr,
      command = "EslintFixAll",
    })
  end,
})
vim.api.nvim_create_autocmd("TermOpen", {
  pattern = "*",
  command = "startinsert", -- 'startinsert' puts you into Insert mode, which for terminal buffers is Terminal mode
  desc = "Automatically enter terminal mode on TermOpen",
})
