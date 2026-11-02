{ config, lib, ... }:

let
  cfg = config.ai.ollama;
in
{
  options.ai.ollama = {
    enable = lib.mkEnableOption "the local Ollama LLM server";

    model = lib.mkOption {
      type = lib.types.str;
      default = "qwen2.5:3b";
      description = ''
        Ollama model tag to pull automatically and keep in sync. 3B was
        chosen over the initial 0.5B default after live testing showed
        0.5B too unreliable at tool-calling (hallucinated arguments,
        inconsistent responses to identical prompts) to safely gate
        command execution on. At ~2GB resident it still fits comfortably
        on a CPU-only laptop with headroom to spare, and since Ollama only
        burns CPU/GPU during an actual query (idling otherwise, and
        unloading the model after a few minutes idle), the battery cost is
        a few seconds per question rather than sustained drain. Override
        per-host with `ai.ollama.model` if a host can afford more (e.g.
        ghstation's ROCm GPU, once its VRAM headroom is known).
      '';
    };

    keepAlive = lib.mkOption {
      type = lib.types.str;
      default = "5m";
      description = ''
        How long ollama keeps an unused model resident before unloading it
        (`OLLAMA_KEEP_ALIVE`). This is ollama's own idle-unload mechanism,
        made explicit here rather than left as an implicit default; there's
        no separate idle-tracking in this config; a loaded-but-idle model
        costs ~0% CPU/GPU already; the only thing an unload saves is the
        ~2GB of RAM it holds, at the cost of a slower first reply
        afterwards while it reloads.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    services.ollama = {
      enable = true;
      loadModels = [ cfg.model ];
      syncModels = true;
      host = "127.0.0.1";
      environmentVariables.OLLAMA_KEEP_ALIVE = cfg.keepAlive;
    };
  };
}
