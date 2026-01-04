{ config, pkgs, dotfilesPath, ... }:

{
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;

    # LSP servers and tools managed by Nix
    extraPackages = [
      pkgs.gopls
      pkgs.clojure-lsp
      pkgs.nixd

      # pkgs.lua-language-server
      # pkgs.rust-analyzer
      # pkgs.typescript-language-server
    ];

    plugins = let p = pkgs.vimPlugins; in [
      p.plenary-nvim

      p.nvim-lspconfig

      # Completion
      p.nvim-cmp
      p.cmp-nvim-lsp
      p.cmp_luasnip
      p.luasnip

      p.dracula-nvim
      p.tokyonight-nvim
      p.lualine-nvim

      # Navigation
      p.flash-nvim
      p.harpoon2
      p.telescope-nvim
      p.telescope-fzf-native-nvim
      p.nvim-spectre
      p.trouble-nvim

      # Treesitter
      p.nvim-treesitter.withAllGrammars
      p.nvim-treesitter-refactor

      # Git
      p.vim-fugitive
      p.diffview-nvim

      # Clojure
      p.conjure
      p.vim-sexp
      p.vim-sexp-mappings-for-regular-people
    ];
  };

  xdg.configFile."nvim" = {
    source = "${dotfilesPath}/nvim";
    recursive = true;
  };
}
