# Snowflakes

NixOS configurations for `workstation` (x86_64, NVIDIA) and `macbook`
(aarch64, Asahi), with Home Manager for `walhay`.

## Structure

This follows the [dendritic pattern](https://github.com/mightyiam/dendritic):
every file under `modules/` is a **flake-parts module**. `import-tree` imports
the whole directory, so adding or moving a feature does not require updating
an import list.

`modules/configurations.nix` declares deferred modules for the system roles:

```text
nixos.base -> nixos.desktop -> nixos.workstation
                           -> nixos.macbook
homeManager.walhay -> home-manager.users.walhay on both hosts
```

Feature files contribute to those roles. For example, `modules/shell.nix`
configures both NixOS's Zsh installation and Home Manager's interactive shell;
`modules/hosts/workstation/steam.nix` contributes only to `nixos.workstation`.
The host modules instantiate `nixosConfigurations` from the composed roles.
Flake inputs are captured by the outer module, without `specialArgs` or
`extraSpecialArgs` plumbing.

Machine-specific features live in separate trees:

```text
modules/hosts/
  macbook/
    default.nix  # aarch64 host, hardware scan, and isolation assertions
    asahi.nix    # Asahi module, kernel, overlay, firmware, and audio
    boot.nix     # MacBook boot settings
  workstation/
    default.nix  # x86_64 host, hardware scan, and isolation assertions
    nvidia.nix   # NVIDIA drivers and 32-bit graphics
    steam.nix    # Steam and GameMode
    audio.nix    # 32-bit PipeWire support
    boot.nix     # Workstation boot settings
```

Each host imports the shared desktop separately. Neither host imports the
other's role. Automatic flake-parts imports register these role contributions;
they do not apply every NixOS module to every machine. The workstation never
imports the Asahi NixOS module or its overlay. Home Manager uses each host's
own package set, so the MacBook's Asahi overlay does not affect the workstation.

Host assertions reject any Asahi module import on the workstation (even when
disabled), and reject NVIDIA drivers or Steam on the MacBook. Both hosts also
assert their required architecture. Boot settings are separate, so repairing
the workstation's GRUB configuration cannot change the MacBook's bootloader.

Generated `hosts/*/hardware-configuration.nix` files are the deliberate
exception: they remain ordinary NixOS modules outside the automatic import
tree. Keep hardware scans there. System and home state versions remain
`25.11`; do not bump them as part of a package update.

Home Manager uses the host's package set, including its unfree policy and
overlays. The old exception for insecure `beekeeper-studio-5.5.7` was removed:
the pinned package is 5.8.1 and declares no known vulnerabilities. Existing
Nixpkgs, Home Manager, and Asahi pins are preserved; the refactor only adds
flake-parts and import-tree inputs.

## Checks and rebuilds

Stage new module files before using a Git flake (`git add flake.nix flake.lock
modules hosts home README.md`), since Nix ignores untracked files. For local
checks without staging, `path:.` includes all files in the directory:

```sh
nix flake check path:. --all-systems --no-build --no-write-lock-file --keep-going
nix eval path:.#nixosConfigurations.workstation.config.system.build.toplevel.drvPath
nix fmt -- $(rg --files -g '*.nix' -g '!hosts/**')
```

Evaluation checks module consistency and derivations; it does not prove that
the machine boots. Resolve the boot and firmware items below before rebuilding.
Afterwards, build on the target machine before activating:

```sh
nixos-rebuild build --flake .#workstation
sudo nixos-rebuild switch --flake .#workstation
```

## Boot configuration: intentionally deferred

At the owner's request, bootloader/EFI settings and hardware scans were
preserved for an on-device repair. **This configuration is not yet ready to
activate.** Each host's `modules/hosts/<host>/boot.nix` preserves its existing
effective settings, including rEFInd. Current state:

- The workstation has no declared EFI system partition mount. A successful
  evaluation does not catch this missing mount or make rEFInd bootable.
- The MacBook sets `efi.canTouchEfiVariables = false`, as required by Asahi.
  The workstation's separate setting remains `true`.
- MacBook firmware is loaded by the Asahi module from `/boot/asahi` (or
  `/mnt/boot/asahi` in the installer). It is absent on other machines and
  unavailable in pure flake evaluation.

No EFI partitions, firmware variables, or installed bootloaders were modified
during this refactor.

### Restore GRUB on the workstation

1. On the workstation or a NixOS live USB, collect the actual disk layout and
   boot mode:

   ```sh
   lsblk -o NAME,FSTYPE,UUID,PARTTYPE,MOUNTPOINTS
   findmnt /boot
   findmnt /boot/efi
   test -d /sys/firmware/efi && echo UEFI || echo BIOS
   ```

   For UEFI, identify the FAT EFI system partition (GPT type
   `c12a7328-f81f-11d2-ba4b-00a0c93ec93b`). Do not assume the historical UUID
   `B8FC-C338` is still correct, and do not format any partition. If the
   machine boots in BIOS mode, stop here: BIOS GRUB needs a verified whole-disk
   installation target, and the UEFI example below does not apply.

2. Once the EFI partition is verified, declare its mount in the workstation's
   hardware configuration, or regenerate the hardware scan with the real
   filesystems mounted. For example, **only if `/boot` is the intended mount**:

   ```nix
   fileSystems."/boot" = {
     device = "/dev/disk/by-uuid/REPLACE-WITH-VERIFIED-UUID";
     fsType = "vfat";
     options = [ "fmask=0077" "dmask=0077" ];
   };
   ```

3. Update only `modules/hosts/workstation/boot.nix` to use UEFI GRUB:

   ```nix
   {
     nixos.workstation.boot.loader = {
       systemd-boot.enable = false;
       refind.enable = false;
       grub = {
         enable = true;
         efiSupport = true;
         device = "nodev";
       };
       efi = {
         canTouchEfiVariables = true;
         efiSysMountPoint = "/boot";
       };
       timeout = 25;
     };
   }
   ```

   If the verified EFI mount is `/boot/efi`, use that for both `fileSystems`
   and `efiSysMountPoint` instead. Keep workstation settings scoped to that
   host; Asahi's U-Boot environment must keep EFI variable writes disabled.

4. On a running NixOS workstation, mount the declared EFI partition if needed
   and verify it with `findmnt`. Then build and install GRUB for the next boot:

   ```sh
   nixos-rebuild build --flake .#workstation
   sudo nixos-rebuild boot --install-bootloader --flake .#workstation
   ```

   Inspect the output before rebooting. If recovering from a live USB, mount
   the existing root at `/mnt` and its verified EFI partition at `/mnt/boot`
   (or `/mnt/boot/efi`), enter it with `sudo nixos-enter --root /mnt`, change to
   this checkout, and run the build/install commands there. Do not run the
   workstation's rebuild against the live USB's own root filesystem.

### MacBook firmware

Check on the installed MacBook, where its actual firmware is available:

```sh
ls /boot/asahi/all_firmware.tar.gz /boot/asahi/kernelcache*
nix eval --impure .#nixosConfigurations.macbook.config.system.build.toplevel.drvPath
nixos-rebuild build --impure --flake .#macbook
```

The Asahi module discovers the firmware locally, so these commands need
`--impure`. For pure evaluation, supply `hardware.asahi.peripheralFirmwareDirectory`
from a private, reproducible firmware source as described upstream. Do not
commit the non-redistributable firmware to this repository or disable
extraction on the real machine just to make an off-device check pass.

Any MacBook bootloader change belongs in `modules/hosts/macbook/boot.nix`.
The [upstream Asahi guide](https://github.com/nix-community/nixos-apple-silicon/blob/main/docs/uefi-standalone.md#nixos-configuration)
documents systemd-boot with EFI variable writes disabled; this is independent
of the workstation's GRUB migration.
