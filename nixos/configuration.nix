{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
  ];

  # Boot loader — MUHIM, qo'shilmagan edi
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  nixpkgs = {
    overlays = [
      inputs.self.overlays.additions
      inputs.self.overlays.modifications
      inputs.self.overlays.unstable-packages
    ];
    config.allowUnfree = true;
  };
  programs.firefox.enable = true;

  nix = let
    flakeInputs = lib.filterAttrs (_: lib.isType "flake") inputs;
  in {
    settings = {
      experimental-features = "nix-command flakes";
      flake-registry = "";
      nix-path = config.nix.nixPath;
      auto-optimise-store = true;
    };
    channel.enable = false;
    registry = lib.mapAttrs (_: flake: {inherit flake;}) flakeInputs;
    nixPath = lib.mapAttrsToList (n: _: "${n}=flake:${n}") flakeInputs;

    # Avtomatik garbage collection
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
  };

  networking = {
    hostName = "xoliqberdiyev";
    networkmanager = {
      enable = true;
      wifi.powersave = false;
      insertNameservers = [ "8.8.8.8" "1.1.1.1" ];
    };
  };

  time.timeZone = "Asia/Tashkent";
  i18n.defaultLocale = "en_US.UTF-8";

  # services.xserver bitta blokda
  services.xserver = {
    enable = true;
    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;
    xkb = {
      layout = "us";
      variant = "";
    };
  };

  services.printing.enable = true;
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  users.users.behruz = {
    isNormalUser = true;
    description = "behruz";
    extraGroups = [ "docker" "networkmanager" "wheel" ];
    packages = with pkgs; [
      postman
    ];
    # SSH kalitlaringizni qo'shing
    # openssh.authorizedKeys.keys = [
    #   "ssh-ed25519 AAAA... your-key"
    # ];
  };

  # nix-ld kengaytirilgan
  programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [
      stdenv.cc.cc.lib
      zlib
      openssl
      curl
      glib
      libxml2
      icu
    ];
  };

  virtualisation.docker = {
    enable = true;
    daemon.settings = {
      insecure-registries = [ "194.164.235.56:5000" ];
    };
  };

  environment.systemPackages = with pkgs; [
    # browsers
    brave
    inputs.zen-browser.packages.${pkgs.system}.default
    google-chrome

    # desktop apps
    telegram-desktop
    termius
    element-desktop
    wpsoffice
    vlc
    anydesk

    # editors
    vim
    neovim
    zed-editor

    # dev tools
    docker-compose
    git
    python313
    pyright
    go
    gopls
    rustc
    cargo
    rust-analyzer
    nodejs_20  # Claude Code uchun

    # utilities
    alacritty
    zellij
    wget
    btop
    starship
  ];

  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = false;
    };
  };

  system.stateVersion = "25.11";

  # Bluetooth
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };

  # Blueman GUI (ixtiyoriy, lekin foydali)
  services.blueman.enable = true;

  # Firmware (AMD CPU mikrokod uchun)
  hardware.enableRedistributableFirmware = true;

  # SSD bo'lsa - TRIM
  services.fstrim.enable = true;
}
