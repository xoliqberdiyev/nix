{ config, pkgs, ... }:

{
  programs.neovim = {
    enable = true;
    defaultEditor = true; # Neovim ni default editor qilish
    viAlias = true; # vi buyrug'i ham neovim ni ochadi
    vimAlias = true; # vim buyrug'i ham neovim ni ochadi
    vimdiffAlias = true; # vimdiff buyrug'i ham neovim ni ishlatadi

    # Qo'shimcha paketlar (LSP, formatters, va h.k.)
    extraPackages = with pkgs; [
      # LSP servers
      lua-language-server
      nil # Nix LSP
      nodePackages.typescript-language-server
      nodePackages.vscode-langservers-extracted # HTML, CSS, JSON
      rust-analyzer
      gopls # Go
      pyright # Python LSP

      # Formatters
      stylua # Lua formatter
      alejandra # Nix formatter
      nodePackages.prettier # JS/TS/JSON formatter
      black # Python formatter
      isort # Python import formatter

      # Linters
      ruff # Python linter

      # Tools
      ripgrep # Tez qidiruv
      fd # Tez fayl qidiruv
      tree-sitter
    ];

    plugins = with pkgs.vimPlugins; [
      # Plugin manager
      lazy-nvim

      # Color schemes
      gruvbox-nvim
      tokyonight-nvim
      catppuccin-nvim

      # File explorer
      nvim-tree-lua
      nvim-web-devicons

      # Fuzzy finder
      telescope-nvim
      telescope-fzf-native-nvim

      # LSP va completion
      nvim-lspconfig
      nvim-cmp
      cmp-nvim-lsp
      cmp-buffer
      cmp-path
      cmp-cmdline
      luasnip
      cmp_luasnip
      friendly-snippets

      # Treesitter
      (nvim-treesitter.withPlugins (p: [
        p.lua
        p.vim
        p.vimdoc
        p.nix
        p.python
        p.javascript
        p.typescript
        p.rust
        p.go
        p.html
        p.css
        p.json
        p.markdown
        p.bash
      ]))
      nvim-treesitter-textobjects

      # Git integration
      gitsigns-nvim
      vim-fugitive

      # Status line
      lualine-nvim

      # Buffer line
      bufferline-nvim

      # Auto pairs
      nvim-autopairs

      # Comments
      comment-nvim

      # Indent guides
      indent-blankline-nvim

      # Which-key (klaviatura qisqartmalarini ko'rsatadi)
      which-key-nvim

      # Terminal
      toggleterm-nvim

      # Dashboard
      alpha-nvim

      # Utilities
      plenary-nvim
      nvim-notify
      dressing-nvim
    ];

    # Neovim konfiguratsiyasi
    extraLuaConfig = ''
      vim.deprecate = function() end

      -- Leader key
      vim.g.mapleader = " "
      vim.g.maplocalleader = " "

      -- Basic settings
      vim.opt.number = true
      vim.opt.relativenumber = true
      vim.opt.mouse = 'a'
      vim.opt.ignorecase = true
      vim.opt.smartcase = true
      vim.opt.hlsearch = false
      vim.opt.wrap = false
      vim.opt.breakindent = true
      vim.opt.tabstop = 2
      vim.opt.shiftwidth = 2
      vim.opt.expandtab = true
      vim.opt.termguicolors = true
      vim.opt.signcolumn = "yes"
      vim.opt.updatetime = 250
      vim.opt.timeoutlen = 300
      vim.opt.completeopt = "menuone,noselect"
      vim.opt.clipboard = "unnamedplus"

      -- Color scheme
      vim.cmd([[colorscheme gruvbox]])

      -- Nvim-tree setup
      require("nvim-tree").setup()

      -- Lualine setup
      require('lualine').setup {
        options = {
          theme = 'gruvbox',
          component_separators = '|',
        }
      }

      -- Bufferline setup
      require("bufferline").setup{}

      -- Autopairs setup
      require("nvim-autopairs").setup{}

      -- Comment setup
      require('Comment').setup()

      -- Indent blankline setup
      require("ibl").setup()

      -- Gitsigns setup
      require('gitsigns').setup()

      -- Telescope setup
      require('telescope').setup()

      -- Which-key setup
      require("which-key").setup()

      -- Alpha (dashboard) setup
      require('alpha').setup(require('alpha.themes.dashboard').config)

      -- Treesitter setup
      require('nvim-treesitter.configs').setup {
        highlight = { enable = true },
        indent = { enable = true },
      }

      -- LSP setup
      local lspconfig = require('lspconfig')
      local capabilities = require('cmp_nvim_lsp').default_capabilities()

      lspconfig.lua_ls.setup {
        capabilities = capabilities,
        settings = {
          Lua = {
            diagnostics = { globals = { 'vim' } },
          },
        },
      }

      lspconfig.nil_ls.setup { capabilities = capabilities }
      lspconfig.ts_ls.setup { capabilities = capabilities }
      lspconfig.rust_analyzer.setup { capabilities = capabilities }
      lspconfig.gopls.setup { capabilities = capabilities }

      lspconfig.html.setup { capabilities = capabilities }
      lspconfig.cssls.setup { capabilities = capabilities }
      lspconfig.jsonls.setup { capabilities = capabilities }

      lspconfig.pyright.setup {
        capabilities = capabilities,
        settings = {
          python = {
            analysis = {
              typeCheckingMode = "basic",
              autoSearchPaths = true,
              useLibraryCodeForTypes = true,
            },
          },
        },
      }

      -- Lua LSP
      lspconfig.lua_ls.setup {
        capabilities = capabilities,
        settings = {
          Lua = {
            diagnostics = { globals = { 'vim' } }
          }
        }
      }

      -- Nix LSP
      lspconfig.nil_ls.setup { capabilities = capabilities }

      -- TypeScript LSP
      lspconfig.ts_ls.setup { capabilities = capabilities }

      -- Rust LSP
      lspconfig.rust_analyzer.setup { capabilities = capabilities }

      -- Go LSP
      lspconfig.gopls.setup { capabilities = capabilities }

      -- HTML/CSS/JSON LSP
      lspconfig.html.setup { capabilities = capabilities }
      lspconfig.cssls.setup { capabilities = capabilities }
      lspconfig.jsonls.setup { capabilities = capabilities }

      -- Python LSP
      lspconfig.pyright.setup {
        capabilities = capabilities,
        settings = {
          python = {
            analysis = {
              typeCheckingMode = "basic",
              autoSearchPaths = true,
              useLibraryCodeForTypes = true,
            }
          }
        }
      }

      -- Completion setup
      local cmp = require('cmp')
      local luasnip = require('luasnip')

      cmp.setup({
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ['<C-d>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),
          ['<C-Space>'] = cmp.mapping.complete(),
          ['<CR>'] = cmp.mapping.confirm({ select = true }),
          ['<Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            else
              fallback()
            end
          end, { 'i', 's' }),
        }),
        sources = {
          { name = 'nvim_lsp' },
          { name = 'luasnip' },
          { name = 'buffer' },
          { name = 'path' },
        },
      })

      -- Key mappings
      local map = vim.keymap.set

      -- File explorer
      map('n', '<leader>e', ':NvimTreeToggle<CR>', { desc = 'Toggle file explorer' })

      -- Telescope
      map('n', '<leader>ff', '<cmd>Telescope find_files<cr>', { desc = 'Find files' })
      map('n', '<leader>fg', '<cmd>Telescope live_grep<cr>', { desc = 'Live grep' })
      map('n', '<leader>fb', '<cmd>Telescope buffers<cr>', { desc = 'Find buffers' })
      map('n', '<leader>fh', '<cmd>Telescope help_tags<cr>', { desc = 'Help tags' })

      -- Buffer navigation
      map('n', '<S-l>', ':BufferLineCycleNext<CR>', { desc = 'Next buffer' })
      map('n', '<S-h>', ':BufferLineCyclePrev<CR>', { desc = 'Previous buffer' })
      map('n', '<leader>bd', ':bdelete<CR>', { desc = 'Delete buffer' })

      -- Window navigation
      map('n', '<C-h>', '<C-w>h', { desc = 'Window left' })
      map('n', '<C-j>', '<C-w>j', { desc = 'Window down' })
      map('n', '<C-k>', '<C-w>k', { desc = 'Window up' })
      map('n', '<C-l>', '<C-w>l', { desc = 'Window right' })

      -- LSP keymaps
      map('n', 'gD', vim.lsp.buf.declaration, { desc = 'Go to declaration' })
      map('n', 'gd', vim.lsp.buf.definition, { desc = 'Go to definition' })
      map('n', 'K', vim.lsp.buf.hover, { desc = 'Hover documentation' })
      map('n', 'gi', vim.lsp.buf.implementation, { desc = 'Go to implementation' })
      map('n', '<leader>ca', vim.lsp.buf.code_action, { desc = 'Code action' })
      map('n', '<leader>rn', vim.lsp.buf.rename, { desc = 'Rename' })
      map('n', '<leader>f', vim.lsp.buf.format, { desc = 'Format' })

      -- Save file
      map('n', '<C-s>', ':w<CR>', { desc = 'Save file' })

      -- Quit
      map('n', '<leader>q', ':q<CR>', { desc = 'Quit' })
    '';
  };
}

