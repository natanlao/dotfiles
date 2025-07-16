{ config, lib, pkgs, ... }:

let
  unstable = import <nixos-unstable> { config = { allowUnfree = true; }; };
in {
  networking = {
    dhcpcd.wait = "background";  # boot faster!
    hostId = "195126d9";
    hostName = "kyoshi";
    dhcpcd.extraConfig = "nohook resolv.conf";
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

  hardware = {
    cpu.amd.updateMicrocode = true;

    keyboard.zsa.enable = true;
  };

  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
  };

  programs.niri.enable = true;

  services.logind.suspendKey = "poweroff";

  services = {
    displayManager = {
      autoLogin = {
        enable = true;
        user = "natan";
      };
      defaultSession = "niri";
    };
  };

  services.redlib = {
    enable = true;
    address = "127.0.0.1";
    package = unstable.redlib;
  };

  services.rimgo.enable = true;
  services.rimgo.settings.ADDRESS = "127.0.0.1";

  ## Package management

  nixpkgs.config.allowUnfree = true;
  environment.variables.TERMINAL = "alacritty";
  environment.systemPackages = with pkgs; [
    alacritty
    anki
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
    thunderbird
    tree
    udiskie
    vlc

    xwayland-satellite
    mako
    waybar
    fuzzel
    gammastep

    unstable.discord
    unstable.obsidian
    unstable.signal-desktop
    unstable.spotify
  ];
  fonts.packages = with pkgs; [ font-awesome ];
  programs.firefox = {
    enable = true;
    preferences = {
      "app.shield.optoutstudies.enabled" = false;
      "app.update.auto" = false;
      "browser.aboutConfig.showWarning" = false;
      "browser.safebrowsing.enabled" = false;
      "browser.send_pings" = false;
      "browser.shell.checkDefaultBrowser" = false;
      "browser.tabs.tabmanager.enabled" = false;
      "browser.urlbar.trimURLs" = false;
      "device.sensors.ambientLight.enabled" = false;
      "device.sensors.enabled" = false;
      "device.sensors.motion.enabled" = false;
      "device.sensors.orientation.enabled" = false;
      "device.sensors.proximity.enabled" = false;
      "dom.battery.enabled" = false;
      "dom.event.clipboardevents.enabled" = false;
      "dom.private-attribution.submission.enabled" = false;
      "dom.security.https_only_mode" = false;
      "dom.security.https_only_mode_ever_enabled" = false;
      "dom.webaudio.enabled" = false;
      "extensions.getAddons.showPane" = false;
      "extensions.htmlaboutaddons.recommendations.enabled" = false;
      "extensions.pocket.enabled" = false;
      "general.smoothScroll" = true;
      # "keyword.enabled" = false;
      "network.IDN_show_punycode" = true;
      "privacy.firstparty.isolate" = true;
      "privacy.query_stripping" = true;
      "privacy.trackingprotection.cryptomining.enabled" = true;
      "privacy.trackingprotection.enabled" = true;
      "privacy.trackingprotection.fingerprinting.enabled" = true;
      "privacy.trackingprotection.pbmode.enabled" = true;
      "privacy.usercontext.about_newtab_segregation.enabled" = true;
      "signon.autofillForms" = false;
    };
    policies = {
      "DisableFirefoxAccounts" = true;
      "DisableFirefoxStudies" = true;
      "DisableTelemetry" = true;
      "DisablePocket" = true;
      "ExtensionSettings" = {
        "TemporaryContainers@stoically" = {
          "install_url" = "https://addons.mozilla.org/firefox/downloads/latest/temporary-containers/latest.xpi";
          "installation_mode" = "normall_installed";
        };
        "uBlock0@raymondhill.net" = {
          "install_url" = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
          "installation_mode" = "normal_installed";
        };
      };
    };
  };
  programs.steam.enable = true;
  virtualisation.docker = {
    enable = true;
    rootless = {
      enable = false;
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

  powerManagement.cpuFreqGovernor = "powersave";

  # TODO: NixOS/nixpkgs#119984
  services.udev.packages = with pkgs; [
    yubikey-personalization
  ];

  services.printing.enable = true;
  services.printing.drivers = [ pkgs.brlaser ];

  system.stateVersion = "20.09";
}
