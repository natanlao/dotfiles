{ config, lib, pkgs, ... }:

{
  imports = [
    ./host/configuration.nix
    ./host/hardware-configuration.nix
  ];

  ##  NixOS internals

  system.autoUpgrade = {
    enable = true;
    allowReboot = false;
    channel = "https://nixos.org/channels/nixos-21.05";
  };
  nix.gc.automatic = true;
  nix.autoOptimiseStore = true;


  ## Locale

  i18n.defaultLocale = "en_US.UTF-8";
  services.timesyncd.enable = true;
  services.xserver.layout = "us";
  time.timeZone = "America/Los_Angeles";


  ## User accounts

  environment.variables.EDITOR = "vim";
  programs.fish.enable = true;
  users.users.natan = {
    extraGroups = [ "wheel" ];
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

  environment.systemPackages = with pkgs; [
    ack
    curl
    fish
    git
    htop
    stow
    tmux
    unzip
    (if config.services.xserver.enable then vim_configurable else vim)
    wget
  ];
}
