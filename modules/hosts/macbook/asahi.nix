{ inputs, ... }:
{
  nixos.macbook = {
    imports = [ inputs.nixos-apple-silicon.nixosModules.apple-silicon-support ];

    hardware.asahi = {
      enable = true;
      # The upstream module installs the DSP profiles and speaker protection.
      setupAsahiSound = true;
    };
    hardware.graphics.enable = true;
  };
}
