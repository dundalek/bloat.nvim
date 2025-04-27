local function scan_directory(path)
  local files = {}
  local handle = vim.loop.fs_scandir(path)

  if not handle then
    print("Failed to scan directory: " .. path)
    return files
  end

  while true do
    local name, type = vim.loop.fs_scandir_next(handle)
    if not name then break end

    local full_path = path .. "/" .. name
    if type == "directory" then
      local subdir_files = scan_directory(full_path)
      for _, file in ipairs(subdir_files) do
        table.insert(files, file)
      end
    elseif type == "file" and (name:match("%.lua$") or name:match("%.vim$")) then
      table.insert(files, full_path)
    end
  end

  return files
end

local plugin_subdirs = { "after", "autoload", "ftplugin", "lua", "plugin" }

local function scan_plugin_directory(plugin_path)
  local files = {}
  for _, subdir in ipairs(plugin_subdirs) do
    local path = plugin_path .. "/" .. subdir
    if vim.fn.isdirectory(path) == 1 then
      vim.list_extend(files, scan_directory(path))
    end
  end
  return files
end

local function get_file_size(file_path)
  local stat = vim.loop.fs_stat(file_path)
  if stat then
    return stat.size
  end
  return 0
end

local function build_metafile(paths)
  local files = {}
  for _, path in ipairs(paths) do
    vim.list_extend(files, scan_plugin_directory(path))
  end

  local inputs = {}
  local output_inputs = {}
  local total_bytes = 0

  for _, filepath in ipairs(files) do
    local size = get_file_size(filepath)

    inputs[filepath] = {
      bytes = size,
      imports = {}
    }
    output_inputs[filepath] = {
      bytesInOutput = size
    }
    total_bytes = total_bytes + size
  end

  return {
    inputs = inputs,
    outputs = {
      root = {
        imports = {},
        exports = {},
        inputs = output_inputs,
        bytes = total_bytes
      }
    }
  }
end

local function save_analysis_file(output_file, data)
  local status = pcall(function()
    local file = assert(io.open(output_file, "w"))
    file:write(vim.fn.json_encode(data))
    file:close()
  end)

  if status then
    print("Analysis written to: " .. output_file)
    print("Open https://esbuild.github.io/analyze/ and load the file to visualize.")
  else
    print("Failed to write output file: " .. output_file)
  end
end

local function generate_analysis(output_file, paths)
  local data = build_metafile(paths)
  save_analysis_file(output_file, data)
end

local function lazy_plugins_paths()
  local paths = {}
  for _, plugin in pairs(require("lazy").plugins()) do
    if plugin.dir then
      table.insert(paths, plugin.dir)
    end
  end
  return paths
end

return {
  generate_analysis = generate_analysis,
  lazy_plugins_paths = lazy_plugins_paths,
}
