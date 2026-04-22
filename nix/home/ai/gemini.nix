{
  config,
  pkgs,
  lib,
  dotfilesPath,
  hostName,
  ...
}:

let
  geminiRepo = dotfilesPath + "/ai/gemini";
  hostRepo = geminiRepo + "/hosts/${hostName}";

  liveDotfiles = "${config.home.homeDirectory}/.dotfiles";
  liveGeminiRepo = "${liveDotfiles}/ai/gemini";

  # ---- GEMINI.md: shared base + optional per-host append ----
  baseGeminiMd = builtins.readFile (geminiRepo + "/GEMINI.md");
  hostGeminiMdPath = hostRepo + "/GEMINI.md";
  hostGeminiMd =
    if builtins.pathExists hostGeminiMdPath then builtins.readFile hostGeminiMdPath else "";
  mergedGeminiMd = if hostGeminiMd == "" then baseGeminiMd else baseGeminiMd + "\n" + hostGeminiMd;

  # ---- Live-edit out-of-store symlinks ----
  maybeSymlink =
    relPath: target:
    lib.optionalAttrs (builtins.pathExists (geminiRepo + "/${relPath}")) {
      "${target}".source = config.lib.file.mkOutOfStoreSymlink "${liveGeminiRepo}/${relPath}";
    };

  liveFiles = maybeSymlink "commands" ".gemini/commands";
in
{

  home.file = liveFiles // {
    ".gemini/GEMINI.md".text = mergedGeminiMd;
  };
}
