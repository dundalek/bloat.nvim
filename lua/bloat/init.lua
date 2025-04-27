local internal = require("bloat.internal")
local M = {}

function M.analyze(output_file)
  if output_file == nil or output_file == "" then
    output_file = vim.fn.expand("~/nvim-bloat-analysis.json")
  end

  local paths = internal.lazy_plugins_paths()
  internal.generate_analysis(output_file, paths)
end

return M
