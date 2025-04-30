# bloat.nvim

bloat.nvim - Neovim plugin to analyze and visualize code size of used plugins to uncover bloat.

| | |
| - | - |
| ![Sunburst visualization](https://github.com/user-attachments/assets/f162384f-b543-47d6-8ebe-73298ac5922b) | ![Treemap visualization](https://github.com/user-attachments/assets/5196a92a-8c63-4f15-a823-4c5fb3f2a95d) |

There is one universal principle in nature as well as in maintaining a neovim config: the cycle of expansion and contraction.

- 🚀 The Expansion phase is about enabling more use cases and features by adding plugins.
- 📉 The Contraction is about confronting reality,
seeing what sticks and is useful in practice,
then bringing the complexity down again by removing excess bloat.

When comparing which plugin to use,
it's not just about which one has more features.
Instead, given a set of useful features,
consider which plugin achieves them with less complexity and fewer lines of code.

The plugin works by taking a list of installed plugins managed by lazy.nvim and exporting a metafile that is visualized using [esbuild bundle analyzer](https://esbuild.github.io/analyze/).

## Install


Using [lazy.nvim](https://github.com/folke/lazy.nvim):

```lua
{
  "dundalek/bloat.nvim",
  cmd = "Bloat",
},
```

## Use

1. Run the `:Bloat` command to generate the analysis file.  
   The default output location is `/home/$USER/nvim-bloat-analysis.json`.

2. Go to [esbuild.github.io/analyze](https://esbuild.github.io/analyze/) and load the analysis file to visualize.

Details:

You can specify another output path: `:Bloat some/path/analysis.json`.

The analysis can also be generated from lua using: `require("bloat").analyze()`.

### Limitations

- Reports only size in bytes which includes comments, it does not count lines.
  - Idea: Optionally parse sources with [tokei](https://github.com/XAMPPRocky/tokei) if available?
- Counts all source files. Imports are not parsed, therefore files are included even when they might not be loaded at runtime.
