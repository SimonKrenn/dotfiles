return {
  "NickvanDyke/opencode.nvim",
  keys = {
    {
      "<leader>ot",
      function()
        require("opencode").toggle()
      end,
      desc = "Toggle embedded opencode",
    },
    {
      "<leader>oa",
      function()
        require("opencode").ask("@cursor: ")
      end,
      desc = "Ask opencode",
      mode = "n",
    },
    {
      "<leader>oa",
      function()
        require("opencode").ask("@selection: ")
      end,
      desc = "Ask opencode about selection",
      mode = "v",
    },
    {
      "<leader>op",
      function()
        require("opencode").select_prompt()
      end,
      desc = "Select prompt",
      mode = { "n", "v" },
    },
    {
      "<leader>on",
      function()
        require("opencode").command("session_new")
      end,
      desc = "New session",
    },
  },
}
