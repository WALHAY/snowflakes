{ config, lib, ... }:
{
  # Feature files merge into these roles instead of maintaining import lists
  # for every individual service. Only hosts instantiate NixOS configurations.
  options = {
    nixos = {
      base = lib.mkOption {
        type = lib.types.deferredModule;
        description = "Settings shared by all NixOS hosts.";
      };
      desktop = lib.mkOption {
        type = lib.types.deferredModule;
        description = "The shared desktop, including the base system.";
      };
      workstation = lib.mkOption {
        type = lib.types.deferredModule;
        description = "The NVIDIA workstation, including the desktop.";
      };
      macbook = lib.mkOption {
        type = lib.types.deferredModule;
        description = "The Apple Silicon MacBook, including the desktop.";
      };
    };
    homeManager.walhay = lib.mkOption {
      type = lib.types.deferredModule;
      description = "Walhay's Home Manager configuration on both hosts.";
    };
  };

  config.nixos = {
    desktop.imports = [ config.nixos.base ];
  };
}
