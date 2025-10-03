return {
  "folke/noice.nvim",
  event = "VeryLazy",
  opts = {
    routes = {
      {
        -- fixes https://github.com/folke/noice.nvim/issues/1150
        filter = {
          event = "lsp",
          kind = "progress",
          cond = function(message)
            local client = vim.tbl_get(message.opts, "progress", "client")
            return client == "roslyn"
          end,
        },
        opts = { skip = true },
      },
    },
  },
}
