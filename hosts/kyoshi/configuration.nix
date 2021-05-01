{ config, pkgs, ... }:

let
  unstable = import <nixos-unstable> { config = { allowUnfree = true; }; };
in {
  networking.hostId = "195126d9";
  networking.hostName = "kyoshi";

  ## Boot

  boot.loader = {
    timeout = 1;
    # systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
    grub = {
      enable = true;
      device = "nodev";
      efiSupport = true;
      enableCryptodisk = true;
      extraConfig = "set timeout_style=hidden";
      splashImage = null;
      version = 2;
    };
  };

  # We have enough memory and short-enough uptimes that writing /tmp to
  # RAM is not a problem
  boot.tmpOnTmpfs = true;

  boot.supportedFilesystems = [ "zfs" ];


  ## Hardware

  # Using TRIM despite security implications for encrypted filesystems.
  # I would prefer to use continuous TRIM (i.e., `discard=async`) but that
  # requires kernel 5.6+, which I can't upgrade to currently with this GPU
  # (at time of writing) so periodic TRIM it is.
  fileSystems."/".options = [ "noatime" ];
  boot.initrd.luks.devices = {
    tank = {
      allowDiscards = true;
      device = "/dev/disk/by-uuid/900761b1-4830-487b-a73f-4f731df65612";
      preLVM = true;
    };
  };
  services.fstrim = {
    enable = true;
    interval = "weekly";
  };

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;
  networking.interfaces.enp4s0.useDHCP = true;
  networking.interfaces.wlp5s0.useDHCP = true;

  # Enable pulseaudio
  sound.enable = true;
  hardware.pulseaudio.enable = true;
  hardware.pulseaudio.support32Bit = true;  # TODO

  # CPU
  hardware.cpu.amd.updateMicrocode = true;
  powerManagement.cpuFreqGovernor = "performance";


  # xserver

  services = {
    xserver = {
      enable = true;
      autorun = true;
      videoDrivers = [ "nvidiaLegacy390" ];
      # dpi = 100;

      desktopManager.xterm.enable = false;

      displayManager.defaultSession = "none+i3";

      windowManager.i3 = {
        enable = true;
        extraPackages = with pkgs; [dmenu i3status i3lock dunst xss-lock pa_applet];
     };
    };
  };


  ## Package management

  nixpkgs.config.allowUnfree = true;
  environment.variables.TERMINAL = "alacritty";  # i3-sensible-terminal
  environment.systemPackages = with pkgs; [
    alacritty
    bc
    feh
    gotop
    jq
    mupdf
    thunderbird
    tree
    vlc
    xclip
    zfs

    unstable.discord
    unstable.firefox
    unstable.keepassxc
    unstable.minecraft
    unstable.spotify
    unstable.standardnotes
    # TODO: steam broken on unstable
    # unstable.steam
    unstable.syncthing
  ];
  programs.steam.enable = true;

  hardware.opengl.driSupport32Bit = true;

  services.syncthing = {
    enable = true;
    configDir = "/home/natan/.config/syncthing";
    group = "natan";
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
