{
  # Preserve the existing bootloader and effective EFI settings. Asahi's
  # U-Boot environment does not support writing EFI variables.
  nixos.macbook.boot.loader = {
    systemd-boot.enable = false;
    grub.enable = false;
    refind.enable = true;
    efi.canTouchEfiVariables = false;
    timeout = 25;
  };
}
