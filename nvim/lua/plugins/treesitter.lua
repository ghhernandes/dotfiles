require 'nvim-treesitter.configs'.setup {
    -- A list of parser names, or "all"
    ensure_installed = { 'go', 'python', 'rust' },
    -- Install parsers synchronously (only applied to `ensure_installed`)
    sync_install = false,

    -- Automatically install missing parsers when entering buffer
    -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
    auto_install = true,

    highlight = {
        -- `false` will disable the whole extension
        enable = true,

        -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
        -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
        -- Using this option may slow down your editor, and you may see some duplicate highlights.
        -- Instead of true it can also be a list of languages
        additional_vim_regex_highlighting = false,
    },

    indent = { enabled = true },

    incremental_selection = {
        enable = true,
        keymaps = {
            init_selection = "<C-space>",
            node_incremental = "<C-space>",
            scope_incremental = false,
            node_decremental = "<bs>",
        },
    },

    refactor = {
        smart_rename = {
            enable = true,
            keymaps = {
                smart_rename = "<leader>grr",
            },
        },

        highlight_definitions = {
            enable = true,
            clear_on_cursor_move = true,
        },

        navigation = {
            enable = true,
            -- Assign keymaps to false to disable them, e.g. `goto_definition = false`.
            keymaps = {
                goto_definition = "gd",
                list_definitions = "gD",
                list_definitions_toc = "gO",
                goto_next_usage = "<a-*>",
                goto_previous_usage = "<a-#>",
            },
        },

    }
}
