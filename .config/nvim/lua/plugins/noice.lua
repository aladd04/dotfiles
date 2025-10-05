return {
  "folke/noice.nvim",
  event = "VeryLazy",
  opts = {
    lsp = {
      progress = {
        enabled = false, -- temp fix for https://github.com/folke/noice.nvim/issues/1150
      },
    },
  },
}
