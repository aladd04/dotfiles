return {
  "windwp/nvim-autopairs", -- https://github.com/windwp/nvim-autopairs
  event = "InsertEnter",
  config = function()
    local autopairs = require("nvim-autopairs")
    local cmp_autopairs = require("nvim-autopairs.completion.cmp")
    local cmp = require("cmp")

    autopairs.setup({
      check_ts = true, -- enable treesitter
    })

    -- make autopairs and autocompletion work together
    cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
  end,
}
