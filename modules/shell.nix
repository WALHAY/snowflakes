{
  nixos.base = { pkgs, ... }: {
    programs.zsh.enable = true;
    users.defaultUserShell = pkgs.zsh;
    environment.shells = [ pkgs.zsh ];
  };

  homeManager.walhay = {
    programs.nix-your-shell.enable = true;

    programs.zsh = {
      enable = true;
      enableCompletion = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;
      oh-my-zsh = {
        enable = true;
        plugins = [ "git" ];
      };
    };
    programs.starship.enable = true;
  };
}
