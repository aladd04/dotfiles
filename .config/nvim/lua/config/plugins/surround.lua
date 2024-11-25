return {
  "kylechui/nvim-surround", -- https://github.com/kylechui/nvim-surround
  version = "*", -- for stability
  event = "VeryLazy",
  config = function()
    local surround = require("nvim-surround")
    surround.setup({})
  end
}
