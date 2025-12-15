{ config, pkgs, ... }:

{
  programs.alacritty = {
    enable = true;
    
    settings = {
      window = {
        padding = {
          x = 10;
          y = 10;
        };
        decorations = "full";
        opacity = 0.95;
        title = "Alacritty";
        dynamic_title = true;
        class = {
          instance = "Alacritty";
          general = "Alacritty";
        };
      };

      scrolling = {
        history = 10000;
        multiplier = 3;
      };

      font = {
        normal = {
          family = "JetBrainsMono Nerd Font";
          style = "Regular";
        };
        bold = {
          family = "JetBrainsMono Nerd Font";
          style = "Bold";
        };
        italic = {
          family = "JetBrainsMono Nerd Font";
          style = "Italic";
        };
        bold_italic = {
          family = "JetBrainsMono Nerd Font";
          style = "Bold Italic";
        };
        size = 11.0;
      };

      cursor = {
        style = {
          shape = "Block";
          blinking = "On";
        };
        blink_interval = 750;
        unfocused_hollow = true;
      };

      bell = {
        animation = "EaseOutExpo";
        duration = 0;
      };

      mouse = {
        hide_when_typing = true;
      };

      selection = {
        save_to_clipboard = true;
      };

      colors = {
        primary = {
          background = "#282828";
          foreground = "#ebdbb2";
        };
        
        normal = {
          black = "#282828";
          red = "#cc241d";
          green = "#98971a";
          yellow = "#d79921";
          blue = "#458588";
          magenta = "#b16286";
          cyan = "#689d6a";
          white = "#a89984";
        };
        
        bright = {
          black = "#928374";
          red = "#fb4934";
          green = "#b8bb26";
          yellow = "#fabd2f";
          blue = "#83a598";
          magenta = "#d3869b";
          cyan = "#8ec07c";
          white = "#ebdbb2";
        };
      };

      keyboard.bindings = [
        { key = "V"; mods = "Control|Shift"; action = "Paste"; }
        { key = "C"; mods = "Control|Shift"; action = "Copy"; }
        { key = "Plus"; mods = "Control"; action = "IncreaseFontSize"; }
        { key = "Minus"; mods = "Control"; action = "DecreaseFontSize"; }
        { key = "Key0"; mods = "Control"; action = "ResetFontSize"; }
        { key = "N"; mods = "Control|Shift"; action = "SpawnNewInstance"; }
      ];
    };
  };

  home.packages = with pkgs; [
    (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
  ];
}