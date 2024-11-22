return {
  "goolord/alpha-nvim", -- https://github.com/goolord/alpha-nvim
  event = "VimEnter", -- our greeter
  config = function()
    local alpha = require("alpha")
    local dashboard = require("alpha.themes.dashboard")

    -- stole from https://github.com/MaximilianLloyd/ascii.nvim/tree/master/lua/ascii
    dashboard.section.header.val = {
"  ██████   █████                   █████   █████  ███                  ",
" ░░██████ ░░███                   ░░███   ░░███  ░░░                   ",
"  ░███░███ ░███   ██████   ██████  ░███    ░███  ████  █████████████   ",
"  ░███░░███░███  ███░░███ ███░░███ ░███    ░███ ░░███ ░░███░░███░░███  ",
"  ░███ ░░██████ ░███████ ░███ ░███ ░░███   ███   ░███  ░███ ░███ ░███  ",
"  ░███  ░░█████ ░███░░░  ░███ ░███  ░░░█████░    ░███  ░███ ░███ ░███  ",
"  █████  ░░█████░░██████ ░░██████     ░░███      █████ █████░███ █████ ",
" ░░░░░    ░░░░░  ░░░░░░   ░░░░░░       ░░░      ░░░░░ ░░░░░ ░░░ ░░░░░  ",
"                                                                       ",
    }

    dashboard.section.buttons.val = {
      dashboard.button("SPC ee", "   > Toggle file explorer", "<cmd>NvimTreeToggle<CR>"),
      dashboard.button("SPC ff", "   > Find File", "<cmd>Telescope find_files hidden=true<CR>"),
      dashboard.button("SPC fs", "   > Find Word", "<cmd>Telescope live_grep<CR>"),
      dashboard.button("q", "   > Quit Neovim", "<cmd>qa<CR>"),
    }

    alpha.setup(dashboard.opts)

    -- disable folding on alpha buffer
    vim.cmd([[autocmd FileType alpha setlocal nofoldenable]])
  end,
}
