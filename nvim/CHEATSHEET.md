# Neovim Config Cheatsheet

## Plugins

| Plugin                      | Purpose                                                               |
| --------------------------- | --------------------------------------------------------------------- |
| `lazy.nvim`                 | Plugin manager                                                        |
| `mason.nvim`                | Installs and manages LSP servers and tools                            |
| `mason-lspconfig.nvim`      | Bridges Mason with nvim-lspconfig                                     |
| `mason-tool-installer.nvim` | Auto-installs formatters (stylua, prettier)                           |
| `lazydev.nvim`              | Neovim Lua API completions (with luvit-meta for vim.uv types)         |
| `nvim-lspconfig`            | Configures LSP servers (lua_ls, ts_ls, pyright)                       |
| `nvim-treesitter`           | Syntax highlighting and indentation                                   |
| `blink.cmp`                 | Autocomplete engine (LSP, buffer, path, snippets)                     |
| `conform.nvim`              | Format on save (stylua, prettier)                                     |
| `markview.nvim`             | Inline markdown rendering (headings, tables, checkboxes, code blocks) |
| `bullets.vim`               | Auto-continue lists, auto-numbering, checkbox toggling                |
| `markdowny.nvim`            | Markdown formatting keymaps (bold, italic, code, link)                |

## LSP Servers

| Server    | Language                |
| --------- | ----------------------- |
| `lua_ls`  | Lua                     |
| `ts_ls`   | JavaScript / TypeScript |
| `pyright` | Python                  |

## Formatters

| Formatter  | Language                                  |
| ---------- | ----------------------------------------- |
| `stylua`   | Lua                                       |
| `prettier` | JavaScript, TypeScript, JSON, Markdown    |
| `black`    | Python (disabled — requires python3-venv) |

## Key Notation

| Notation | Meaning |
| -------- | ------- |
| `<C-x>`  | Ctrl + x |
| `<S-x>`  | Shift + x |
| `<A-x>`  | Alt + x |
| `<CR>`   | Enter (Carriage Return) |
| `<Tab>`  | Tab key |
| `<Esc>`  | Escape key |

## Key Bindings

### Autocomplete (blink.cmp)

| Key         | Action                       |
| ----------- | ---------------------------- |
| `<C-Space>` | Trigger completion           |
| `<CR>`      | Confirm selected completion  |
| `<Tab>`     | Next completion item         |
| `<S-Tab>`   | Previous completion item     |
| `<C-e>`     | Cancel completion            |

### Commenting (built-in, Neovim 0.10+)

| Key           | Action                                     |
| ------------- | ------------------------------------------ |
| `gcc`         | Toggle comment on current line             |
| `gc` + motion | Toggle comment over a motion (e.g. `gc5j`) |
| `gc`          | Toggle comment on visual selection         |

### File Explorer (built-in netrw)

| Key / Command | Action                                  |
| ------------- | --------------------------------------- |
| `:Ex`         | Open file explorer in current directory |
| `:Explore`    | Same as `:Ex`                           |
| `Enter`       | Open file or directory                  |

### Markdown — bullets.vim (markdown files only)

| Key / Action              | Behaviour                              |
| ------------------------- | -------------------------------------- |
| `<Enter>` in list         | Continues bullet / number on next line |
| `<Enter>` on empty bullet | Exits the list                         |
| `<C-t>`                   | Indent list item                       |
| `<C-d>`                   | Outdent list item                      |

### Markdown — markdowny.nvim (visual mode, markdown files only)

| Key     | Action                     |
| ------- | -------------------------- |
| `<C-b>` | Bold (`**text**`)          |
| `<C-i>` | Italic (`*text*`)          |
| `<C-e>` | Inline code (`` `text` ``) |
| `<C-k>` | Link (`[text](url)`)       |

## Theme

`wildcharm` (built-in)

## Leader Key

`\` (default, not explicitly set)
