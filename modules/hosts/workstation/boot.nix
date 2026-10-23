{
  nixos.workstation = { pkgs, ... }: {
    boot.kernelPackages = pkgs.linuxPackages_latest;

    # Existing settings, pending the GRUB/EFI repair described in README.md.
    # The workstation's EFI mount must be verified on the actual machine.
    boot.loader = {
      systemd-boot.enable = false;
      grub.enable = false;
      refind.enable = true;
      efi.canTouchEfiVariables = true;
      timeout = 25;
    };
  };
}
