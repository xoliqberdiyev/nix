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

  # ===============================
  # WAYBAR (Plasma 6 + Gruvbox)
  # ===============================
  programs.waybar = {
    enable = true;

    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 34;

        modules-left = [ "clock" ];
        modules-center = [ "hyprland/window" ];
        modules-right = [
          "hyprland/workspaces"
          "tray"
        ];

        "hyprland/workspaces" = {
          format = "{icon}";
          sort-by-number = true;
          on-click = "activate";
          persistent-workspaces = {
            "*" = 5;
          };
        };

        clock = {
          format = "  {:%H:%M}";
        };

        tray = {
          spacing = 8;
        };
      };
    };

    style = ''
      * {
        font-family: JetBrainsMono Nerd Font, monospace;
        font-size: 13px;
        border: none;
        border-radius: 10px;
      }

      window#waybar {
        background: #1d2021;
        color: #ebdbb2;
      }

      #workspaces {
        background: #282828;
        padding: 4px 6px;
      }

      #workspaces button {
        background: transparent;
        color: #a89984;
        padding: 4px 10px;
        margin: 0 4px;
        border-radius: 8px;
      }

      #workspaces button.active {
        background: #458588;
        color: #ebdbb2;
      }

      #workspaces button:hover {
        background: #3c3836;
        color: #fabd2f;
      }

      #clock {
        background: #3c3836;
        padding: 4px 12px;
        border-radius: 8px;
      }

      #tray {
        background: #3c3836;
        padding: 4px 10px;
      }
    '';
  };

  fonts.fontconfig.enable = true;

  home.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
  ];
}
