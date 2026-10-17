{
  nixos.base = { pkgs, ... }: {
    environment.systemPackages = with pkgs; [
      amneziawg-go
      amneziawg-tools
    ];
  };
}
