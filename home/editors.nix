{ config, pkgs, ... }:
{
  # ========================================================================
  # VS CODE
  # ========================================================================
  
  programs.vscode = {
    enable = true;
    
    profiles.default = {
      extensions = with pkgs.vscode-extensions; [
        # Theme
        jdinhlife.gruvbox
        
        # Core
        vscodevim.vim
        esbenp.prettier-vscode
        
        # Languages
        bbenoist.nix
        ms-python.python
        rust-lang.rust-analyzer
        bradlc.vscode-tailwindcss
        
        # Utilities
        eamodio.gitlens
        usernamehw.errorlens
        pkief.material-icon-theme
      ];
      
      userSettings = {
        # Theme
        "workbench.colorTheme" = "Gruvbox Dark Hard";
        "workbench.iconTheme" = "material-icon-theme";
        
        # Font
        "editor.fontFamily" = "'JetBrainsMono Nerd Font', 'JetBrains Mono', 'Fira Code', monospace";
        "editor.fontSize" = 14;
        "editor.fontLigatures" = true;
        "terminal.integrated.fontFamily" = "JetBrainsMono Nerd Font";
        "terminal.integrated.fontSize" = 13;
        
        # Editor
        "editor.minimap.enabled" = false;
        "editor.lineNumbers" = "relative";
        "editor.cursorBlinking" = "smooth";
        "editor.cursorSmoothCaretAnimation" = "on";
        "editor.smoothScrolling" = true;
        "editor.renderWhitespace" = "selection";
        "editor.bracketPairColorization.enabled" = true;
        "editor.guides.bracketPairs" = "active";
        "editor.tabSize" = 2;
        "editor.formatOnSave" = true;
        
        # Window
        "window.titleBarStyle" = "custom";
        "window.menuBarVisibility" = "toggle";
        
        # Files
        "files.autoSave" = "afterDelay";
        "files.autoSaveDelay" = 1000;
        
        # Terminal
        "terminal.integrated.defaultProfile.linux" = "zsh";
        
        # Vim
        "vim.leader" = "<space>";
        "vim.hlsearch" = true;
        "vim.useSystemClipboard" = true;
        
        # Nix
        "nix.enableLanguageServer" = true;
      };
      
      keybindings = [
        {
          key = "ctrl+h";
          command = "workbench.action.navigateLeft";
        }
        {
          key = "ctrl+l";
          command = "workbench.action.navigateRight";
        }
        {
          key = "ctrl+j";
          command = "workbench.action.navigateDown";
        }
        {
          key = "ctrl+k";
          command = "workbench.action.navigateUp";
        }
      ];
    };
  };
  
  # ========================================================================
  # NEOVIM
  # ========================================================================
  
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
    
    plugins = with pkgs.vimPlugins; [
      # Package manager
      lazy-nvim
      
      # Core
      plenary-nvim
      
      # Theme
      gruvbox-nvim
      
      # UI
      lualine-nvim
      bufferline-nvim
      nvim-web-devicons
      indent-blankline-nvim
      
      # Treesitter
      nvim-treesitter.withAllGrammars
      nvim-treesitter-textobjects
      
      # LSP
      nvim-lspconfig
      mason-nvim
      mason-lspconfig-nvim
      
      # Completion
      nvim-cmp
      cmp-nvim-lsp
      cmp-buffer
      cmp-path
      cmp-cmdline
      luasnip
      cmp_luasnip
      friendly-snippets
      
      # Tools
      telescope-nvim
      telescope-fzf-native-nvim
      neo-tree-nvim
      gitsigns-nvim
      which-key-nvim
      comment-nvim
      nvim-autopairs
      nvim-surround
      toggleterm-nvim
      
      # Nix
      vim-nix
    ];
    
    extraLuaConfig = ''
      -- ====================================================================
      -- GENERAL SETTINGS
      -- ====================================================================
      vim.g.mapleader = " "
      vim.g.maplocalleader = " "
      
      local opt = vim.opt
      
      opt.number = true
      opt.relativenumber = true
      opt.tabstop = 2
      opt.shiftwidth = 2
      opt.expandtab = true
      opt.smartindent = true
      opt.wrap = false
      opt.cursorline = true
      opt.signcolumn = "yes"
      opt.termguicolors = true
      opt.showmode = false
      opt.clipboard = "unnamedplus"
      opt.splitright = true
      opt.splitbelow = true
      opt.ignorecase = true
      opt.smartcase = true
      opt.scrolloff = 8
      opt.sidescrolloff = 8
      opt.updatetime = 250
      opt.timeoutlen = 300
      opt.undofile = true
      opt.mouse = "a"
      
      -- Neovide font
      opt.guifont = "JetBrainsMono Nerd Font:h12"
      
      -- ====================================================================
      -- GRUVBOX THEME
      -- ====================================================================
      require("gruvbox").setup({
        contrast = "hard",
        transparent_mode = false,
        italic = {
          strings = false,
          comments = true,
          operators = false,
        },
      })
      vim.cmd.colorscheme("gruvbox")
      vim.opt.background = "dark"
      
      -- ====================================================================
      -- LUALINE
      -- ====================================================================
      require("lualine").setup({
        options = {
          theme = "gruvbox",
          component_separators = { left = "", right = "" },
          section_separators = { left = "", right = "" },
        },
      })
      
      -- ====================================================================
      -- BUFFERLINE
      -- ====================================================================
      require("bufferline").setup({
        options = {
          mode = "buffers",
          diagnostics = "nvim_lsp",
          separator_style = "thin",
        },
      })
      
      -- ====================================================================
      -- TREESITTER
      -- ====================================================================
      require("nvim-treesitter.configs").setup({
        highlight = { enable = true },
        indent = { enable = true },
      })
      
      -- ====================================================================
      -- TELESCOPE
      -- ====================================================================
      local telescope = require("telescope")
      telescope.setup({
        defaults = {
          prompt_prefix = "   ",
          selection_caret = " ",
        },
      })
      
      -- ====================================================================
      -- NEOTREE
      -- ====================================================================
      require("neo-tree").setup({
        close_if_last_window = true,
        window = { width = 30 },
      })
      
      -- ====================================================================
      -- GITSIGNS
      -- ====================================================================
      require("gitsigns").setup()
      
      -- ====================================================================
      -- WHICH-KEY
      -- ====================================================================
      require("which-key").setup()
      
      -- ====================================================================
      -- COMMENT
      -- ====================================================================
      require("Comment").setup()
      
      -- ====================================================================
      -- AUTOPAIRS
      -- ====================================================================
      require("nvim-autopairs").setup()
      
      -- ====================================================================
      -- LSP
      -- ====================================================================
      local lspconfig = require("lspconfig")
      local capabilities = require("cmp_nvim_lsp").default_capabilities()
      
      -- Nix
      lspconfig.nil_ls.setup({ capabilities = capabilities })
      
      -- Lua
      lspconfig.lua_ls.setup({ capabilities = capabilities })
      
      -- Python
      lspconfig.pyright.setup({ capabilities = capabilities })
      
      -- Rust
      lspconfig.rust_analyzer.setup({ capabilities = capabilities })
      
      -- ====================================================================
      -- COMPLETION
      -- ====================================================================
      local cmp = require("cmp")
      local luasnip = require("luasnip")
      
      require("luasnip.loaders.from_vscode").lazy_load()
      
      cmp.setup({
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-e>"] = cmp.mapping.abort(),
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback()
            end
          end, { "i", "s" }),
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "luasnip" },
          { name = "buffer" },
          { name = "path" },
        }),
      })
      
      -- ====================================================================
      -- KEYMAPS
      -- ====================================================================
      local keymap = vim.keymap.set
      
      -- File explorer
      keymap("n", "<leader>e", "<cmd>Neotree toggle<cr>", { desc = "Toggle Explorer" })
      
      -- Telescope
      keymap("n", "<leader>ff", "<cmd>Telescope find_files<cr>", { desc = "Find Files" })
      keymap("n", "<leader>fg", "<cmd>Telescope live_grep<cr>", { desc = "Live Grep" })
      keymap("n", "<leader>fb", "<cmd>Telescope buffers<cr>", { desc = "Buffers" })
      keymap("n", "<leader>fh", "<cmd>Telescope help_tags<cr>", { desc = "Help Tags" })
      
      -- Buffers
      keymap("n", "<S-l>", "<cmd>BufferLineCycleNext<cr>", { desc = "Next Buffer" })
      keymap("n", "<S-h>", "<cmd>BufferLineCyclePrev<cr>", { desc = "Prev Buffer" })
      keymap("n", "<leader>bd", "<cmd>bdelete<cr>", { desc = "Delete Buffer" })
      
      -- Window navigation
      keymap("n", "<C-h>", "<C-w>h", { desc = "Go Left" })
      keymap("n", "<C-j>", "<C-w>j", { desc = "Go Down" })
      keymap("n", "<C-k>", "<C-w>k", { desc = "Go Up" })
      keymap("n", "<C-l>", "<C-w>l", { desc = "Go Right" })
      
      -- Save
      keymap("n", "<leader>w", "<cmd>w<cr>", { desc = "Save" })
      keymap("n", "<leader>q", "<cmd>q<cr>", { desc = "Quit" })
      
      -- Clear highlights
      keymap("n", "<Esc>", "<cmd>nohlsearch<cr>", { desc = "Clear Highlights" })
    '';
  };
  
  # ========================================================================
  # HELIX EDITOR
  # ========================================================================
  
  programs.helix = {
    enable = true;
    
    settings = {
      theme = "gruvbox";
      
      editor = {
        line-number = "relative";
        mouse = true;
        cursorline = true;
        auto-completion = true;
        auto-format = true;
        color-modes = true;
        bufferline = "multiple";
        true-color = true;
        rulers = [ 80 120 ];
        
        cursor-shape = {
          insert = "bar";
          normal = "block";
          select = "underline";
        };
        
        statusline = {
          left = [ "mode" "spinner" "file-name" "file-modification-indicator" ];
          center = [];
          right = [ "diagnostics" "selections" "register" "position" "file-encoding" ];
          separator = "│";
          mode = {
            normal = "NORMAL";
            insert = "INSERT";
            select = "SELECT";
          };
        };
        
        lsp = {
          display-messages = true;
          display-inlay-hints = true;
          snippets = true;
        };
        
        indent-guides = {
          render = true;
          character = "│";
          skip-levels = 1;
        };
        
        soft-wrap = {
          enable = false;
        };
        
        file-picker = {
          hidden = false;
        };
      };
      
      keys = {
        normal = {
          space = {
            w = ":write";
            q = ":quit";
            f = "file_picker";
            b = "buffer_picker";
            "/" = "global_search";
            g = {
              g = "goto_file_start";
              e = "goto_file_end";
            };
          };
          
          # Window navigation like vim
          "C-h" = "jump_view_left";
          "C-j" = "jump_view_down";
          "C-k" = "jump_view_up";
          "C-l" = "jump_view_right";
          
          # Buffer navigation
          "S-l" = "goto_next_buffer";
          "S-h" = "goto_previous_buffer";
        };
        
        insert = {
          "C-space" = "completion";
        };
      };
    };
    
    languages = {
      language-server = {
        nil = {
          command = "nil";
          config.nil.formatting.command = [ "nixpkgs-fmt" ];
        };
        
        pyright = {
          command = "pyright-langserver";
          args = [ "--stdio" ];
        };
        
        rust-analyzer = {
          command = "rust-analyzer";
          config.check.command = "clippy";
        };
      };
      
      language = [
        {
          name = "nix";
          auto-format = true;
          language-servers = [ "nil" ];
          formatter = { command = "nixpkgs-fmt"; };
        }
        {
          name = "rust";
          auto-format = true;
          language-servers = [ "rust-analyzer" ];
        }
        {
          name = "python";
          auto-format = true;
          language-servers = [ "pyright" ];
          formatter = { command = "black"; args = [ "-" ]; };
        }
        {
          name = "javascript";
          auto-format = true;
          formatter = { command = "prettier"; args = [ "--parser" "javascript" ]; };
        }
        {
          name = "typescript";
          auto-format = true;
          formatter = { command = "prettier"; args = [ "--parser" "typescript" ]; };
        }
        {
          name = "json";
          auto-format = true;
          formatter = { command = "prettier"; args = [ "--parser" "json" ]; };
        }
      ];
    };
  };
  
  # ========================================================================
  # LSP SERVERS
  # ========================================================================
  home.packages = with pkgs; [
    # Nix
    nil
    nixpkgs-fmt
    
    # Python
    pyright
    black
    
    # Rust
    rust-analyzer
    
    # JavaScript/TypeScript
    nodePackages.typescript-language-server
    nodePackages.prettier
    
    # Lua
    lua-language-server
    
    # General
    nodePackages.vscode-langservers-extracted
  ];
}
