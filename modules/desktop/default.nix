{
  nixos.desktop = { pkgs, ... }: {
    programs.niri.enable = true;
    programs.xwayland.enable = true;

    environment.systemPackages = with pkgs; [
      kitty
      xwayland-satellite
    ];

    # Niri supplies the GNOME/GTK portals and their routing configuration.
    # The wlroots portal does not support Niri.
    services.dbus.enable = true;
  };
}
