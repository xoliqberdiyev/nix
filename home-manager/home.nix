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
    stateVersion = "25.11";

    packages = with pkgs; [
      claude-code
    ];
  };
  programs.bash = {
    enable = true;
  };
  programs.home-manager.enable = true;
  programs.git.enable = true;
  programs.starship = {
    enable = true;
    enableBashIntegration = true;
  };
  programs.bash.shellAliases = {
    zed = "zeditor";
  };
  systemd.user.startServices = "sd-switch";
}
