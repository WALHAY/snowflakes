{
  nixos.base = { pkgs, ... }: {
    environment.systemPackages = with pkgs; [
      gcc
      clang
      clang-tools
      nixd
      nixfmt
    ];

    programs.nix-ld = {
      enable = true;
      libraries = with pkgs; [
        zlib
        glib
        openssl
      ];
    };
  };

  homeManager.walhay = { pkgs, ... }: {
    home.packages = with pkgs; [
      gradle
      zulu25
      kotlin
    ];
  };
}
