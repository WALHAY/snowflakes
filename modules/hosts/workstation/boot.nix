{
  # Existing settings, pending the GRUB/EFI repair described in README.md.
  # The workstation's EFI mount must be verified on the actual machine.
  nixos.workstation.boot.loader = {
    systemd-boot.enable = false;
    grub.enable = false;
    refind.enable = true;
    efi.canTouchEfiVariables = true;
    timeout = 25;
  };
}
