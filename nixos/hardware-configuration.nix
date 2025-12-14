{ config, lib, pkgs, modulesPath, ... }:
{
  imports = [ ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.initrd.availableKernelModules = [ "nvme" "xhci_pci" "ahci" "usb_storage" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [ ];

  # files systems
  fileSystems."/" =
    { device = "/dev/disk/by-uuid/c1572d59-1839-49a9-96d7-8cbd27db03c8";
      fsType = "ext4";
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/A23D-540B";
      fsType = "vfat";
      options = [ "fmask=0077" "dmask=0077" ];
    };
  # swap desices
  swapDevices = [ ];

  
  networking.useDHCP = lib.mkDefault true;
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  # Set your system kind (needed for flakes)
  # nixpkgs.hostPlatform = "x86_64-linux";
}
