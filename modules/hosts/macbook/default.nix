{ config, inputs, ... }:
let
  inherit (config.nixos) desktop;
in
{
  flake.nixosConfigurations.macbook = inputs.nixpkgs.lib.nixosSystem {
    modules = [ config.nixos.macbook ];
  };

  nixos.macbook = { config, lib, ... }: {
    imports = [
      desktop
      ../../../hosts/macbook/hardware-configuration.nix
    ];
    networking.hostName = "macbook";
    system.stateVersion = "25.11";

    assertions = [
      {
        assertion = config.nixpkgs.hostPlatform.system == "aarch64-linux";
        message = "The MacBook configuration requires aarch64-linux.";
      }
      {
        assertion = config.hardware.asahi.enable;
        message = "The MacBook configuration requires Asahi support.";
      }
      {
        assertion = !(lib.elem "nvidia" config.services.xserver.videoDrivers);
        message = "The MacBook must not import the workstation's NVIDIA configuration.";
      }
      {
        assertion = !config.programs.steam.enable;
        message = "Steam belongs to the x86_64 workstation, not the Asahi MacBook.";
      }
    ];
  };
}
