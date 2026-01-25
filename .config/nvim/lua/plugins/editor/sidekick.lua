return {
  {
    "folke/sidekick.nvim",
    opts = {
      cli = {
        mux = {
          backend = "tmux",
          enabled = true,
        },
        win = {
          keys = {
            prompt = { "<leader>p", "prompt", mode = "n" },
          },
        },
        tools = {
          amp = {
            cmd = { "amp" },
          },
        },
      },
    },
    keys = {
      {
        "<tab>",
        function()
          if not require("sidekick").nes_jump_or_apply() then
            return "<tab>"
          end
        end,
        expr = true,
        desc = "Goto/apply next edit suggestion",
      },
      {
        "<leader>so",
        function()
          require("sidekick.cli").toggle({ name = "opencode", focus = true })
        end,
      },
      {
        "<leader>sc",
        function()
          require("sidekick.cli").toggle({ name = "codex", focus = true })
        end,
      },
      {
        "<leader>sg",
        function()
          require("sidekick.cli").toggle({ name = "copilot", focus = true })
        end,
      },
      {
        "<leader>sa",
        function()
          require("sidekick.cli").toggle({ name = "amp", focus = true })
        end,
      },
    },
  },
  {
    "zbirenbaum/copilot.lua",
    requires = {
      "copilotlsp-nvim/copilot-lsp",
    },
    cmd = "Copilot",
    event = "InsertEnter",
    config = function()
      require("copilot").setup({})
    end,
  },
}
