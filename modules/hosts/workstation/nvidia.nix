{
  # This contributes only to the workstation role, never the shared desktop.
  nixos.workstation = { config, ... }: {
    services.xserver.videoDrivers = [ "nvidia" ];

    hardware.nvidia = {
      open = true;
      modesetting.enable = true;
      package = config.boot.kernelPackages.nvidiaPackages.stable;
      nvidiaSettings = true;
    };

    hardware.graphics.enable = true;
    hardware.graphics.enable32Bit = true;
  };
}
