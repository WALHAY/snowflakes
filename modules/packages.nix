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

  homeManager.walhay = { pkgs, ... }: {
    home.packages = with pkgs; [
      firefox
      telegram-desktop
      chezmoi
      noctalia-shell
      yandex-music
      fastfetch
      postman
      beekeeper-studio
    ];
  };
}
