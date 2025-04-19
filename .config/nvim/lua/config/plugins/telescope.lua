return {
  "nvim-telescope/telescope.nvim", -- https://github.com/nvim-telescope/telescope.nvim
  branch = "0.1.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    {
      -- https://github.com/nvim-telescope/telescope-fzf-native.nvim
      "nvim-telescope/telescope-fzf-native.nvim",
      build = "make"
    },
  },
  config = function()
    local telescope = require("telescope")
    local actions = require("telescope.actions")

    -- run ":help telescope.builtin" to see options or visit https://github.com/nvim-telescope/telescope.nvim/blob/master/doc/telescope.txt
    telescope.setup({
      defaults = {
        path_display = {
          "smart", -- show path relative to cwd, or just filename if path is too long
        },
        mappings = {
          i = {
            ["<esc>"] = actions.close,
            ["<C-k>"] = actions.move_selection_previous,
            ["<C-j>"] = actions.move_selection_next,
          },
        },
        vimgrep_arguments = {
          "rg",
          "--color=never",
          "--no-heading",
          "--with-filename",
          "--line-number",
          "--column",
          "--smart-case",
          "--hidden", -- the rest is default, adding this so it searches hidden files
          "--fixed-strings", -- take the string literally without the need to escape
        },
        file_ignore_patterns = {
          "^%.git/"
        },
        extensions = {
          fzf = {
          },
        },
      },
    })

    -- load extensions
    telescope.load_extension("fzf")

    local map = vim.keymap.set
    map("n", "<leader>ff", "<cmd>Telescope find_files hidden=true<CR>", { desc = "Find file" })
    map("n", "<leader>fs", "<cmd>Telescope live_grep<CR>", { desc = "Find string" })
  end
}
