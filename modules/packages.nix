{
  nixos.base = { pkgs, ... }: {
    environment.systemPackages = with pkgs; [
      vim
      neovim
      git
      ripgrep
      unzip
    ];
  };

  homeManager.walhay = { inputs, pkgs, ... }: {
    imports = [
      inputs.noctalia.homeModules.default
    ];

    home.packages = with pkgs; [
      firefox
      telegram-desktop
      chezmoi
      yandex-music
      fastfetch
      postman
    ];

    programs.noctalia = {
      enable = true;
    };
  };
}
