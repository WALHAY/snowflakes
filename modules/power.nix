{
  nixos.desktop = { pkgs, ... }: {
    environment.systemPackages = with pkgs; [
      brightnessctl
      acpi
    ];
    services.upower.enable = true;
  };
}
