{ config, pkgs, ... }:

let
  unstable = import <nixos-unstable> { config = { allowUnfree = true; }; };
in {
  networking = {
    dhcpcd.wait = "background";  # boot faster!
    hostId = "195126d9";
    hostName = "kyoshi";
  };

  boot = {
    initrd = {
      kernelModules = [ "amdgpu" ];
      luks.devices = {
        tank = {
          allowDiscards = true;
          device = "/dev/disk/by-uuid/900761b1-4830-487b-a73f-4f731df65612";
          preLVM = true;
        };
      };
    };

    loader = {
      timeout = 1;
      systemd-boot = {
        enable = true;
        configurationLimit = 30;
      };
      efi.canTouchEfiVariables = true;
    };

    supportedFilesystems = [ "zfs" ];
    tmp.useTmpfs = true;
  };

  fileSystems."/".options = [ "noatime" ];
  services.fstrim = {
    enable = true;
    interval = "weekly";
  };


  sound.enable = true;

  hardware = {
    cpu.amd.updateMicrocode = true;

    keyboard.zsa.enable = true;

    opengl = {
      driSupport = true;
      driSupport32Bit = true;
    };

    pulseaudio = {
      enable = true;
      support32Bit = true;
    };
  };

  # xserver
  services = {
    xserver = {
      enable = true;
      autorun = true;
      videoDrivers = [ "amdgpu" ];

      displayManager.autoLogin = {
        enable = true;
        user = "natan";
      };
      displayManager.defaultSession = "none+i3";

      windowManager.i3 = {
        enable = true;
        extraPackages = with pkgs; [dmenu i3status dunst xss-lock pa_applet];
     };
    };
  };
  programs.slock.enable = true;


  ## Package management

  nixpkgs.config.allowUnfree = true;
  environment.variables.TERMINAL = "alacritty";
  environment.systemPackages = with pkgs; [
    alacritty
    entr
    feh
    gnumake
    gocryptfs
    jq
    keepassxc
    libreoffice
    mupdf
    python3
    sqlite
    standardnotes
    thunderbird
    tree
    udiskie
    unstable.discord
    unstable.signal-desktop
    unstable.spotify
    vlc
    xclip
  ];
  programs.firefox = {
    enable = true;
    preferences = {
      "extensions.getAddons.showPane" = false;
      "extensions.htmlaboutaddons.recommendations.enabled" = false;
      "browser.shell.checkDefaultBrowser" = false;
      "browser.tabs.tabmanager.enabled" = false;
      "extensions.pocket.enabled" = false;
      "general.smoothScroll" = true;
    };
  };
  programs.steam.enable = true;
  virtualisation.docker = {
    enable = true;
    rootless = {
      enable = true;
      setSocketVariable = true;
    };
  };

  services.udisks2.enable = true;

  services.syncthing = {
    enable = true;
    configDir = "/home/natan/.config/syncthing";
    group = "users";
    openDefaultPorts = true;
    user = "natan";
  };

  # TODO: NixOS/nixpkgs#119984
  services.udev.packages = with pkgs; [
    yubikey-personalization
  ];

  location.provider = "geoclue2";
  services.redshift = {
    enable = true;
    brightness = {
      day = "1";
      night = "1";
    };
    temperature = {
      day = 5500;
      night = 3700;
    };
  };

  system.stateVersion = "20.09";
}
