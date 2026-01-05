{ config, pkgs, ... }:

{
  home.file.".config/hypr/hyprland.conf".text = ''
    # Monitor
    monitor=,preferred,auto,1

    # Autostart
    exec-once = waybar
    exec-once = dunst
    exec-once = swww-daemon
    exec-once = nm-applet
    exec-once = /usr/lib/polkit-kde-authentication-agent-1

    # Environment variables
    env = XCURSOR_SIZE,24
    env = QT_QPA_PLATFORMTHEME,qt5ct

    # Input
    input {
        kb_layout = us,ru
        kb_options = grp:alt_shift_toggle
        
        follow_mouse = 1
        
        touchpad {
            natural_scroll = true
        }
        
        sensitivity = 0
    }

    # General
    general {
        gaps_in = 5
        gaps_out = 10
        border_size = 2
        
        # Gruvbox colors
        col.active_border = rgba(d79921ee) rgba(98971aee) 45deg
        col.inactive_border = rgba(3c3836aa)
        
        layout = dwindle
        
        allow_tearing = false
    }

    # Decoration
    decoration {
        rounding = 8
        
        blur {
            enabled = true
            size = 5
            passes = 3
            new_optimizations = true
        }
        
        drop_shadow = true
        shadow_range = 20
        shadow_render_power = 3
        col.shadow = rgba(1a1a1aee)
    }

    # Animations
    animations {
        enabled = true
        
        bezier = myBezier, 0.05, 0.9, 0.1, 1.05
        
        animation = windows, 1, 7, myBezier
        animation = windowsOut, 1, 7, default, popin 80%
        animation = border, 1, 10, default
        animation = borderangle, 1, 8, default
        animation = fade, 1, 7, default
        animation = workspaces, 1, 6, default
    }

    # Layouts
    dwindle {
        pseudotile = true
        preserve_split = true
    }

    # Window Rules
    windowrule = float, ^(pavucontrol)$
    windowrule = float, ^(nm-connection-editor)$
    windowrule = float, ^(thunar)$

    # Key bindings
    $mainMod = SUPER

    # Applications
    bind = $mainMod, Return, exec, kitty
    bind = $mainMod, Q, killactive,
    bind = $mainMod, M, exit,
    bind = $mainMod, E, exec, thunar
    bind = $mainMod, V, togglefloating,
    bind = $mainMod, R, exec, wofi --show drun
    bind = $mainMod, P, pseudo,
    bind = $mainMod, J, togglesplit,

    # Screenshot
    bind = , Print, exec, grim -g "$(slurp)" - | wl-copy
    bind = $mainMod, Print, exec, grim - | wl-copy

    # Move focus
    bind = $mainMod, left, movefocus, l
    bind = $mainMod, right, movefocus, r
    bind = $mainMod, up, movefocus, u
    bind = $mainMod, down, movefocus, d

    # Switch workspaces
    bind = $mainMod, 1, workspace, 1
    bind = $mainMod, 2, workspace, 2
    bind = $mainMod, 3, workspace, 3
    bind = $mainMod, 4, workspace, 4
    bind = $mainMod, 5, workspace, 5
    bind = $mainMod, 6, workspace, 6
    bind = $mainMod, 7, workspace, 7
    bind = $mainMod, 8, workspace, 8
    bind = $mainMod, 9, workspace, 9
    bind = $mainMod, 0, workspace, 10

    # Move window to workspace
    bind = $mainMod SHIFT, 1, movetoworkspace, 1
    bind = $mainMod SHIFT, 2, movetoworkspace, 2
    bind = $mainMod SHIFT, 3, movetoworkspace, 3
    bind = $mainMod SHIFT, 4, movetoworkspace, 4
    bind = $mainMod SHIFT, 5, movetoworkspace, 5
    bind = $mainMod SHIFT, 6, movetoworkspace, 6
    bind = $mainMod SHIFT, 7, movetoworkspace, 7
    bind = $mainMod SHIFT, 8, movetoworkspace, 8
    bind = $mainMod SHIFT, 9, movetoworkspace, 9
    bind = $mainMod SHIFT, 0, movetoworkspace, 10

    # Mouse bindings
    bindm = $mainMod, mouse:272, movewindow
    bindm = $mainMod, mouse:273, resizewindow

    # Volume
    bind = , XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+
    bind = , XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-
    bind = , XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle

    # Brightness
    bind = , XF86MonBrightnessUp, exec, brightnessctl set 10%+
    bind = , XF86MonBrightnessDown, exec, brightnessctl set 10%-
  '';

  # Waybar config
  home.file.".config/waybar/config".text = builtins.toJSON {
    layer = "top";
    position = "top";
    height = 35;
    spacing = 4;
    
    modules-left = ["hyprland/workspaces" "hyprland/window"];
    modules-center = ["clock"];
    modules-right = ["tray" "network" "pulseaudio" "battery" "custom/telegram"];
    
    "hyprland/workspaces" = {
      disable-scroll = true;
      all-outputs = true;
      format = "{icon}";
      format-icons = {
        "1" = "一";
        "2" = "二";
        "3" = "三";
        "4" = "四";
        "5" = "五";
        "6" = "六";
        "7" = "七";
        "8" = "八";
        "9" = "九";
        urgent = "";
        focused = "";
        default = "";
      };
    };
    
    "hyprland/window" = {
      format = "{}";
      separate-outputs = true;
      max-length = 50;
    };
    
    clock = {
      format = "{:%H:%M   %d.%m.%Y}";
      tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
      format-alt = "{:%A, %B %d, %Y}";
    };
    
    battery = {
      states = {
        warning = 30;
        critical = 15;
      };
      format = "{icon}  {capacity}%";
      format-charging = "  {capacity}%";
      format-plugged = "  {capacity}%";
      format-alt = "{icon} {time}";
      format-icons = ["" "" "" "" ""];
    };
    
    network = {
      format-wifi = "  {essid}";
      format-ethernet = "  Connected";
      format-disconnected = "⚠  Disconnected";
      tooltip-format = "{ifname}: {ipaddr}/{cidr}";
      format-alt = "{ifname}: {ipaddr}/{cidr}";
    };
    
    pulseaudio = {
      format = "{icon}  {volume}%";
      format-bluetooth = "{icon}  {volume}%";
      format-muted = "  Muted";
      format-icons = {
        headphone = "";
        hands-free = "";
        headset = "";
        phone = "";
        portable = "";
        car = "";
        default = ["" "" ""];
      };
      on-click = "pavucontrol";
    };
    
    tray = {
      icon-size = 18;
      spacing = 10;
    };
    
    "custom/telegram" = {
      format = " ";
      on-click = "telegram-desktop";
      tooltip = false;
    };
  };

  # Waybar style
  home.file.".config/waybar/style.css".text = ''
    * {
        border: none;
        border-radius: 0;
        font-family: "JetBrainsMono Nerd Font", "Font Awesome 6 Free";
        font-size: 13px;
        min-height: 0;
    }

    window#waybar {
        background: rgba(40, 40, 40, 0.9);
        color: #ebdbb2;
    }

    #workspaces button {
        padding: 0 8px;
        background: transparent;
        color: #928374;
        border-bottom: 2px solid transparent;
        transition: all 0.3s;
    }

    #workspaces button.active {
        color: #d79921;
        border-bottom: 2px solid #d79921;
    }

    #workspaces button.urgent {
        color: #cc241d;
        border-bottom: 2px solid #cc241d;
    }

    #workspaces button:hover {
        background: rgba(60, 56, 54, 0.5);
        color: #ebdbb2;
    }

    #window {
        padding: 0 15px;
        color: #ebdbb2;
        font-weight: bold;
    }

    #clock {
        padding: 0 15px;
        color: #d79921;
        font-weight: bold;
        background: rgba(60, 56, 54, 0.3);
        border-radius: 8px;
        margin: 5px 0;
    }

    #battery {
        padding: 0 15px;
        color: #98971a;
        background: rgba(60, 56, 54, 0.3);
        border-radius: 8px;
        margin: 5px 5px 5px 0;
    }

    #battery.charging {
        color: #b8bb26;
    }

    #battery.warning:not(.charging) {
        color: #fabd2f;
    }

    #battery.critical:not(.charging) {
        color: #fb4934;
        animation: blink 0.5s linear infinite;
    }

    @keyframes blink {
        to {
            color: #cc241d;
        }
    }

    #network {
        padding: 0 15px;
        color: #689d6a;
        background: rgba(60, 56, 54, 0.3);
        border-radius: 8px;
        margin: 5px 5px 5px 0;
    }

    #network.disconnected {
        color: #fb4934;
    }

    #pulseaudio {
        padding: 0 15px;
        color: #83a598;
        background: rgba(60, 56, 54, 0.3);
        border-radius: 8px;
        margin: 5px 5px 5px 0;
    }

    #pulseaudio.muted {
        color: #928374;
    }

    #tray {
        padding: 0 10px;
        background: rgba(60, 56, 54, 0.3);
        border-radius: 8px;
        margin: 5px 5px 5px 0;
    }

    #tray > .passive {
        -gtk-icon-effect: dim;
    }

    #tray > .needs-attention {
        -gtk-icon-effect: highlight;
    }

    #custom-telegram {
        padding: 0 12px;
        color: #458588;
        background: rgba(60, 56, 54, 0.3);
        border-radius: 8px;
        margin: 5px 5px 5px 0;
        font-size: 16px;
    }

    #custom-telegram:hover {
        background: rgba(69, 133, 136, 0.3);
    }

    tooltip {
        background: rgba(40, 40, 40, 0.95);
        border: 1px solid #d79921;
        border-radius: 8px;
        color: #ebdbb2;
    }

    tooltip label {
        color: #ebdbb2;
    }
  '';

  # Wofi style
  home.file.".config/wofi/style.css".text = ''
    window {
        margin: 0px;
        border: 2px solid #d79921;
        background-color: #282828;
        border-radius: 12px;
    }

    #input {
        margin: 10px;
        padding: 10px;
        border: none;
        color: #ebdbb2;
        background-color: #3c3836;
        border-radius: 8px;
    }

    #inner-box {
        margin: 10px;
        border: none;
        background-color: #282828;
    }

    #outer-box {
        margin: 5px;
        border: none;
        background-color: #282828;
    }

    #scroll {
        margin: 0px;
        border: none;
    }

    #text {
        margin: 5px;
        border: none;
        color: #ebdbb2;
    }

    #entry:selected {
        background-color: #d79921;
        color: #282828;
        border-radius: 8px;
    }

    #entry:hover {
        background-color: #504945;
        border-radius: 8px;
    }
  '';

  # Kitty terminal config
  home.file.".config/kitty/kitty.conf".text = ''
    # Gruvbox theme
    foreground #ebdbb2
    background #282828
    
    color0  #282828
    color1  #cc241d
    color2  #98971a
    color3  #d79921
    color4  #458588
    color5  #b16286
    color6  #689d6a
    color7  #a89984
    color8  #928374
    color9  #fb4934
    color10 #b8bb26
    color11 #fabd2f
    color12 #83a598
    color13 #d3869b
    color14 #8ec07c
    color15 #ebdbb2
    
    # Font
    font_family JetBrainsMono Nerd Font
    font_size 11.0
    
    # Cursor
    cursor_shape beam
    cursor_blink_interval 0.5
    
    # Window
    window_padding_width 10
    background_opacity 0.95
    
    # Tab bar
    tab_bar_style powerline
    tab_powerline_style slanted
  '';

  # Dunst notification config
  home.file.".config/dunst/dunstrc".text = ''
    [global]
        font = JetBrainsMono Nerd Font 10
        
        # Geometry
        width = 300
        height = 300
        origin = top-right
        offset = 10x50
        
        # Progress bar
        progress_bar = true
        progress_bar_height = 10
        progress_bar_frame_width = 1
        
        # Transparency
        transparency = 10
        
        # Gruvbox colors
        frame_color = "#d79921"
        separator_color = frame
        
    [urgency_low]
        background = "#282828"
        foreground = "#ebdbb2"
        timeout = 5
        
    [urgency_normal]
        background = "#282828"
        foreground = "#ebdbb2"
        timeout = 10
        
    [urgency_critical]
        background = "#cc241d"
        foreground = "#ebdbb2"
        frame_color = "#fb4934"
        timeout = 0
  '';
}