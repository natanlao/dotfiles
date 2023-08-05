{ config, pkgs, ... }:

let
  unstable = import <nixos-unstable> { config = { allowUnfree = true; }; };
in {
  networking = {
    hostId = "195126d9";
    hostName = "kyoshi";
  };

  ## Boot

  boot = {
    loader = {
      timeout = 1;
      systemd-boot = {
        enable = true;
        configurationLimit = 30;
      };

      efi.canTouchEfiVariables = true;
    };
    supportedFilesystems = [ "zfs" ];

    # We have enough memory and short-enough uptimes that writing /tmp to
    # RAM is not a problem
    tmp.useTmpfs = true;

  };

  ## Hardware

  fileSystems."/".options = [ "noatime" ];
  boot.initrd.luks.devices = {
    tank = {
      allowDiscards = true;
      device = "/dev/disk/by-uuid/900761b1-4830-487b-a73f-4f731df65612";
      preLVM = true;
    };
  };
  boot.initrd.kernelModules = [ "amdgpu" ];
  services.fstrim = {
    enable = true;
    interval = "weekly";
  };


  # Enable pulseaudio
  sound.enable = true;
  hardware.pulseaudio.enable = true;
  hardware.pulseaudio.support32Bit = true;  # TODO

  # CPU
  hardware.cpu.amd.updateMicrocode = true;

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
    firefox
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
  programs.steam.enable = true;
  virtualisation.docker = {
    enable = true;
    rootless = {
      enable = true;
      setSocketVariable = true;
    };
  };
  hardware.opengl.driSupport = true;
  hardware.opengl.driSupport32Bit = true;
  hardware.keyboard.zsa.enable = true;
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
