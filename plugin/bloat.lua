if vim.g.bloat_nvim_loaded then return end
vim.g.bloat_nvim_loaded = true

vim.api.nvim_create_user_command("Bloat", function(cmd)
  local arg = vim.trim(cmd.args)
  require("bloat").analyze(arg)
end, {
  desc = "Generate plugin bloat analysis",
  nargs = "?",
})
