{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  imports = [
    ../modules/home-manager
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

  home = {
    username = "behruz";
    homeDirectory = "/home/behruz";
  };


  programs.home-manager.enable = true;
  programs.git.enable = true;

  systemd.user.startServices = "sd-switch";

  home.stateVersion = "25.11";
}
