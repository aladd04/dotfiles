return {
  "neovim/nvim-lspconfig", -- https://github.com/neovim/nvim-lspconfig?tab=readme-ov-file
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    { "antosha417/nvim-lsp-file-operations", config = true }, -- https://github.com/antosha417/nvim-lsp-file-operations
    { "folke/lazydev.nvim", opts = {} }, -- https://github.com/folke/lazydev.nvim
  },
  config = function()
    local lspconfig = require("lspconfig")
    local mason_lspconfig = require("mason-lspconfig")
    local cmp_nvim_lsp = require("cmp_nvim_lsp")
    local map = vim.keymap.set
    local capabilities = cmp_nvim_lsp.default_capabilities()

    -- on lsp attach let's get some extra lsp-specific keybinds
    vim.api.nvim_create_autocmd("LspAttach", {
      group = vim.api.nvim_create_augroup("UserLspConfig", {}),
      callback = function(ev)
        -- shared opts across keybinds
        local opts = {
          buffer = ev.buf, -- ensure the keybinds are specific to the open buffer
          silent = true, -- suppress cmd messages
        }

        opts.desc = "Show LSP references"
        map("n", "<leader>lr", "<cmd>Telescope lsp_references<CR>", opts)
        opts.desc = "Show LSP definitions"
        map("n", "<leader>ld", "<cmd>Telescope lsp_definitions<CR>", opts)
        opts.desc = "Go to definition"
        map("n", "gd", vim.lsp.buf.declaration, opts)
        opts.desc = "Show LSP implementations"
        map("n", "<leader>li", "<cmd>Telescope lsp_implementations<CR>", opts)
        opts.desc = "Rename symbol"
        map("n", "<leader>lr", vim.lsp.buf.rename, opts)
        opts.desc = "Show documentation for symbol"
        map("n", "<leader>lk", vim.lsp.buf.hover, opts)
        opts.desc = "Restart LSP"
        map("n", "<leader>lr", ":LspRestart<CR>", opts)
      end,
    })

    -- note: some configuration can be in other lsp plugin files
    mason_lspconfig.setup_handlers({
      -- default handler for installed servers
      function(server_name)
        lspconfig[server_name].setup({
          capabilities = capabilities,
        })
      end,
    })
  end
}
