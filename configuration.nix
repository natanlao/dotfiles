{ config, lib, pkgs, ... }:

{
  imports = [
    ./host/configuration.nix
    ./host/hardware-configuration.nix
  ];

  ##  NixOS internals

  system.autoUpgrade = {
    enable = true;
    allowReboot = lib.mkDefault false;
    channel = "https://nixos.org/channels/nixos-25.05";
  };
  nix.gc.automatic = true;
  nix.gc.options = "--delete-older-than 10d";
  nix.settings.auto-optimise-store = true;


  ## Security

  security.sudo.execWheelOnly = true;
  nix.settings.allowed-users = [ "@wheel" ];


  ## Locale

  i18n.defaultLocale = "en_US.UTF-8";
  services.timesyncd.enable = true;
  services.xserver.xkb.layout = "us";
  time.timeZone = "America/Los_Angeles";


  ## User accounts

  environment.variables.EDITOR = "vim";
  programs.fish.enable = true;
  users.users.natan = {
    extraGroups = [ "wheel" "docker" ];
    isNormalUser = true;
    shell = pkgs.fish;
  };


  ## Networking

  hardware.bluetooth.enable = false;
  networking.firewall.enable = true;
  networking.wireless.enable = false;
  networking.wireless.userControlled.enable = false;

  ### DNS

  networking.nameservers = ["127.0.0.1" "::1"];

  services.dnscrypt-proxy2 = {
    enable = true;
    upstreamDefaults = false;

    settings = {
      block_unqualified = true;
      cache = true;
      dnscrypt_servers = true;
      doh_servers = true;
      ignore_system_dns = true;
      ipv4_servers = true;
      ipv6_servers = false;
      lb_strategy = "p2";
      listen_addresses = [ "127.0.0.1:53" ];
      max_clients = 50;
      require_dnssec = true;
      require_nofilter = false;
      require_nolog = true;

      server_names = [
        "cloudflare-security"
        "mullbad-base-doh"
        "quad9-dnscrypt-ip4-filter-ecs-pri"
        "wikimedia"
      ];

      sources.public-resolvers = {
        urls = [
          "https://raw.githubusercontent.com/DNSCrypt/dnscrypt-resolvers/master/v3/public-resolvers.md"
          "https://download.dnscrypt.info/resolvers-list/v3/public-resolvers.md"
        ];
        cache_file = "/var/lib/dnscrypt-proxy2/public-resolvers.md";
        minisign_key = "RWQf6LRCGA9i53mlYecO4IzT51TGPpvWucNSCh1CBM0QTaLn73Y7GFO3";
      };
    };
  };

  systemd.services.dnscrypt-proxy2.serviceConfig = {
    StateDirectory = "dnscrypt-proxy";
  };

  ## Banish caps lock everywhere

  console.useXkbConfig = true;
  services.xserver.xkb.options = "caps:escape";

  ## Package management

  environment.defaultPackages = lib.mkForce [];
  environment.systemPackages = with pkgs; [
    ack
    curl
    git
    htop
    stow
    unzip
    (if config.services.xserver.enable then (vim_configurable.customize{
      name = "vim";
      vimrcConfig.customRC = "source ~/.vimrc";
      vimrcConfig.packages.myplugins = with pkgs.vimPlugins; {
        start = [ vim-fish vim-nix vim-terraform ];
        opt = [];
      };
    }) else vim)
    wget
  ];

}
