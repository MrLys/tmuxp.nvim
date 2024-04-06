# Tmux(p) integration in nvim
Pretty simple and somewhat redundant right now.
## Installation
`Lazy`
```lua
  cmd = {
    "TmuxpNewWindow",
    "TmuxpList",
  },
  keys = {
    {
      "<leader>m",
      mode = { "n" },
      "<cmd>TmuxpList<cr>",
      desc = "List tmux windows",
    },
    {
      "<leader>mn",
      mode = { "n" },

      "<cmd>TmuxpNewWindow<cr>",
      desc = "New tmux window",
    },
  },
}


```
