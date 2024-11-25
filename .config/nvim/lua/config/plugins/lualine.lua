return {
  "nvim-lualine/lualine.nvim", -- https://github.com/nvim-lualine/lualine.nvim
  config = function()
    local lualine = require("lualine")

    lualine.setup({
      options = {
        theme = "catppuccin"
      },
    })
  end,
}
