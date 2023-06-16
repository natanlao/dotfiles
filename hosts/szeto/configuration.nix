{ config, pkgs, lib, ... }:

{
  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    kernelParams = ["cma=256M"];

    loader = {
      grub.enable = false;
      raspberryPi = {
        enable = true;
        version = 3;
        # Save power by disabling radios, HDMI
        firmwareConfig = ''
          hdmi_blanking=2
          dtoverlay=disable-wifi
          dtoverlay=disable-bt

          gpu_mem=256
        '';
      };
    };
  };

  environment.systemPackages = with pkgs; [
    libraspberrypi
  ];

  # Preserve space by sacrificing documentation and history
  documentation.nixos.enable = false;
  boot.cleanTmpDir = true;

  # Use 1GB of additional swap memory in order to not run out of memory
  # when installing lots of things while running other things at the same time.
  swapDevices = [ { device = "/swapfile"; size = 1024; } ];


  ## ---
  ## Normal config
  ## ---

  networking.hostName = "szeto";
  networking.wireless.enable = false;

  boot.tmpOnTmpfs = true;  # minimize writing to SD card

  networking.firewall.allowedTCPPorts = [ 53 8443 ];
  networking.firewall.allowedUDPPorts = [ 53 ];

  nixpkgs.config.allowUnfree = true;  # needed for unifi controller

  services = {
    adguardhome = {
      enable = true;
      mutableSettings = false;
      openFirewall = true;
      settings = {
        dns = {
          anonymize_client_ip = true;
          bind_host = "0.0.0.0";  # deprecated but fails without this for whatever reasopn
          bind_hosts = ["0.0.0.0"];
          bootstrap_dns = ["192.168.1.1"];
          cache_optimistic = true;
          upstream_dns = [
            # Quad9 with ECS
            "https://dns11.quad9.net/dns-query"
            "tls:dns11.quad9.net:853"
            # CloudFlare
            "https://1.1.1.1/dns-query"
            "tls:1.1.1.1:853"
            # Mullvad with no adblocking
            "https://doh.mullvad.net/dns-query"
            "tls:doh.mullvad.net:853"
          ];
          querylog_enabled = false;
        };
        querylog = {
          enabled = false;
          file_enabled = false;
        };
        filters = [
          { name = "suspicious-0"; enabled = true; url = "https://raw.githubusercontent.com/PolishFiltersTeam/KADhosts/master/KADhosts.txt"; }
          { name = "suspicious-1"; enabled = true; url = "https://raw.githubusercontent.com/FadeMind/hosts.extras/master/add.Spam/hosts"; }
          { name = "suspicious-2"; enabled = true; url = "https://v.firebog.net/hosts/static/w3kbl.txt"; }
          { name = "suspicious-3"; enabled = true; url = "https://raw.githubusercontent.com/matomo-org/referrer-spam-blacklist/master/spammers.txt"; }
          { name = "suspicious-4"; enabled = true; url = "https://someonewhocares.org/hosts/zero/hosts"; }
          { name = "suspicious-5"; enabled = true; url = "https://raw.githubusercontent.com/VeleSila/yhosts/master/hosts"; }
          { name = "suspicious-6"; enabled = true; url = "https://winhelp2002.mvps.org/hosts.txt"; }
          { name = "suspicious-7"; enabled = true; url = "https://v.firebog.net/hosts/neohostsbasic.txt"; }
          { name = "suspicious-8"; enabled = true; url = "https://raw.githubusercontent.com/RooneyMcNibNug/pihole-stuff/master/SNAFU.txt"; }
          { name = "suspicious-9"; enabled = true; url = "https://paulgb.github.io/BarbBlock/blacklists/hosts-file.txt"; }
          { name = "ads-0"; enabled = true; url = "https://adaway.org/hosts.txt"; }
          { name = "ads-1"; enabled = true; url = "https://v.firebog.net/hosts/AdguardDNS.txt"; }
          { name = "ads-2"; enabled = true; url = "https://v.firebog.net/hosts/Admiral.txt"; }
          { name = "ads-3"; enabled = true; url = "https://raw.githubusercontent.com/anudeepND/blacklist/master/adservers.txt"; }
          { name = "ads-4"; enabled = true; url = "https://s3.amazonaws.com/lists.disconnect.me/simple_ad.txt"; }
          { name = "ads-5"; enabled = true; url = "https://v.firebog.net/hosts/Easylist.txt"; }
          { name = "ads-6"; enabled = true; url = "https://pgl.yoyo.org/adservers/serverlist.php?hostformat=hosts&showintro=0&mimetype=plaintext"; }
          { name = "ads-7"; enabled = true; url = "https://raw.githubusercontent.com/FadeMind/hosts.extras/master/UncheckyAds/hosts"; }
          { name = "ads-8"; enabled = true; url = "https://raw.githubusercontent.com/bigdargon/hostsVN/master/hosts"; }
          { name = "ads-9"; enabled = true; url = "https://raw.githubusercontent.com/jdlingyu/ad-wars/master/hosts"; }
          { name = "tracking-0"; enabled = true; url = "https://v.firebog.net/hosts/Easyprivacy.txt"; }
          { name = "tracking-1"; enabled = true; url = "https://v.firebog.net/hosts/Prigent-Ads.txt"; }
          { name = "tracking-2"; enabled = true; url = "https://raw.githubusercontent.com/FadeMind/hosts.extras/master/add.2o7Net/hosts"; }
          { name = "tracking-3"; enabled = true; url = "https://raw.githubusercontent.com/crazy-max/WindowsSpyBlocker/master/data/hosts/spy.txt"; }
          { name = "tracking-4"; enabled = true; url = "https://hostfiles.frogeye.fr/firstparty-trackers-hosts.txt"; }
          { name = "tracking-5"; enabled = true; url = "https://hostfiles.frogeye.fr/multiparty-trackers-hosts.txt"; }
          { name = "tracking-6"; enabled = true; url = "https://www.github.developerdan.com/hosts/lists/ads-and-tracking-extended.txt"; }
          { name = "tracking-7"; enabled = true; url = "https://raw.githubusercontent.com/Perflyst/PiHoleBlocklist/master/android-tracking.txt"; }
          { name = "tracking-8"; enabled = true; url = "https://raw.githubusercontent.com/Perflyst/PiHoleBlocklist/master/SmartTV.txt"; }
          { name = "tracking-9"; enabled = true; url = "https://raw.githubusercontent.com/Perflyst/PiHoleBlocklist/master/AmazonFireTV.txt"; }
          { name = "tracking-10"; enabled = true; url = "https://gitlab.com/quidsup/notrack-blocklists/raw/master/notrack-blocklist.txt"; }
          { name = "malicious-0"; enabled = true; url = "https://raw.githubusercontent.com/DandelionSprout/adfilt/master/Alternate%20versions%20Anti-Malware%20List/AntiMalwareHosts.txt"; }
          { name = "malicious-1"; enabled = true; url = "https://osint.digitalside.it/Threat-Intel/lists/latestdomains.txt"; }
          { name = "malicious-2"; enabled = true; url = "https://s3.amazonaws.com/lists.disconnect.me/simple_malvertising.txt"; }
          { name = "malicious-3"; enabled = true; url = "https://v.firebog.net/hosts/Prigent-Crypto.txt"; }
          { name = "malicious-4"; enabled = true; url = "https://raw.githubusercontent.com/FadeMind/hosts.extras/master/add.Risk/hosts"; }
          { name = "malicious-5"; enabled = true; url = "https://bitbucket.org/ethanr/dns-blacklists/raw/8575c9f96e5b4a1308f2f12394abd86d0927a4a0/bad_lists/Mandiant_APT1_Report_Appendix_D.txt"; }
          { name = "malicious-6"; enabled = true; url = "https://phishing.army/download/phishing_army_blocklist_extended.txt"; }
          { name = "malicious-7"; enabled = true; url = "https://gitlab.com/quidsup/notrack-blocklists/raw/master/notrack-malware.txt"; }
          { name = "malicious-8"; enabled = true; url = "https://raw.githubusercontent.com/Spam404/lists/master/main-blacklist.txt"; }
          { name = "malicious-9"; enabled = true; url = "https://raw.githubusercontent.com/Te-k/stalkerware-indicators/master/generated/hosts"; }
          { name = "malicious-10"; enabled = true; url = "https://urlhaus.abuse.ch/downloads/hostfile/"; }
          { name = "malicious-11"; enabled = true; url = "https://v.firebog.net/hosts/Prigent-Malware.txt"; }
          { name = "malicious-12"; enabled = true; url = "https://v.firebog.net/hosts/Shalla-mal.txt"; }
          { name = "coins-0"; enabled = true; url = "https://zerodot1.gitlab.io/CoinBlockerLists/hosts_browser"; }
        ];
        user_rules = [
          "@@||t.co^$important"
          "@@||ct.sendgrid.net^$important"
        ];
        # os = {
        #   group = "adguard";
        #   user = "adguard";
        # };
        tls = {
          enabled = true;
          force_https = true;
        };
      };

    };

    openssh = {
      allowSFTP = false;
      enable = true;
      kbdInteractiveAuthentication = false;
      passwordAuthentication = false;
      # use mkForce to override /nixos/modules/profiles/installation-device.nix
      permitRootLogin = lib.mkForce "no";
    };

    sshd.enable = true;

    unifi = {
      enable = true;
      openFirewall = true;
      unifiPackage = pkgs.unifi7;
    };

    xserver.enable = false;
  };

  sound.enable = false;

  system.autoUpgrade = {
    enable = true;
    allowReboot = true;
    dates = "05:00";
    rebootWindow = {
      lower = "06:00";
      upper = "07:00";
    };
  };

  users.mutableUsers = false;
  users.groups.adguard = { };
  users.users."adguard" = {
    group = "adguard";
    description = "AdGuard Home";
    createHome = false;
    isSystemUser = true;
  };
  users.users.natan = {
    extraGroups = [ "wheel" ];
    hashedPassword = "$6$WDsCSXmcwPn4QmUM$k4BRv/mck71rEOM1oKsdPXrYzhGsJBhq5ImDul5r8JNnmlNJueOKN7bbQ.lLqs7h3UKUnyT8BVOOz31V3.1wH/";
    home = "/home/natan";
    isNormalUser = true;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIOFoiADQWwwEnaL6m28EV7d+L62RdTD+6ffVNkwLnFz"
    ];
  };

  system.stateVersion = "22.05";
}
