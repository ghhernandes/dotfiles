{ config, pkgs, ... }:

{
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;

    # LSP servers and tools managed by Nix
    extraPackages = with pkgs; [
      gopls
      clojure-lsp
      nixd

      # lua-language-server
      # rust-analyzer
      # typescript-language-server
    ];

    plugins = with pkgs.vimPlugins; [
      plenary-nvim

      nvim-lspconfig

      # Completion
      nvim-cmp
      cmp-nvim-lsp
      cmp_luasnip
      luasnip

      # Navigation
      harpoon2
      telescope-nvim
      telescope-fzf-native-nvim
      nvim-spectre

      # Treesitter
      nvim-treesitter.withAllGrammars
      nvim-treesitter-refactor

      # Git
      vim-fugitive
      undotree

      # Clojure
      conjure
      { plugin = vim-sexp; optional = true; }  # Lazy-loaded for Clojure
      { plugin = vim-sexp-mappings-for-regular-people; optional = true; }

    ];
  };

  xdg.configFile."nvim" = {
    source = ../../../nvim;
    recursive = true;
  };
}
