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
  };

  programs.home-manager.enable = true;
  programs.git.enable = true;

  systemd.user.startServices = "sd-switch";

  # Wayland va Hyprland konfiguratsiyasi
  home.file."home.nix".text = ''
    { pkgs, lib, config, ... };

    let
      startupScript = pkgs.writeShellScriptBin "start" ''
        ${pkgs.waybar}/bin/waybar &
        ${pkgs.swww}/bin/swww init &

        sleep 1

        ${pkgs.swww}/bin/swww img ${./wallpaper.png} &
      '';
    in
    {
      wayland.windowManager.hyprland = {
        enable = true;

        plugins = [
          inputs.hyprland-plugins.packages."${pkgs.system}".borders-plus-plus
        ];

        settings = {
          "plugin:borders-plus-plus" = {
            add_borders = 1; # 0 - 9

            # you can add up to 9 borders
            "col.border_1" = "rgb(ffffff)";
            "col.border_2" = "rgb(2222ff)";

            # -1 means "default" as in the one defined in general:border_size
            border_size_1 = 10;
            border_size_2 = -1;

            # makes outer edges match rounding of the parent. Turn on / off to better understand. Default = on.
            natural_rounding = "yes";
          };
        };
      };
    }
  '';
}
