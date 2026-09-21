#!/bin/sh
set -e

# Create folder structure
mkdir -p dotfiles/kitty
mkdir -p dotfiles/rofi
mkdir -p dotfiles/sway
mkdir -p dotfiles/waybar
mkdir -p dotfiles/zsh
mkdir -p modules/programs

# Clean out old conflicting files
rm -f hardware-configuration.nix
rm -f dotfiles/waybar/config.jsonc
rm -rf dotfiles/fish

# 1. flake.nix
cat << 'FILE_EOF' > flake.nix
{
  description = "NixOS Flake Configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    
    termipedia = {
      url = "github:kantiankant/Termipedia";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    areofyl-fetch = {
      url = "github:areofyl/fetch";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    qylock = {
      url = "github:Darkkal44/qylock";
      inputs.nixpkgs.follows = "nixpkgs";
    };
     
    zen-browser = {
      url = "github:youwen5/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs"; 
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, home-manager, qylock, ... }@inputs: {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      specialArgs = { inherit inputs; };
      modules = [
        ./configuration.nix
        { nixpkgs.hostPlatform = "x86_64-linux"; }
        qylock.nixosModules.default
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.extraSpecialArgs = { inherit inputs; };
          home-manager.backupFileExtension = "backup";
          home-manager.users.mo = import ./home.nix;
        }
      ];
    };
  };
}
FILE_EOF

# 2. configuration.nix
cat << 'FILE_EOF' > configuration.nix
{ pkgs, inputs, ... }:

{
  imports = [
    ./modules/core.nix
    ./modules/desktop.nix
    ./modules/networking.nix
    ./modules/sound.nix
    ./modules/services.nix
    ./modules/gaming.nix
    ./modules/programs
  ];

  environment.shellAliases = {
    rebuild = "cd ~/nixos-config && git add . && nh os switch . && nixsync";
    conf = "nvim ~/nixos-config/configuration.nix";
    homeconf = "nvim ~/nixos-config/home.nix";
    flakeconf = "nvim ~/nixos-config/flake.nix";
    deskconf = "nvim ~/nixos-config/modules/desktop.nix";
    servconf = "nvim ~/nixos-config/modules/services.nix";
    progconf = "nvim ~/nixos-config/modules/programs/default.nix";
    devconf = "nvim ~/nixos-config/modules/programs/dev.nix";
    gameconf = "nvim ~/nixos-config/modules/gaming.nix";
    nixdir = "cd ~/nixos-config && nvim .";
    nixsync = "cd ~/nixos-config/ && git add . && git commit -m \"Backup: \$(date -Iseconds)\" && git push origin main";
    clean = "nh clean all --keep 4";
    "," = "nix run nixpkgs#";
    dotdir = "cd ~/nixos-config/dotfiles && nvim .";
  };

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };

  boot.supportedFilesystems = [ "btrfs" ];
  boot.kernelPackages = pkgs.linuxPackages_latest;

  hardware.graphics.enable = true;
  hardware.bluetooth.enable = true;
  hardware.sensor.iio.enable = true;

  users.users.mo = {
    isNormalUser = true;
    extraGroups = [ "networkmanager" "wheel" "video" "audio" "docker" "gamemode" "libvirtd" "ydotool" ];
    shell = pkgs.zsh;
  };

  time.timeZone = "Europe/London";
  i18n.defaultLocale = "en_GB.UTF-8";

  system.stateVersion = "26.05";
}
FILE_EOF

# 3. home.nix
cat << 'FILE_EOF' > home.nix
{ pkgs, inputs, ... }:

{
  home.username = "mo";
  home.homeDirectory = "/home/mo";
  home.stateVersion = "26.05";

  programs.home-manager.enable = true;

  imports = [ 
    inputs.areofyl-fetch.homeManagerModules.default 
  ];

  programs.fetch.enable = true;

  home.sessionVariables = {
    EDITOR = "nvim";
  };

  xdg.configFile."sway".source = ./dotfiles/sway;
  xdg.configFile."kitty".source = ./dotfiles/kitty;
  xdg.configFile."waybar".source = ./dotfiles/waybar;
  xdg.configFile."rofi".source = ./dotfiles/rofi;

  home.file.".p10k.zsh".source = ./dotfiles/zsh/.p10k.zsh;

  home.packages = with pkgs; [
    pwvucontrol
    cliphist
    yazi
    wl-clipboard
    jetbrains-mono
    kitty
    slurp
    statix
    deadnix
    nixfmt
    fzf
    ripgrep
    fd
    nix-search-tv
    swaybg
    waybar
    autotiling
    librsvg
    rofimoji
    rofi
    swaylock-effects
    inputs.zen-browser.packages.${pkgs.system}.default
    fastfetch
    cmatrix
    lavat
  ];

  fonts.fontconfig.enable = true;
}
FILE_EOF

# 4. modules/core.nix
cat << 'FILE_EOF' > modules/core.nix
{ pkgs, ... }:

{
  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    auto-optimise-store = true;
  };

  nixpkgs.config.allowUnfree = true;

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  fonts.packages = with pkgs; [
    nerd-fonts.meslo-lg
    nerd-fonts.jetbrains-mono
    nerd-fonts.iosevka
  ];

  environment.systemPackages = with pkgs; [
    git
    curl
    wget
    unzip
    p7zip
    pciutils
    usbutils
  ];
}
FILE_EOF

# 5. modules/desktop.nix
cat << 'FILE_EOF' > modules/desktop.nix
{ pkgs, ... }:

{
  services.displayManager.sddm.wayland.enable = true;

  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
    package = pkgs.swayfx;
  };

  environment.systemPackages = with pkgs; [
    kdePackages.dolphin
  ];

  environment.sessionVariables = {
    KWIN_DRM_USE_TRIPLE_BUFFERING = "1";
  };

  programs.qylock = {
    enable = true;
    theme = "sword";
  };
}
FILE_EOF

# 6. modules/gaming.nix
cat << 'FILE_EOF' > modules/gaming.nix
{ pkgs, ... }:

{
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    gamescopeSession.enable = true;
  };

  programs.gamemode.enable = true;

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  environment.systemPackages = with pkgs; [
    heroic
    protonup-qt
    bottles
    wineWow64Packages.stable
  ];
}
FILE_EOF

# 7. modules/networking.nix
cat << 'FILE_EOF' > modules/networking.nix
_:

{
  networking = {
    hostName = "nixos";
    networkmanager.enable = true;

    firewall = {
      enable = true;
      allowedTCPPorts = [ ];
      allowedUDPPorts = [ ];
    };
  };
}
FILE_EOF

# 8. modules/services.nix
cat << 'FILE_EOF' > modules/services.nix
{ ... }:

{
  services.fwupd.enable = true;
  services.thermald.enable = true;
  services.input-remapper.enable = true;
  services.power-profiles-daemon.enable = true;
  services.flatpak.enable = true;
  services.blueman.enable = true;

  programs.ydotool.enable = true;

  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = true;
    };
  };

  security.doas = {
    enable = true;
    extraRules = [{
      users = [ "mo" ];
      keepEnv = true;
      persist = true;
    }];
  };
}
FILE_EOF

# 9. modules/sound.nix
cat << 'FILE_EOF' > modules/sound.nix
{ pkgs, ... }:

{
  services.pulseaudio.enable = false;

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  environment.systemPackages = with pkgs; [
    wireplumber
  ];
}
FILE_EOF

# 10. modules/programs/default.nix
cat << 'FILE_EOF' > modules/programs/default.nix
{ pkgs, inputs, ... }:

{
  imports = [
    ./dev.nix
  ];

  programs.nh = {
    enable = true;
    flake = "/home/mo/nixos-config";
  };

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestions.enable = true;
    syntaxHighlighting.enable = true;

    ohMyZsh = {
      enable = true;
      plugins = [ "git" "sudo" "colored-man-pages" ];
    };

    promptInit = ''
      source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme
      [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
    '';
  };

  environment.systemPackages = with pkgs; [
    zsh-powerlevel10k
    vlc
    mpv
    file-roller
    inputs.termipedia.packages.${system}.termipedia
    chromium
    wtype
  ];
}
FILE_EOF

# 11. modules/programs/dev.nix
cat << 'FILE_EOF' > modules/programs/dev.nix
{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    neovim
    gh
    gnumake
    gcc
    lua-language-server
    stylua
    tree-sitter
    docker-compose
    gnome-boxes
    obs-studio
    qemu
    virt-manager
    virt-viewer
    rot8
  ];

  virtualisation.libvirtd.enable = true;
  programs.virt-manager.enable = true;
  virtualisation.spiceUSBRedirection.enable = true;

  virtualisation.docker = {
    enable = true;
    enableOnBoot = false;
  };
}
FILE_EOF

# 12. dotfiles/sway/config
cat << 'FILE_EOF' > dotfiles/sway/config
set $mod Mod4 
set $term kitty 
set $filemanager kitty -e yazi 
set $browser zen 
set $menu rofi -show drun 
set $emoji rofimoji 
set $power_menu ~/.config/rofi/powermenu.sh 

output * bg ~/Downloads/rm-rf.jpg fill 

floating_modifier $mod normal

default_border pixel 1 
default_floating_border pixel 1 
smart_borders on 
smart_gaps on 

gaps inner 8 
gaps top 2 
gaps bottom 2 
gaps left 4 
gaps right 4 

corner_radius 10 

shadows enable 
shadow_color #000000cc 

blur enable 
blur_passes 2 
blur_radius 3 

animation_duration_ms 150 

client.focused          #ffffff #0b0b0b #ffffff #ffffff    #ffffff 
client.focused_inactive #222222 #0b0b0b #888888 #222222    #222222 
client.unfocused        #111111 #0b0b0b #555555 #111111    #111111 
client.urgent           #ffffff #222222 #ffffff #ffffff    #ffffff 
client.placeholder      #000000 #0c0c0c #ffffff #000000    #000000 

bindsym $mod+Return exec $term 
bindsym $mod+e exec $filemanager 
bindsym $mod+w exec $browser 
bindsym $mod+d exec $menu 
bindsym $mod+period exec $emoji 
bindsym $mod+Escape exec $power_menu 
bindsym $mod+q kill 
bindsym $mod+Shift+c reload 
bindsym $mod+Shift+e exec swaynag -t warning -m "Exit Sway?" -B "Yes" "swaymsg exit" 

bindsym $mod+h focus left 
bindsym $mod+j focus down 
bindsym $mod+k focus up 
bindsym $mod+l focus right 

bindsym $mod+Shift+h move left 
bindsym $mod+Shift+j move down 
bindsym $mod+Shift+k move up 
bindsym $mod+Shift+l move right 

bindsym $mod+p splith 
bindsym $mod+v splitv 
bindsym $mod+f fullscreen toggle 
bindsym $mod+a focus parent 

bindsym $mod+1 workspace number 1
bindsym $mod+2 workspace number 2
bindsym $mod+3 workspace number 3
bindsym $mod+4 workspace number 4
bindsym $mod+5 workspace number 5
bindsym $mod+6 workspace number 6
bindsym $mod+7 workspace number 7
bindsym $mod+8 workspace number 8
bindsym $mod+9 workspace number 9
bindsym $mod+0 workspace number 10

bindsym $mod+Shift+1 move container to workspace number 1
bindsym $mod+Shift+2 move container to workspace number 2
bindsym $mod+Shift+3 move container to workspace number 3
bindsym $mod+Shift+4 move container to workspace number 4
bindsym $mod+Shift+5 move container to workspace number 5
bindsym $mod+Shift+6 move container to workspace number 6
bindsym $mod+Shift+7 move container to workspace number 7
bindsym $mod+Shift+8 move container to workspace number 8
bindsym $mod+Shift+9 move container to workspace number 9
bindsym $mod+Shift+0 move container to workspace number 10

bindsym XF86AudioMute exec wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle 
bindsym XF86AudioLowerVolume exec wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%- 
bindsym XF86AudioRaiseVolume exec wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+ 
bindsym XF86AudioMicMute exec wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle 

bindsym XF86MonBrightnessDown exec brightnessctl set 5%- 
bindsym XF86MonBrightnessUp exec brightnessctl set 5%+ 

bindsym Print exec grim -g "$(slurp)" - | tee ~/Pictures/Screenshot_$(date +"%Y-%m-%d_%H-%M-%S").png | wl-copy 
bindsym Shift+Print exec grim - | tee ~/Pictures/Screenshot_$(date +"%Y-%m-%d_%H-%M-%S").png | wl-copy 

for_window [app_id=".*"] title_format "%title" 
for_window [app_id="pavucontrol"] floating enable, resize set 650 400 
for_window [app_id="blueman-manager"] floating enable, resize set 600 400 

exec_always pkill waybar; waybar 
exec_always pkill autotiling; autotiling
exec_always rot8

bindsym $mod+b exec /home/mo/.local/bin/bhop_toggle.sh
bindsym Mod1+space exec /home/mo/.local/bin/bhop_burst.sh
FILE_EOF

# 13. dotfiles/waybar/config
cat << 'FILE_EOF' > dotfiles/waybar/config
{
    "layer": "top",
    "position": "top",
    "height": 31,
    "margin-top": 5,
    "margin-bottom": 0,
    "modules-center": ["sway/workspaces", "clock", "network", "bluetooth", "pulseaudio", "battery", "tray"],
    
    "sway/workspaces": {
        "disable-scroll": true,
        "all-outputs": true,
        "format": "{name}"
    },
    "clock": {
        "format": "{:%H:%M}",
        "tooltip-format": "{:%Y-%m-%d}"
    },
    "network": {
        "format-wifi": "󰤨",
        "format-ethernet": "󰈀",
        "format-disconnected": "󰤭",
        "tooltip-format": "{essid}"
    },
    "bluetooth": {
        "format": "󰂯",
        "format-disabled": "󰂲",
        "format-connected": "󰂱",
        "tooltip-format": "{status}",
        "on-click": "blueman-manager"
    },
    "pulseaudio": {
        "format": "{icon}",
        "format-muted": "󰝟",
        "format-icons": {
            "default": ["󰕿", "󰖀", "󰕾"]
        },
        "tooltip-format": "{volume}%",
        "on-click": "pavucontrol"
    },
    "battery": {
        "format": "{icon}",
        "format-charging": "󰂄",
        "format-icons": ["󰂎", "󰁺", "󰁻", "󰁼", "󰁽", "󰁾", "󰁿", "󰂀", "󰂁", "󰂂", "󰁹"],
        "tooltip-format": "{capacity}%"
    },
    "tray": {
        "icon-size": 14,
        "spacing": 8
    }
}
FILE_EOF

# 14. dotfiles/waybar/style.css
cat << 'FILE_EOF' > dotfiles/waybar/style.css
* {
    border: none;
    border-radius: 0;
    font-family: "Iosevka Nerd Font", "Font Awesome 6 Free", sans-serif;
    font-size: 13px;
    font-weight: 600;
    min-height: 0;
}

window#waybar {
    background: transparent;
}

.modules-center {
    background: #0b0b0b;
    border: 1px solid #1a1a1a;
    border-radius: 10px;
    padding: 2px 10px;
}

#workspaces button {
    padding: 1px 8px;
    margin: 0 2px;
    color: #777777;
    background: transparent;
    border-radius: 6px;
    transition: all 0.15s ease-in-out;
}

#workspaces button.focused {
    color: #000000;
    background: #ffffff;
}

#workspaces button:hover {
    background: #1e1e1e;
    color: #ffffff;
}

#clock, #network, #bluetooth, #pulseaudio, #battery, #tray {
    padding: 0 8px;
    color: #e0e0e0;
}

#clock {
    color: #ffffff;
    font-weight: bold;
    border-left: 1px solid #222222;
    border-right: 1px solid #222222;
    margin: 0 6px;
    padding: 0 10px;
}

#network:hover, #bluetooth:hover, #pulseaudio:hover, #battery:hover {
    color: #ffffff;
    background: #161616;
    border-radius: 5px;
}

tooltip {
    background: #0b0b0b;
    border: 1px solid #1a1a1a;
    border-radius: 8px;
}

tooltip label {
    color: #ffffff;
    font-size: 12px;
    padding: 4px 8px;
}
FILE_EOF

# 15. dotfiles/rofi/config.rasi
cat << 'FILE_EOF' > dotfiles/rofi/config.rasi
configuration {
    modi: "drun,run";
    show-icons: true;
    font: "Iosevka Nerd Font 11";
    drun-display-format: "{name}";
}

@theme "/dev/null"

* {
    bg: #1e1e2e;
    bg-alt: #313244;
    fg: #cdd6f4;
    accent: #cba6f7;
    urgent: #f38ba8;

    background-color: transparent;
    text-color: @fg;
    margin: 0;
    padding: 0;
}

window {
    background-color: @bg;
    border: 2px;
    border-color: @accent;
    border-radius: 12px;
    width: 500px;
    padding: 20px;
}

inputbar {
    background-color: @bg-alt;
    border-radius: 8px;
    padding: 10px;
    children: [ entry ];
    margin: 0 0 10px 0;
}

entry {
    placeholder: "Search applications...";
    placeholder-color: #6c7086;
}

listview {
    lines: 8;
    columns: 1;
    fixed-height: false;
}

element {
    padding: 8px 12px;
    border-radius: 8px;
}

element selected {
    background-color: @accent;
    text-color: #11111b;
}

element-text {
    vertical-align: 0.5;
    text-color: inherit;
}

element-icon {
    size: 24px;
    margin: 0 10px 0 0;
}
FILE_EOF

# 16. dotfiles/rofi/powermenu.sh
cat << 'FILE_EOF' > dotfiles/rofi/powermenu.sh
#!/usr/bin/env zsh

lock="󰌾  Lock"
logout="󰍃  Logout"
suspend="󰤄  Suspend"
reboot="󰜎  Reboot"
shutdown="󰐥  Power Off"

chosen=$(printf "%s\n" "$lock" "$logout" "$suspend" "$reboot" "$shutdown" | rofi -dmenu -i -p "Power Menu")

case "$chosen" in
    "$lock")
        swaylock --screenshots --clock --indicator --indicator-radius 100 --indicator-thickness 7 --effect-blur 7x5 --effect-vignette 0.5:0.5 --ring-color bb9af7 --key-hl-color 7dcfff --line-color 00000000 --inside-color 1a1b2688 --separator-color 00000000 --grace 2 --fade-in 0.2
        ;;
    "$logout")
        swaymsg exit
        ;;
    "$suspend")
        systemctl suspend
        ;;
    "$reboot")
        systemctl reboot
        ;;
    "$shutdown")
        systemctl poweroff
        ;;
esac
FILE_EOF

chmod +x dotfiles/rofi/powermenu.sh

# 17. dotfiles/zsh/.p10k.zsh
cat << 'FILE_EOF' > dotfiles/zsh/.p10k.zsh
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(
  os_icon
  dir
  vcs
  newline
  prompt_char
)

POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(
  status
  command_execution_time
  background_jobs
  direnv
  nix_shell
)

POWERLEVEL9K_MODE='nerdfont-v2'
POWERLEVEL9K_ICON_PADDING=none
POWERLEVEL9K_PROMPT_ADD_NEWLINE=true
POWERLEVEL9K_INSTANT_PROMPT=quiet
FILE_EOF

# 18. dotfiles/kitty/kitty.conf
cat << 'FILE_EOF' > dotfiles/kitty/kitty.conf
font_family      Iosevka Nerd Font
bold_font        Iosevka Nerd Font Bold
italic_font      Iosevka Nerd Font Italic
bold_italic_font Iosevka Nerd Font Bold Italic
font_size        11.0

scrollback_lines        2000
repaint_delay           16
input_delay             3
sync_to_monitor         no
enable_audio_bell       no
update_check_interval   0

window_padding_width    12
confirm_os_window_close 0
background_opacity      0.88
background_blur         1

foreground           #ffffff
background           #0b0b0b
selection_foreground #000000
selection_background #ffffff
cursor               #ffffff
cursor_text_color    #000000

color0  #121212
color8  #444444
color1  #666666
color9  #888888
color2  #888888
color10 #aaaaaa
color3  #aaaaaa
color11 #cccccc
color4  #cccccc
color12 #dddddd
color5  #dddddd
color13 #eeeeee
color6  #eeeeee
color14 #ffffff
color7  #e0e0e0
color15 #ffffff
FILE_EOF

echo "Files generated successfully!"

# Git operations
if [ ! -d ".git" ]; then
    git init
    git branch -M main
    git remote add origin git@github.com:veloxrcd/nixos-config.git
fi

git add .
git commit -m "refactor: restructure repo, migrate to zsh/p10k, remove hardware-config"
git push -u origin main --force

echo "Pushed directly to GitHub!"
