{
  pkgs,
  dotfilesPath,
  ...
}:

let
  # Elin isn't packaged in nixpkgs, so build it from source. It ships its
  # Babashka/Clojure backend (bb.edn, src/, resources/) alongside the Vim
  # files; buildVimPlugin copies the whole tree, and `g:elin_home` resolves
  # to this store path at runtime (Babashka writes its classpath cache
  # outside the read-only store, so this works fine).
  elin = pkgs.vimUtils.buildVimPlugin {
    pname = "elin";
    version = "2026.01.0-alpha";
    src = pkgs.fetchFromGitHub {
      owner = "liquidz";
      repo = "elin";
      rev = "2026.01.0-alpha";
      hash = "sha256-ycA0aOYMW+lWVTHK954NbtAudqZjdS602WhSTzGjNLk=";
    };
    # Pure runtime files (vimscript + bb scripts); nothing to require-check.
    doCheck = false;
  };

  # The `elin` utility command (https://liquidz.github.io/elin/). The script
  # shipped in the plugin locates the elin source relative to its own path, so
  # we exec it from the store rather than symlinking. babashka + clj-kondo are
  # baked onto its PATH so it works from any shell.
  elin-cli = pkgs.writeShellApplication {
    name = "elin";
    runtimeInputs = [
      pkgs.babashka
      pkgs.clj-kondo
    ];
    text = ''exec ${elin}/bin/elin "$@"'';
  };
in
{
  home.packages = [ elin-cli ];

  programs.neovim = {
    package = pkgs.neovim-unwrapped;
    enable = true;
    withRuby = false;
    withPython3 = false;
    viAlias = true;
    vimAlias = true;

    # LSP servers and tools managed by Nix
    extraPackages = [
      pkgs.gopls
      pkgs.clojure-lsp
      pkgs.nixd
      pkgs.dart
      pkgs.pyright
      pkgs.ruff

      # Elin (Clojure dev environment) backend + linter
      pkgs.babashka
      pkgs.clj-kondo

      # pkgs.lua-language-server
      # pkgs.rust-analyzer
      # pkgs.typescript-language-server
    ];

    plugins =
      let
        p = pkgs.vimPlugins;
      in
      [
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
        (p.nvim-treesitter.withPlugins (g: [
          g.go
          g.gomod
          g.gowork
          g.gosum
          g.clojure
          g.nix
          g.dart
          g.python
          g.typescript
          g.javascript
          g.tsx
          g.jsdoc
          g.lua
          g.vim
          g.vimdoc
          g.query
          g.bash
          g.json
          g.yaml
          g.toml
          g.markdown
          g.markdown_inline
          g.regex
          g.diff
          g.gitcommit
        ]))

        # Git
        p.vim-fugitive
        p.diffview-nvim

        # Claude Code
        p.claudecode-nvim

        # Clojure
        elin
        p.vim-sexp
        p.vim-sexp-mappings-for-regular-people
      ];
  };

  xdg.configFile."nvim" = {
    source = "${dotfilesPath}/nvim";
    recursive = true;
  };
}
