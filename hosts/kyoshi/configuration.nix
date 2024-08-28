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
    displayManager = {
      autoLogin = {
        enable = true;
        user = "natan";
      };
      defaultSession = "none+i3";
    };

    xserver = {
      enable = true;
      autorun = true;
      videoDrivers = [ "amdgpu" ];

      windowManager.i3 = {
        enable = true;
        extraPackages = with pkgs; [dmenu i3status dunst xss-lock pa_applet];
     };
    };
  };
  programs.slock.enable = true;

  services.libreddit.enable = true;
  services.libreddit.address = "127.0.0.1";

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
