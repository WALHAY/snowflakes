{
  # Steam and its 32-bit runtime are only supported on this x86_64 host.
  nixos.workstation = {
    programs.steam = {
      enable = true;
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
    };

    programs.gamemode.enable = true;
  };
}
