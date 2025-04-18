-- https://github.com/folke/snacks.nvim/blob/main/docs/notifier.md lsp progress autocmd
---@type table<number, {token:lsp.ProgressToken, msg:string, done:boolean}[]>
local progress = vim.defaulttable()
vim.api.nvim_create_autocmd("LspProgress", {
	---@param ev {data: {client_id: integer, params: lsp.ProgressParams}}
	callback = function(ev)
		local client = vim.lsp.get_client_by_id(ev.data.client_id)
		local value = ev.data.params
			.value --[[@as {percentage?: number, title?: string, message?: string, kind: "begin" | "report" | "end"}]]
		if not client or type(value) ~= "table" then
			return
		end
		local p = progress[client.id]

		for i = 1, #p + 1 do
			if i == #p + 1 or p[i].token == ev.data.params.token then
				p[i] = {
					token = ev.data.params.token,
					msg = ("[%3d%%] %s%s"):format(
						value.kind == "end" and 100 or value.percentage or 100,
						value.title or "",
						value.message and (" **%s**"):format(value.message) or ""
					),
					done = value.kind == "end",
				}
				break
			end
		end

		local msg = {} ---@type string[]
		progress[client.id] = vim.tbl_filter(function(v)
			return table.insert(msg, v.msg) or not v.done
		end, p)

		local spinner = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" }
		vim.notify(table.concat(msg, "\n"), "info", {
			id = "lsp_progress",
			title = client.name,
			opts = function(notif)
				notif.icon = #progress[client.id] == 0 and " "
					or spinner[math.floor(vim.uv.hrtime() / (1e6 * 80)) % #spinner + 1]
			end,
		})
	end,
})


return {
	"folke/snacks.nvim",
	priority = 1000,
	lazy = false,
	opts = {
		statuscolumn = { enabled = true },
		dashboard = { enabled = true },
		indent = { enabled = true },
		toggle = { enabled = true },
		scope = { enabled = true },
		notifier = { enabled = true, top_down = false },
		explorer = {
			enabled = true
		},
		picker = {
			sources = {
				files = {
					hidden = true,
					ignored = true
				},
				grep = {
					hidden = true,
					ignored = true,
				},
				explorer = {
					finder = "explorer",
					sort = { fields = { "sort" } },
					hidden = true,
					tree = true,
					supports_live = true,
					follow_file = true,
					auto_close = true,
					jump = { close = false },
					layout = { preset = "ivy_split", preview = "left" },
					formatters = { file = { filename_only = true } },
					matcher = { sort_empty = false, fuzzy = false },
					config = function(opts)
						return require("snacks.picker.source.explorer").setup(opts)
					end,
				},
				projects = {
					dev = { "~/Workspace" }
				}
			}
		}
	},
	keys = {
		{ "<leader>lg",       function() Snacks.lazygit() end,                              desc = "Lazygit" },
		{ "<leader>gB",       function() Snacks.gitbrowse() end,                            desc = "Gitbrowse" },
		{ "<c-/>",            function() Snacks.terminal() end,                             desc = "Toggle Terminal" },
		{ "<leader>nf",       function() Snacks.explorer() end,                             desc = "Snacks Explorer" },
		{ "<leader>ff",       function() Snacks.picker.files() end,                         desc = "File Picker" },
		{ "<leader>gs",       function() Snacks.picker.git_status() end,                    desc = "Git Status" },
		{ "<leader>fg",       function() Snacks.picker.grep() end,                          desc = "Grep Picker" },
		{ "<leader><leader>", function() Snacks.picker.smart() end,                         desc = "Smart Picker" },
		{ "<leader>sp",       function() Snacks.picker() end,                               desc = "All Pickers" },
		{ "<leader>fb",       function() Snacks.picker.buffers() end,                       desc = "Buffers" },
		{ "gd",               function() Snacks.picker.lsp_definitions() end,               desc = "LSP: Definitions" },
		{ "gr",               function() Snacks.picker.lsp_references() end,                desc = "LSP: References" },
		{ "gI",               function() Snacks.picker.lsp_implementations() end,           desc = "LSP: Implementations" },
		{ "D",                function() Snacks.picker.lsp_type_definition() end,           desc = "LSP: Type Definition" },
		{ "ds",               function() Snacks.picker.lsp_document_symbols() end,          desc = "LSP: Document Symbols" },
		{ "ws",               function() Snacks.picker.lsp_dynamic_workspace_symbols() end, desc = "LSP: Workspace Symbols" },
	}
}
