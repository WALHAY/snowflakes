{
  nixos.base = { pkgs, ... }: {
    programs.zsh.enable = true;
    users.defaultUserShell = pkgs.zsh;
    environment.shells = [ pkgs.zsh ];
  };

  homeManager.walhay = {
    programs.nix-your-shell.enable = true;

    # Zoxide's interactive `zi` command needs fzf, but the old configuration
    # did not enable fzf's additional shell key bindings.
    programs.fzf = {
      enable = true;
      enableZshIntegration = false;
    };

    programs.zsh = {
      enable = true;
      enableCompletion = true;
      autosuggestion = {
        enable = true;
        highlight = "fg=10,underline";
      };
      syntaxHighlighting.enable = true;
      localVariables.DISABLE_UNTRACKED_FILES_DIRTY = true;
      oh-my-zsh = {
        enable = true;
        extraConfig = ''
          zstyle ':omz:update' mode disabled
        '';
        plugins = [
          "git"
          "gradle"
        ];
        theme = "robbyrussell";
      };
    };

    programs.starship.enable = true;

    programs.zoxide = {
      enable = true;
      enableZshIntegration = true;
    };
  };
}
