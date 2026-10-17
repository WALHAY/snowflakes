{ config, inputs, ... }:
let
  inherit (config.nixos) desktop;
in
{
  flake.nixosConfigurations.workstation = inputs.nixpkgs.lib.nixosSystem {
    modules = [ config.nixos.workstation ];
  };

  nixos.workstation = { config, options, ... }: {
    imports = [
      desktop
      ../../../hosts/workstation/hardware-configuration.nix
    ];
    networking.hostName = "workstation";
    system.stateVersion = "25.11";

    assertions = [
      {
        assertion = config.nixpkgs.hostPlatform.system == "x86_64-linux";
        message = "The workstation configuration requires x86_64-linux.";
      }
      {
        # Checking option declarations catches even a disabled Asahi import.
        assertion = !(options.hardware ? asahi);
        message = "The workstation must not import any Asahi NixOS modules.";
      }
    ];
  };
}
