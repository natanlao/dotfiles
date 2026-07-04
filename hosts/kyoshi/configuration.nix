{
  config,
  lib,
  pkgs,
  ...
}:

let
  unstable = import <nixos-unstable> {
    config = {
      allowUnfree = true;
    };
  };
  src = pkgs.fetchFromGitHub {
    owner = "Silvenga";
    repo = "redlib";
    rev = "af002ab216d271890e715c2d3413f7193c07c640";
    hash = "sha256-Ny/pdBZFgUAV27e3wREPV8DUtP3XfMdlw0T01q4b70U=";
  };
  # Use Silvenga's wreq fork (redlib-org/redlib#544) which uses BoringSSL
  # to emulate browser TLS fingerprints and evade bot detection
  redlib-fork = unstable.redlib.overrideAttrs (oldAttrs: {
    version = "0.36.0-unstable-2026-04-04";
    inherit src;
    cargoDeps = unstable.rustPlatform.fetchCargoVendor {
      inherit src;
      name = "redlib-0.36.0-unstable-2026-04-04-vendor";
      hash = "sha256-eO3c7rlFna3DuO31etJ6S4c7NmcvgvIWZ1KVkNIuUqQ=";
    };
    # BoringSSL (via boring-sys2) needs cmake, go, git, perl, and libclang for bindgen
    nativeBuildInputs = (oldAttrs.nativeBuildInputs or []) ++ (with pkgs; [
      cmake
      go
      perl
      git
      rustPlatform.bindgenHook
    ]);
    checkFlags = (oldAttrs.checkFlags or []) ++ [
      "--skip=oauth::tests::test_generic_web_backend"
      "--skip=oauth::tests::test_mobile_spoof_backend"
    ];
  });
in
{
  networking = {
    dhcpcd.wait = "background"; # boot faster!
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
  security.polkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
  };

  programs.niri.enable = true;

  services.greetd = {
    enable = true;
    settings = rec {
      initial_session = {
        command = "${pkgs.niri}/bin/niri-session";
        user = "natan";
      };
      default_session = initial_session;
    };
  };

  services.logind.settings.Login = {
    HandlePowerKey = "poweroff";
  };

  services = {
    displayManager = {
      defaultSession = "niri";
    };
  };

  services.redlib = {
    enable = true;
    address = "127.0.0.1";
    package = redlib-fork;
  };

  services.rimgo.enable = true;
  services.rimgo.settings.ADDRESS = "127.0.0.1";

  programs.waybar.enable = true;

    ## Package management

  nixpkgs.config.allowUnfree = true;
  environment.variables.TERMINAL = "alacritty";
  environment.sessionVariables.DEFAULT_BROWSER = "${pkgs.firefox}/bin/firefox";
  xdg.mime = {
        enable                              =  true;
        defaultApplications = {
            "default-web-browser"           = [ "firefox.desktop" ];
            "text/html"                     = [ "firefox.desktop" ];
            "x-scheme-handler/http"         = [ "firefox.desktop" ];
            "x-scheme-handler/https"        = [ "firefox.desktop" ];
            "x-scheme-handler/about"        = [ "firefox.desktop" ];
            "x-scheme-handler/unknown"      = [ "firefox.desktop" ];
        };
    };

  environment.systemPackages = with pkgs; [
    alacritty
    unstable.anki
    entr
    feh
    fzf
    gnumake
    gocryptfs
    jq
    keepassxc
    libreoffice
    mupdf
    nixfmt
    python3
    sqlite
    swayidle
    swaylock
    thunderbird
    tree
    udiskie
    wl-clipboard
    vlc
    libnotify

    xwayland-satellite
    mako
    fuzzel
    rofi
    gammastep

    unstable.discord
    unstable.google-chrome
    unstable.obsidian
    unstable.signal-desktop
    unstable.spotify
    unstable.prismlauncher
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
          "install_url" =
            "https://addons.mozilla.org/firefox/downloads/latest/temporary-containers/latest.xpi";
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
    enableOnBoot = false;
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
