{ inputs, pkgs, ... }:

{
  wayland.windowManager.hyprland = {
    enable = true;

    package =
      inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;

    portalPackage =
      inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;

    plugins = [
      # pkgs.hyprexpo
    ];

    settings = {
      # bind = [
      #   "SUPER, TAB, hyprexpo:toggle"
      # ];
    };
  };

  home.packages = with pkgs; [
    gruvbox-gtk-theme
    gruvbox-dark-icons-gtk
    bibata-cursors
    noto-fonts
    noto-fonts-color-emoji
  ];

  dconf.settings = {
    "org/gnome/desktop/interface" = {
      gtk-theme = "Gruvbox-Dark";
      icon-theme = "Gruvbox-Dark";
      cursor-theme = "Bibata-Modern-Ice";
      font-name = "Noto Sans Medium 11";
      document-font-name = "Noto Sans Medium 11";
      monospace-font-name = "Noto Sans Mono Medium 11";
      color-scheme = "prefer-dark";
    };
  };
}
