local parsers = {
  "lua",
  "typescript",
  "vimdoc",
  "html",
  "java",
  "yaml",
  "jsdoc",
  "javascript",
  "json",
  "toml",
  "bash",
  "fish",
  "markdown_inline",
  "markdown",
  "regex",
  "tsx",
  "css",
  "nix",
  "git_config",
  "gitcommit",
  "git_rebase",
  "gitignore",
  "gitattributes",
  "go",
  "gomod",
  "gowork",
  "cpp",
  "rust",
  "zig",
}

local function ensure_treesitter_runtime_in_rtp()
  local ok_lazy, lazy_config = pcall(require, "lazy.core.config")
  if not ok_lazy then
    return
  end

  local plugin = lazy_config.plugins["nvim-treesitter"]
  local runtime_dir = plugin and (plugin.dir .. "/runtime") or nil
  if not runtime_dir or not vim.uv.fs_stat(runtime_dir) then
    return
  end

  local rtp = vim.opt.runtimepath:get()
  if not vim.tbl_contains(rtp, runtime_dir) then
    vim.opt.runtimepath:append(runtime_dir)
  end
end

local function attach_treesitter(bufnr)
  if not vim.api.nvim_buf_is_loaded(bufnr) then
    return
  end

  if vim.bo[bufnr].buftype ~= "" or vim.bo[bufnr].filetype == "" then
    return
  end

  local ok_start = pcall(vim.treesitter.start, bufnr)
  if not ok_start then
    return
  end

  vim.wo[0][0].foldexpr = "v:lua.vim.treesitter.foldexpr()"
  vim.wo[0][0].foldmethod = "expr"
  vim.bo[bufnr].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
end

return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    lazy = false,
    build = ":TSUpdate",
    config = function()
      ensure_treesitter_runtime_in_rtp()
      local ts = require("nvim-treesitter")

      ts.setup({})
      ts.install(parsers)

      vim.treesitter.language.register("tsx", "typescriptreact")
      vim.treesitter.language.register("jsx", "javascriptreact")

      local group = vim.api.nvim_create_augroup("treesitter-main", { clear = true })
      vim.api.nvim_create_autocmd("FileType", {
        group = group,
        callback = function(args)
          attach_treesitter(args.buf)
        end,
      })

      vim.schedule(function()
        for _, buf in ipairs(vim.api.nvim_list_bufs()) do
          attach_treesitter(buf)
        end
      end)
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    branch = "main",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
    },
    config = function()
      local ok_textobjects, textobjects = pcall(require, "nvim-treesitter-textobjects")
      if not ok_textobjects or not textobjects.setup then
        return
      end

      textobjects.setup({
        select = {
          lookahead = true,
        },
        move = {
          set_jumps = true,
        },
      })

      local ok_select, select = pcall(require, "nvim-treesitter-textobjects.select")
      local ok_move, move = pcall(require, "nvim-treesitter-textobjects.move")
      local ok_swap, swap = pcall(require, "nvim-treesitter-textobjects.swap")
      if not (ok_select and ok_move and ok_swap) then
        return
      end

      local select_maps = {
        aa = "@parameter.outer",
        ia = "@parameter.inner",
        af = "@function.outer",
        ["if"] = "@function.inner",
        ac = "@class.outer",
        ic = "@class.inner",
      }

      for lhs, query in pairs(select_maps) do
        vim.keymap.set({ "x", "o" }, lhs, function()
          select.select_textobject(query, "textobjects")
        end)
      end

      local move_maps = {
        [")f"] = { move.goto_next_start, "@function.outer" },
        [")c"] = { move.goto_next_start, "@class.outer" },
        [")F"] = { move.goto_next_end, "@function.outer" },
        [")C"] = { move.goto_next_end, "@class.outer" },
        ["(f"] = { move.goto_previous_start, "@function.outer" },
        ["(c"] = { move.goto_previous_start, "@class.outer" },
        ["(F"] = { move.goto_previous_end, "@function.outer" },
        ["(C"] = { move.goto_previous_end, "@class.outer" },
      }

      for lhs, mapping in pairs(move_maps) do
        vim.keymap.set({ "n", "x", "o" }, lhs, function()
          mapping[1](mapping[2], "textobjects")
        end)
      end

      vim.keymap.set("n", "<leader>a", function()
        swap.swap_next("@parameter.inner")
      end)
      vim.keymap.set("n", "<leader>A", function()
        swap.swap_previous("@parameter.inner")
      end)
    end,
  },
  {
    "windwp/nvim-ts-autotag",
    opts = {
      opts = {
        enable_close = true,
        enable_rename = true,
        enable_close_on_slash = true,
      },
    },
  },
}
