-- Elin: Clojure development environment (Babashka-backed nREPL client).
-- Replaces Conjure. The plugin/backend are installed via Nix (see
-- nix/home/cli/neovim.nix); this file only tweaks behaviour.
--
-- These globals must be set before elin initialises on VimEnter, which is why
-- they live here (loaded at startup via lua/plugins/init.lua) rather than in
-- after/plugin.

-- Opt in to elin's default key mappings (it maps nothing by default).
vim.g.elin_enable_default_key_mappings = true

-- Anchor those mappings on the local leader (","), matching the Conjure
-- muscle memory: e.g. ,ee eval current list, ,eb eval buffer, ,tt run test.
vim.g.elin_default_key_mapping_leader = ","

-- Server auto-starts and auto-connects on opening a Clojure buffer; omni
-- completion (<C-x><C-o>) is wired up automatically. Both are elin defaults.
