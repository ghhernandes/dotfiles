{ pkgs, ... }:

{
  home.packages = [
    pkgs.ghidra

    # Build tooling for ghidra-mcp's Maven-built Java extension.
    pkgs.jdk21
    pkgs.maven

    # Python env for ghidra-mcp's MCP bridge (bridge_mcp_ghidra.py).
    (pkgs.python3.withPackages (ps: with ps; [
      mcp
      requests
    ]))
  ];

  # ghidra-mcp (https://github.com/bethington/ghidra-mcp) is not in nixpkgs.
  # One-time manual install:
  #   git clone https://github.com/bethington/ghidra-mcp.git ~/src/ghidra-mcp
  #   cd ~/src/ghidra-mcp
  #   ./ghidra-mcp-setup.sh --deploy --ghidra-path "$(nix eval --raw nixpkgs#ghidra)"
}
