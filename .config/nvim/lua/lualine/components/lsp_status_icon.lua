-- Implement as a proper lualine component so it can be referenced directly
local LualineComponent = require("lualine.component")
local M = LualineComponent:extend()

local default_icons = {
  lua_ls = "",
  tsserver = "󰛦",
  vtsls = "󰛦",
  pyright = "󰌠",
  ruff = "󰌠",
  rust_analyzer = "",
  gopls = "",
  clangd = "",
  html = "",
  cssls = "",
  jsonls = "",
  yamlls = "",
  tailwindcss = "󱏿",
  svelte = "",
  marksman = "󰽉",
  bashls = "",
  dockerls = "",
  graphql = "",
  eslint = "",
  denols = "🦕",
  ["nil_ls"] = "",
  ["hls"] = "",
  -- popular metas/aux
  ["null-ls"] = "",
  ["copilot"] = "",
}

local function get_clients(bufnr)
  return vim.lsp.get_active_clients({ bufnr = bufnr })
end

local function fmt_client(client, opts)
  local name = client.name or "LSP"
  local icon = (opts.icons and (opts.icons[name] or opts.icons._)) or opts.default_icon
  if opts.icon_only then
    return icon
  end
  if opts.uppercase then
    name = name:upper()
  end
  return (icon and (icon .. " ") or "") .. (opts.show_name and name or "")
end

-- Initialize component options
function M:init(opts)
  self.opts = vim.tbl_extend("force", {
    icons = default_icons, -- map of server_name -> icon; "_" acts as a catch-all
    default_icon = "",
    icon_only = false, -- if true, show only icons
    show_name = true, -- if false and icon_only=false, shows just icon
    sep = " ",
    max = nil, -- number: limit how many to show
    dedup = true, -- collapse duplicate names (rare but possible)
    uppercase = false,
    order_by = "name", -- "name" | "id"
  }, opts or self.options or {})
end

-- Generate status each refresh
function M:update_status()
  local opts = self.opts
  local bufnr = vim.api.nvim_get_current_buf()
  local clients = get_clients(bufnr)
  if not clients or #clients == 0 then
    return ""
  end

  if opts.order_by == "id" then
    table.sort(clients, function(a, b)
      return a.id < b.id
    end)
  else
    table.sort(clients, function(a, b)
      return (a.name or "") < (b.name or "")
    end)
  end

  local seen, parts = {}, {}
  for _, client in ipairs(clients) do
    local key = client.name or tostring(client.id)
    if not opts.dedup or not seen[key] then
      table.insert(parts, fmt_client(client, opts))
      seen[key] = true
    end
    if opts.max and #parts >= opts.max then
      break
    end
  end

  return table.concat(parts, opts.sep)
end

do
  local aug = vim.api.nvim_create_augroup("LualineLspIconsRefresh", { clear = true })
  vim.api.nvim_create_autocmd({ "LspAttach", "LspDetach" }, {
    group = aug,
    callback = function()
      pcall(function()
        require("lualine").refresh({ place = { "statusline" } })
      end)
    end,
  })
end

return M
