{inputs, pkgs, ...}: let 
    pkgs-unstable = inputs.hyprland.inputs.nixpkgs.legacyPackages.${pkgs.stdenv.hostPlatform.system};
in {
    programs.hyprland = {
      enable = true;
      package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
      portalPackage = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
    };

    hardware.graphics = {
      package = pkgs-unstable.mesa;

      enable32Bit = true;
      package32 = pkgs-unstable.pkgsi686Linux.mesa;
    };

  # Gruvbox theme
  home.packages = with pkgs; [
    gruvbox-gtk-theme
    gruvbox-dark-icons-gtk
    bibata-cursors
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
  ];

  programs.dconf.enable = true;

  programs.dconf.profiles.user.databases = [
    {
      settings."org/gnome/desktop/interface" = {
        gtk-theme = "Gruvbox-Dark";
        icon-theme = "Gruvbox-Dark";
        cursor-theme = "Bibata-Modern-Ice";
        font-name = "Noto Sans Medium 11";
        document-font-name = "Noto Sans Medium 11";
        monospace-font-name = "Noto Sans Mono Medium 11";
        color-scheme = "prefer-dark";
      };
    }
  ];

}