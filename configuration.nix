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
    channel = "https://nixos.org/channels/nixos-22.05";
  };
  nix.gc.automatic = true;
  nix.autoOptimiseStore = true;


  ## Security

  security.sudo.execWheelOnly = true;
  nix.allowedUsers = [ "@wheel" ];


  ## Locale

  i18n.defaultLocale = "en_US.UTF-8";
  services.timesyncd.enable = true;
  services.xserver.layout = "us";
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


  ## Banish caps lock everywhere

  console.useXkbConfig = true;
  services.xserver.xkbOptions = "caps:escape";


  ## Package management

  environment.defaultPackages = lib.mkForce [];
  environment.systemPackages = with pkgs; [
    ack
    curl
    fish
    git
    htop
    perl
    stow
    tmux
    unzip
    (if config.services.xserver.enable then (vim_configurable.customize{
      name = "vim";
      vimrcConfig.customRC = "source ~/.vimrc";
      vimrcConfig.packages.myplugins = with pkgs.vimPlugins; {
        start = [ vim-fish vim-nix vim-ledger vim-terraform ];
        opt = [];
      };
    }) else vim)
    wget
  ];

}
