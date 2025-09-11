return {
  "catppuccin/nvim",
  opts = function(_, opts)
    local module = require("catppuccin.groups.integrations.bufferline")
    if module then
      module.get = module.get_theme -- fixes bug https://github.com/LazyVim/LazyVim/issues/6355#issuecomment-3212986215
    end
    return opts
  end,
}
