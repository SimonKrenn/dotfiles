return {
    'obsidian-nvim/obsidian.nvim',
    version = '*',
    lazy = 'true',
    ft = 'markdown',
    opts = {
        workspaces = {
          {
            name = 'personal',
            path = '~/vaults/personal',
          },
          {
            name = 'work',
            paht = '~/vaults/work',
          },
        },
    completion = {
        blink = true
      },
    }
}
