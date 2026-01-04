{ config, pkgs, dotfilesPath, ... }:

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

      dracula-nvim
      tokyonight-nvim
      lualine-nvim

      # Navigation
      flash-nvim
      harpoon2
      telescope-nvim
      telescope-fzf-native-nvim
      nvim-spectre
      trouble-nvim

      # Treesitter
      nvim-treesitter.withAllGrammars
      nvim-treesitter-refactor

      # Git
      vim-fugitive
      diffview-nvim

      # Clojure
      conjure
      vim-sexp
      vim-sexp-mappings-for-regular-people
    ];
  };

  xdg.configFile."nvim" = {
    source = "${dotfilesPath}/nvim";
    recursive = true;
  };
}
