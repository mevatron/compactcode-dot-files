{ config, pkgs, ... }:

let 
  theme = import ./home/theme.nix;
  wallpaperSmall = pkgs.copyPathToStore ./art/wallpaper-1280x720.jpg;
  wallpaperLarge = pkgs.copyPathToStore ./art/wallpaper-3480x2160.jpg;

in {
  system.stateVersion = "19.03";

  imports =
    [
      # NOTE: Run `nixos-generate-config` to generate.
      /etc/nixos/hardware-configuration.nix
      # NOTE: Requires git to be installed before `nixos-install` will work.
      "${builtins.fetchGit {
        ref = "release-19.03";
        url = "https://github.com/rycee/home-manager";
      }}/nixos"
    ];

  boot.loader = {
    efi = {
      canTouchEfiVariables = false;
    };
    systemd-boot = {
      enable = true;
    };
  };

  networking.hostName = "nixbox";

  time.timeZone = "Australia/Melbourne";

  environment.systemPackages = with pkgs; [
    dash
    firefox
    feh
    fzy
    git
    ripgrep
    zsh
  ];

  fonts = {
    fonts = with pkgs; [
      source-code-pro
      source-sans-pro
      source-serif-pro
      font-awesome_4
      font-awesome_5
    ];

    fontconfig = {
      defaultFonts = {
        monospace = [ "Source Code Pro" ];
        sansSerif = [ "Source Sans Pro" ];
        serif     = [ "Source Serif Pro" ];
      };
    };
  };

  services.xserver = {
    enable = true;

    desktopManager = {
      default = "none";

      xterm = {
        enable = false;
      };

      wallpaper = {
        mode = "fill";
      };
    };

    displayManager.lightdm ={
      enable = true;

      greeters.mini = {
        enable = true;
        user   = "shandogs";
        extraConfig = ''
          [greeter]
          show-password-label = false

          [greeter-theme]
          background-image = "${wallpaperSmall}"
          background-color = "${theme.black}"
          window-color     = "${theme.darker}"
          border-color     = "${theme.darkest}"
          text-color       = "${theme.lightest}"
          error-color      = "${theme.warning}"
        '';
      };
    };

    windowManager = {
      i3 = {
        enable = true;

        package = pkgs.i3-gaps;

        extraPackages = with pkgs; [
          i3status-rust
        ];
      };
    };

  };

  services.compton = {
    enable    = true;
    fade      = true;
    fadeDelta = 5;
    activeOpacity   = "0.9";
    inactiveOpacity = "0.8";
  };

  users = {
    defaultUserShell = pkgs.zsh;

    users = {
      root = {
        hashedPassword = "$6$Ol1IgIkZqEqHkDk$X51v4AgMAKXhqpMjfM451dvu71YnMlYdK4lZk/ZFx0m4A/eEPuUfMAYyYwVNjDHMtoNXz6QeoSQg4lHQtHtzX1";
      };

      shandogs = {
        isNormalUser = true;
        extraGroups = [ "wheel" ];
        hashedPassword = "$6$Ol1IgIkZqEqHkDk$X51v4AgMAKXhqpMjfM451dvu71YnMlYdK4lZk/ZFx0m4A/eEPuUfMAYyYwVNjDHMtoNXz6QeoSQg4lHQtHtzX1";
      };
    };
  };

  home-manager.users.shandogs = { pkgs, ... }: {
    imports = [
      ./home/alacritty.nix
      ./home/git.nix
      ./home/i3.nix
      ./home/neovim.nix
      ./home/rofi.nix
      ./home/skim.nix
      ./home/zsh.nix
    ];

    home.file.".background-image".source = wallpaperLarge;
  };
}
