{ config, inputs, ... }:
{
  nixos.base = { pkgs, ... }: {
    imports = [ inputs.home-manager.nixosModules.home-manager ];

    users.users.walhay = {
      isNormalUser = true;
      description = "WALHAY";
      extraGroups = [
        "networkmanager"
        "wheel"
      ];
      shell = pkgs.zsh;
    };

    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;
      extraSpecialArgs = { inherit inputs; };
      users.walhay = config.homeManager.walhay;
    };
  };

  homeManager.walhay = {
    home.username = "walhay";
    home.homeDirectory = "/home/walhay";
    home.stateVersion = "25.11";
  };
}
