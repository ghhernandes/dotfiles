--require("gruvbox").setup({
--    undercurl = true,
--    underline = true,
--    bold = false,
--    italic = {
--        strings = true,
--        operators = true,
--        comments = true,
--    },
--    strikethrough = true,
--    invert_selection = false,
--    invert_signs = false,
--    invert_tabline = false,
--    invert_intend_guides = false,
--    inverse = true, -- invert background for search, diffs, statuslines and errors
--    contrast = "hard",  -- can be "hard", "soft" or empty string
--    palette_overrides = {},
--    overrides = {},
--    dim_inactive = false,
--    transparent_mode = true,
--})

function MyColors(color)
    color = color or "gruvbox"
    vim.cmd.colorscheme(color)
end

MyColors("retrobox")
