{
  nixos.desktop = {
    # Home Manager owns the single SSH agent and its shell integration.
    programs.ssh.startAgent = false;
    services.gnome.gcr-ssh-agent.enable = false;
  };

  homeManager.walhay.services.ssh-agent.enable = true;
}
