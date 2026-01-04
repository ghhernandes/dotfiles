{ config, pkgs, ... }:

{
  home.file.".config/rofi/custom.rasi".text = ''
    * {
      bg-col:  #1e1e1e;
      bg-col-light: #383838;
      border-col: #458588;
      selected-col: #383838;
      fg-col: #ffffff;
      fg-col2: #888888;
      width: 600;
    }

    element-text, element-icon, mode-switcher {
      background-color: inherit;
      text-color: inherit;
    }

    window {
      height: 400px;
      border: 1px;
      border-color: @border-col;
      border-radius: 0px;
      background-color: @bg-col;
    }

    mainbox {
      background-color: @bg-col;
    }

    inputbar {
      children: [prompt,entry];
      background-color: @bg-col;
      border-radius: 0px;
      padding: 8px;
    }

    prompt {
      background-color: @bg-col-light;
      padding: 8px;
      text-color: @fg-col;
      margin: 0px 4px 0px 0px;
    }

    textbox-prompt-colon {
      expand: false;
      str: ":";
    }

    entry {
      padding: 8px;
      background-color: @bg-col;
      text-color: @fg-col;
    }

    listview {
      border: 0px 0px 0px;
      padding: 6px 0px 0px;
      columns: 1;
      lines: 8;
      background-color: @bg-col;
    }

    element {
      padding: 8px;
      background-color: @bg-col;
      text-color: @fg-col2;
    }

    element-icon {
      size: 20px;
    }

    element selected {
      background-color: @selected-col;
      text-color: @fg-col;
    }

    mode-switcher {
      spacing: 0;
    }

    button {
      padding: 8px;
      background-color: @bg-col-light;
      text-color: @fg-col2;
      vertical-align: 0.5;
      horizontal-align: 0.5;
    }

    button selected {
      background-color: @bg-col;
      text-color: @fg-col;
    }

    message {
      background-color: @bg-col-light;
      margin: 2px;
      padding: 2px;
      border-radius: 0px;
    }

    textbox {
      padding: 8px;
      background-color: @bg-col;
      text-color: @fg-col;
    }
  '';
}
