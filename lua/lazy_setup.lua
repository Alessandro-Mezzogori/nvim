require("lazy").setup({
    {
      "AstroNvim/AstroNvim",
      version = "^4",                -- Remove version tracking to elect for nighly AstroNvim
      import = "astronvim.plugins",
      opts = {                       -- AstroNvim options must be set here with the `import` key
        mapleader = " ",             -- This ensures the leader key must be configured before Lazy is set up
        maplocalleader = ",",        -- This ensures the localleader key must be configured before Lazy is set up
        icons_enabled = true,        -- Set to false to disable icons (if no Nerd Font is available)
        pin_plugins = nil,           -- Default will pin plugins when tracking `version` of AstroNvim, set to true/false to override
        update_notifications = true, -- Enable/disable notification about running `:Lazy update` twice to update pinned plugins
      },
    },
    {
      "otavioschwanck/arrow.nvim",
      opts = {
        show_icons = true,
        leader_key = ';',        -- Recommended to be a single key
        buffer_leader_key = 'm', -- Per Buffer Mappings
      }
    },
    {
      'nvim-telescope/telescope.nvim',
      opts = function(_, opts)
        opts.pickers = opts.pickers or {};

        -- TODO: remove workaround when telescope is fixed with plenary.path2
        opts.pickers.find_files = {
          hidden = true,
          find_command = {
            'rg',
            '--files',
            '--color=never',
            '--no-heading',
            '--line-number',
            '--column',
            '--smart-case',
            '--hidden',
            '--glob',
            '!{.git/*,.svelte-kit/*,target/*,node_modules/*}',
            '--path-separator',
            '/',
          }
        }

        opts.pickers.live_grep = {
          hidden = true,
          additional_args = {
            '--path-separator',
            '/',
          }
        }

        opts.pickers.grep_string = {
          hidden = true,
          additional_args = {
            '--path-separator',
            '/',
          }
        }
      end
    },
    { import = "community" },
    { import = "plugins" },
  } --[[@as LazySpec]],
  {
    -- Configure any other `lazy.nvim` configuration options here
    install = { colorscheme = { "astrodark", "habamax" } },
    ui = { backdrop = 100 },
    performance = {
      rtp = {
        -- disable some rtp plugins, add more to your liking
        disabled_plugins = {
          "gzip",
          "netrwPlugin",
          "tarPlugin",
          "tohtml",
          "zipPlugin",
        },
      },
    },
  } --[[@as LazyConfig]])
