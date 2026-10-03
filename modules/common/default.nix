{ pkgs, ... }:
{
  imports = [
    ./services.nix
    ./languages.nix
  ];
  environment.systemPackages = with pkgs; [
    vim
    neovim
	kitty
    git
    xwayland
    xwayland-satellite
    ripgrep
  ];

  networking.networkmanager.enable = true;

  time.timeZone = "Europe/Moscow";
  i18n.defaultLocale = "en_US.UTF-8";

  boot.loader = {
    systemd-boot.enable = false;
	grub.enable = false;
	refind.enable = true;
    efi.canTouchEfiVariables = true;
    timeout = 25;
  };

  services.xserver = {
    xkb = {
      layout = "us, ru";
      options = "caps:escape";
    };
  };

  programs.xwayland.enable = true;

  users.users.walhay = {
    isNormalUser = true;
    description = "WALHAY";
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
    shell = pkgs.zsh;
  };

  programs.zsh.enable = true;
  users.defaultUserShell = pkgs.zsh;
  environment.shells = [ pkgs.zsh ];

  # Unfree packages (global)
  nixpkgs.config.allowUnfree = true;

  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    wlr.enable = true; # For Wayland/Asahi
  };
  services.dbus.enable = true;

  system.stateVersion = "25.11";
}
