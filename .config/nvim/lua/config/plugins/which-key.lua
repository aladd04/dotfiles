return {
  "folke/which-key.nvim", -- https://github.com/folke/which-key.nvim
  event = "VeryLazy",
  opts = {
    -- add custom config, if desired
  },
  keys = {
    {
      "<leader>?",
      function()
        require("which-key").show({
          global = false,
        })
      end,
      desc = "Show local keymaps",
    },
  },
}
