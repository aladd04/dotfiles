return {
  "catppuccin/nvim", -- https://github.com/catppuccin/nvim
  name = "catppuccin",
  priority = 1000, -- make sure this plugin loads before others
  lazy = false, -- make sure this is loaded during startup
  config = function()
    require("catppuccin").setup({
      flavour = "mocha", -- auto, latte, frappe, macchiato, mocha
    })
    vim.cmd.colorscheme "catppuccin"
  end
}
