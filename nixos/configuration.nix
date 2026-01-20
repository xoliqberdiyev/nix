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

  nixpkgs = {
    overlays = [
      inputs.self.overlays.additions
      inputs.self.overlays.modifications
      inputs.self.overlays.unstable-packages

    ];
    config = {
      allowUnfree = true;
    };
  };
  

  nix = let
    flakeInputs = lib.filterAttrs (_: lib.isType "flake") inputs;
  in {
    settings = {
      experimental-features = "nix-command flakes";
      flake-registry = "";
      nix-path = config.nix.nixPath;
    };
    channel.enable = false;

    registry = lib.mapAttrs (_: flake: {inherit flake;}) flakeInputs;
    nixPath = lib.mapAttrsToList (n: _: "${n}=flake:${n}") flakeInputs;
  };

  
  networking.hostName = "xoliqberdiyev";
  
  networking.networkmanager.enable = true;

  time.timeZone = "Asia/Tashkent";

  i18n.defaultLocale = "en_US.UTF-8";

  services.xserver = {
    enable = true;
  };

  services = {
    desktopManager.plasma6.enable = true;
    displayManager.sddm.enable = true; 
  };
  

  services.xserver.xkb = {
    layout = "us";
    variant = "";
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
  };


  virtualisation.docker.enable = true;
  environment.systemPackages = with pkgs; [
    # browsers
    brave
    floorp-bin
    inputs.zen-browser.packages.${pkgs.system}.default
    google-chrome
    
    # desktop apps
    telegram-desktop
    termius
    element-desktop

    # code editors
    vscode
    vim
    neovim
    zed-editor
    
    # programming languages & tools
    docker-compose
    git
    python313
    pyright
    go
    gopls
    rustc
    cargo
    rust-analyzer
    
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
}
