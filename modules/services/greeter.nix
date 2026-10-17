{
  nixos.desktop = { config, pkgs, ... }: {
    services.greetd = {
      enable = true;
      useTextGreeter = true;
      settings.default_session = {
        command = "${pkgs.tuigreet}/bin/tuigreet --time --remember --remember-session --cmd ${config.programs.niri.package}/bin/niri-session";
        user = "greeter";
      };
    };
  };
}
