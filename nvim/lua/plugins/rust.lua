local function merge(into, from)
  if type(from) ~= "table" or type(into) ~= "table" then
    return from
  end
  if vim.islist(from) or vim.islist(into) then
    return from
  end
  local result = vim.deepcopy(into)
  for k, v in pairs(from) do
    result[k] = merge(into[k], v)
  end
  return result
end

return {
  "mrcjkb/rustaceanvim",
  opts = {
    dap = {
      autoload_configurations = false,
    },
    server = {
      ---@param project_root string|nil
      ---@param default_settings table
      settings = function(project_root, default_settings)
        local ra = require("rustaceanvim.config.server")
        local settings = ra.load_rust_analyzer_settings(project_root, {
          default_settings = default_settings,
        })

        if project_root then
          local json_path = project_root .. "/.rust-analyzer.json"
          local f = io.open(json_path, "r")
          if f then
            local content = f:read("*a")
            f:close()
            local ok, project_settings = pcall(vim.json.decode, content)
            if ok and project_settings then
              settings = merge(settings, project_settings)
            end
          end
        end

        return settings
      end,
    },
  },
}
