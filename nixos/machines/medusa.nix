{ config, lib, pkgs, ... }:

{
  imports = [
    ../configuration.nix
  ];

  boot = {
    initrd = {
      availableKernelModules = [
        "ahci"
        "nvme"
        "sd_mod"
        "usb_storage"
        "usbhid"
        "xhci_pci"
      ];

      luks.devices = {
        unlocked = {
          allowDiscards = true;
          device = "/dev/disk/by-partlabel/primary";
          preLVM = true;
        };
      };
    };

    loader = {
      efi = {
        canTouchEfiVariables = true;
      };

      systemd-boot = {
        enable = true;
        configurationLimit = 5;
      };
    };

    kernelModules = [
      "amdgpu"
      "kvm-amd"
    ];

    kernelPackages = pkgs.linuxPackages_latest;
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-label/boot";
    fsType = "vfat";
  };

  fileSystems."/" = {
    device = "/dev/unlocked-lvm/nixos";
    fsType = "ext4";
  };

  hardware = {
    # Enable amd microcode updates.
    cpu.amd.updateMicrocode = true;

    # Enable nonfree firmware.
    enableRedistributableFirmware = true;
  };

  services = {
    # Enable periodic trim for long term SSD performance.
    fstrim = {
      enable = true;
    };

    # Enable the amd drivers.
    videoDrivers = [ "amdgpu" ];
  };

  networking = {
    hostName = "medusa";
  };

  nix.maxJobs = lib.mkDefault 12;
}
