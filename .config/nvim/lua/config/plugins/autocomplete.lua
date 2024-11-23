return {
  "hrsh7th/nvim-cmp", -- https://github.com/hrsh7th/nvim-cmp
  event = "InsertEnter",
  dependencies = {
    "L3MON4D3/LuaSnip", -- dependencie for below https://github.com/L3MON4D3/cmp-luasnip-choice
    "saadparwaiz1/cmp_luasnip", -- to show the completions https://github.com/saadparwaiz1/cmp_luasnip
    "hrsh7th/cmp-buffer", -- source buffer https://github.com/hrsh7th/cmp-buffer
    "hrsh7th/cmp-path", -- source file system https://github.com/hrsh7th/cmp-path
    "hrsh7th/cmp-cmdline", -- source the command line https://github.com/hrsh7th/cmp-cmdline
    "hrsh7th/cmp-nvim-lsp", -- source nvim https://github.com/hrsh7th/cmp-nvim-lsp
    "hrsh7th/cmp-nvim-lua", -- source nvim lua https://github.com/hrsh7th/cmp-nvim-lua
    { "tamago324/cmp-zsh", opts = function(_, opts) opts.zshrc = true end }, -- source zsh, and .zshrc file https://github.com/tamago324/cmp-zsh
    "Jezda1337/nvim-html-css", -- html + css https://github.com/Jezda1337/nvim-html-css
    "jmbuhr/otter.nvim", -- magic https://github.com/jmbuhr/otter.nvim
    "KadoBOT/cmp-plugins", -- nvim plugins https://github.com/KadoBOT/cmp-plugins
  },
  config = function()
    local cmp = require("cmp")
    local luasnip = require("luasnip")

    cmp.setup({
      completion = {
        completeopt = "menu,menuone",
      },
      snippet = {
        expand = function(args)
          luasnip.lsp_expand(args.body)
        end,
      },
      mapping = cmp.mapping.preset.insert({
        ["<C-p>"] = cmp.mapping.select_prev_item(),
        ["<C-n>"] = cmp.mapping.select_next_item(),
        ["<C-d>"] = cmp.mapping.scroll_docs(-4),
        ["<C-u>"] = cmp.mapping.scroll_docs(4),
        ["<C-Space>"] = cmp.mapping.complete(),
        ["<C-e>"] = cmp.mapping.close(),
        ["<CR>"] = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Insert, select = true, }),
      }),
      sources = cmp.config.sources({
        { name = "luasnip" },
        { name = "buffer" },
        { name = "path" },
        { name = "cmdline", option = { ignore_cmds = { "Man", "!" }, }, },
        { name = "nvim_lsp" },
        { name = "nvim_lua" },
        { name = "zsh" },
        { name = "html-css" },
        { name = "otter-ls" },
        { name = "plugins" },
      }),
    })
  end,
}
