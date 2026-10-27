{
  nixos.desktop = { pkgs, ... }: {
    programs.niri.enable = true;
    programs.xwayland.enable = true;

    environment.systemPackages = with pkgs; [
      xwayland-satellite
    ];

    fonts.packages = with pkgs; [
      nerd-fonts.iosevka-term
    ];

    # Niri supplies the GNOME/GTK portals and their routing configuration.
    # The wlroots portal does not support Niri.
    services.dbus.enable = true;
  };

  homeManager.walhay = { pkgs, ... }: {
    xdg.configFile."kitty/kitty.conf".force = true;

    programs.kitty = {
      enable = true;
      font = {
        name = "IosevkaTerm Nerd Font Mono";
        package = pkgs.nerd-fonts.iosevka-term;
        size = 16;
      };

      settings = {
        background = "#1e1f28";
        foreground = "#f8f8f2";
        selection_background = "#44475a";
        selection_foreground = "#1e1f28";

        color0 = "#000000";
        color1 = "#ff5555";
        color2 = "#50fa7b";
        color3 = "#f0fa8b";
        color4 = "#bd92f8";
        color5 = "#ff78c5";
        color6 = "#8ae9fc";
        color7 = "#bbbbbb";
        color8 = "#545454";
        color9 = "#ff5454";
        color10 = "#50fa7b";
        color11 = "#f0fa8b";
        color12 = "#bd92f8";
        color13 = "#ff78c5";
        color14 = "#8ae9fc";
        color15 = "#ffffff";

        background_opacity = 0.6;
        background_blur = 25;

        macos_option_as_alt = true;
        macos_hide_from_tasks = true;
        macos_quit_when_last_window_closed = false;
        macos_traditional_fullscreen = false;
        macos_colorspace = "displayp3";

        cursor = "cyan";
        cursor_trail = 5;
        cursor_trail_decay = "0.1 0.4";
        cursor_trail_color = "cyan";

        repaint_delay = 8;
        sync_to_monitor = true;

        hide_window_decorations = "titlebar-only";

        tab_bar_style = "powerline";
        tab_powerline_style = "slanted";
        tab_title_template = "{fmt.fg.tab}[{index}] {title}";
      };
    };
  };
}
