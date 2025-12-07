final: prev: {
  vimPlugins = prev.vimPlugins // {
    eca-nvim = prev.vimUtils.buildVimPlugin {
      pname = "eca-nvim";
      version = "unstable";

      src = prev.fetchFromGitHub {
        owner = "editor-code-assistant";
        repo = "eca-nvim";
        rev = "ff230d69c013137a8f66ee16376756a2a95b03f5";
        sha256 = "sha256-BcUTHbVtosTRutgcxIOdGEIxRwC8eNtn+VS5M1I0Z/E=";
      };

      # Skip modules that have runtime dependencies (nui.nvim, nvim-cmp)
      # These will be available at runtime in neovim but not during build
      nvimSkipModule = [
        "eca"
        "eca.api"
        "eca.sidebar"
        "eca.completion.cmp.context"
      ];

      meta = with prev.lib; {
        description = "Editor Code Assistant for Neovim";
        homepage = "https://github.com/editor-code-assistant/eca-nvim";
        license = licenses.mit;
        platforms = platforms.all;
      };
    };
  };
}
