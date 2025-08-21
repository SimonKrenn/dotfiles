return {
  {
    "snacks.nvim",
    opts = {
      bigfile = { enabled = true },
      picker = {
        enabled = true,
        sources = {
          files = { hidden = true, ignored = false },
          grep = { hidden = true, ignored = false },
          explorer = {
            hidden = true,
            tree = true,
            auto_close = true,
            layout = { preset = "ivy_split", preview = "left" },
          },
        },
      },
      explorer = { enabled = true },
      indent = { enabled = true },
      input = { enabled = true },
      git = { enabled = true },
      lazygit = { enabled = true },
      statuscolumn = { enabled = true, left = { "mark", "sign" }, right = { "fold", "git" } },
      notifier = { enabled = true },
      scroll = { enabled = true },
      dashboard = { enabled = true },
      scratch = { enabled = true },
    },
    keys = {
      -- pickers
      {
        "<leader><space>",
        function()
          Snacks.picker.buffers()
        end,
        desc = "recent buffers",
      },
      {
        "<leader>ff",
        function()
          Snacks.picker.files()
        end,
        desc = "[f]ind [f]iles",
      },
      {
        "<leader>fg",
        function()
          Snacks.picker.grep()
        end,
        desc = "[f]ind [g]rep",
      },
      {
        "<leader>fr",
        function()
          Snacks.picker.recent()
        end,
        desc = "[f]ind [r]ecent",
      },
      {
        "<leader>fp",
        function()
          Snacks.picker()
        end,
        desc = "[f]ind [p]icker",
      },
      -- explorer
      {
        "<leader>fe",
        function()
          Snacks.explorer()
        end,
        desc = "[f]ile [e]xplorer",
      },
      -- git
      {
        "<leader>lg",
        function()
          Snacks.lazygit()
        end,
        desc = "[l]azy [g]it",
      },
      -- lsp
      {
        "gd",
        function()
          Snacks.picker.lsp_definitions()
        end,
        desc = "[g]oto [d]efinition",
      },
      {
        "gD",
        function()
          Snacks.picker.lsp_declarations()
        end,
        desc = "[g]oto [D]eclaration",
      },
      {
        "gr",
        function()
          Snacks.picker.lsp_references()
        end,
        desc = "[g]oto [r]eferences",
      },
      {
        "gI",
        function()
          Snacks.picker.lsp_implementations()
        end,
        desc = "[g]oto [I]mplementations",
      },
      {
        "gy",
        function()
          Snacks.picker.lsp_type_definitions()
        end,
        desc = "[g]oto T[y]pe Definitions",
      },
      {
        "<leader>.",
        function()
          Snacks.scratch()
        end,
        desc = "Toggle scratch buffer",
      },
      {
        "<leader>S",
        function()
          Snacks.scratch.select()
        end,
        desc = "[S]elect scratch buffer",
      },
    },
  },
}
