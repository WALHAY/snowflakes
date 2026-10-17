{
  nixos.base = { pkgs, ... }: {
    environment.systemPackages = [ pkgs.docker-compose ];

    virtualisation.docker.enable = true;
  };
}
