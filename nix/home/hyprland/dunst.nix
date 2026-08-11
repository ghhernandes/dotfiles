_:

{
  services.dunst = {
    enable = true;
    settings = {
      global = {
        # Display settings
        monitor = 0;
        follow = "mouse";

        # Geometry
        width = "(300, 500)";
        height = 350;
        origin = "top-center";
        offset = "0x48";

        # Layout
        padding = 14;
        horizontal_padding = 14;
        frame_width = 2;
        gap_size = 6;
        separator_height = 1;
        separator_color = "frame";

        # Typography
        font = "JetBrainsMono Nerd Font 12";
        line_height = 0;
        markup = "full";
        format = "<b>%s</b>\\n%b";
        alignment = "left";
        vertical_alignment = "center";
        show_age_threshold = 60;
        word_wrap = true;
        ellipsize = "middle";
        ignore_newline = false;
        stack_duplicates = true;
        hide_duplicate_count = false;
        show_indicators = true;

        # Icons
        icon_position = "left";
        min_icon_size = 0;
        max_icon_size = 48;

        # Interaction
        sticky_history = true;
        history_length = 20;
        browser = "xdg-open";
        always_run_script = true;

        # Appearance
        corner_radius = 0;
        transparency = 0;

        # Mouse actions
        mouse_left_click = "close_current";
        mouse_middle_click = "do_action, close_current";
        mouse_right_click = "close_all";
      };

      # Low urgency notifications (info)
      urgency_low = {
        background = "#1e1e1e";
        foreground = "#888888";
        frame_color = "#383838";
        timeout = 5;
      };

      # Normal urgency notifications (cyan accent, matching window borders/waybar)
      urgency_normal = {
        background = "#1e1e1e";
        foreground = "#ffffff";
        frame_color = "#33ccff";
        timeout = 8;
      };

      # Critical urgency notifications
      urgency_critical = {
        background = "#1e1e1e";
        foreground = "#ffffff";
        frame_color = "#f38ba8";
        timeout = 0;
      };
    };
  };
}
