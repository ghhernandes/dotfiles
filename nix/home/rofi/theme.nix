_:

{
  home.file.".config/rofi/custom.rasi".text = ''
    * {
      bg-col:       #1e1e1e;
      bg-col-light: #383838;
      border-col:   #458588;
      selected-col: #458588;
      fg-col:       #ffffff;
      fg-col2:      #888888;
      accent:       #458588;

      font: "JetBrainsMono Nerd Font 12";
    }

    element-text, element-icon, mode-switcher {
      background-color: inherit;
      text-color:       inherit;
    }

    window {
      width:            600px;
      border:           2px;
      border-color:     @border-col;
      border-radius:    10px;
      background-color: @bg-col;
    }

    mainbox {
      padding:          12px;
      background-color: @bg-col;
    }

    inputbar {
      children:         [ prompt, entry ];
      background-color: @bg-col-light;
      border-radius:    8px;
      padding:          4px;
      margin:           0px 0px 12px 0px;
    }

    prompt {
      background-color: @accent;
      text-color:       @bg-col;
      padding:          8px 12px;
      border-radius:    6px;
      margin:           0px 8px 0px 0px;
    }

    entry {
      padding:          8px;
      background-color: inherit;
      text-color:       @fg-col;
      placeholder:      "Search…";
      placeholder-color: @fg-col2;
    }

    listview {
      lines:            8;
      columns:          1;
      spacing:          4px;
      scrollbar:        false;
      background-color: @bg-col;
    }

    element {
      padding:          8px;
      spacing:          10px;
      border-radius:    6px;
      background-color: @bg-col;
      text-color:       @fg-col2;
    }

    element-icon {
      size:             24px;
    }

    element selected {
      background-color: @selected-col;
      text-color:       @fg-col;
    }

    mode-switcher {
      spacing: 0;
    }

    button {
      padding:          8px;
      background-color: @bg-col-light;
      text-color:       @fg-col2;
      vertical-align:   0.5;
      horizontal-align: 0.5;
    }

    button selected {
      background-color: @accent;
      text-color:       @bg-col;
    }

    message {
      background-color: @bg-col-light;
      margin:           2px;
      padding:          2px;
      border-radius:    6px;
    }

    textbox {
      padding:          8px;
      background-color: @bg-col;
      text-color:       @fg-col;
    }
  '';
}
