{
  nixos.workstation =
    {
      lib,
      pkgs,
      ...
    }:
    let
      refindShare = "${pkgs.refind}/share/refind";
      refindAssetFiles =
        lib.concatMap (directory: lib.filesystem.listFilesRecursive "${refindShare}/${directory}")
          [
            "fonts"
            "icons"
            "images"
          ];
      refindAssets = lib.listToAttrs (
        map (file: {
          name = builtins.unsafeDiscardStringContext (lib.removePrefix "${refindShare}/" (toString file));
          value = file;
        }) refindAssetFiles
      );
    in
    {
      boot.kernelPackages = pkgs.linuxPackages_latest;

      boot.loader = {
        systemd-boot.enable = false;
        grub.enable = false;
        refind = {
          enable = true;
          maxGenerations = 10;

          # The NixOS rEFInd module currently copies only the EFI executable.
          # Without rEFInd's fonts, icons, and images its graphical menu is
          # effectively blank on this machine.
          additionalFiles = refindAssets;

          # Show only the entries maintained here. The module hard-codes the
          # second menu item as the default, so keeping Windows first makes the
          # newest generated NixOS generation the default selection.
          extraConfig = ''
            resolution 1024 768
            scanfor manual

            menuentry "Windows" {
              icon /EFI/refind/icons/os_win.png
              volume e0c93891-eecf-4fb1-b153-016b5c4764d1
              loader /EFI/Microsoft/Boot/bootmgfw.efi
              ostype Windows
            }
          '';
        };
        efi = {
          canTouchEfiVariables = true;
          efiSysMountPoint = "/boot";
        };
        timeout = 25;
      };
    };
}
