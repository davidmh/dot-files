# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, inputs, pkgs, ... }:

{
  imports =
    [
      # Include the results of the hardware scan.
      ./hardware-configuration.nix
      # Include the necessary packages and configuration for Apple Silicon support.
      ./apple-silicon-support
    ];

  boot = {
    # Use the systemd-boot EFI boot loader.
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = false;
      grub.configurationLimit = 3;
    };

    # Add displayLink support through 
    extraModulePackages = [ config.boot.kernelPackages.evdi ];
    initrd = {
      # List of modules that are always loaded by the initrd.
      kernelModules = [
        "evdi"
      ];
    };
  };

  networking.hostName = "homelab";

  nixpkgs.config.allowUnfree = true;

  # Configure network connections interactively with nmcli or nmtui.
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/Los_Angeles";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkb.options in tty.
  # }; 

  # Enable the X11 windowing system.
  # services.xserver.enable = true;
  # services.xserver.desktopManager.xfce.enable = true;

  services.xserver = {
    enable = true;
    xkb.layout = "us";
  };

  # Enable touchpad
  services.libinput.enable = true;

  # services.displayManager.sddm.enable = true;

  # Enable thunderbolt
  services.hardware.bolt.enable = true;

  # Enable Displaylink
  # services.xserver.videoDrivers = [ "displaylink" "modesetting" ];

  # Specify path to peripheral firmware files.
  hardware.asahi.peripheralFirmwareDirectory = ./firmware;
  hardware.apple.touchBar.enable = true;

  hardware.bluetooth.enable = true;

  xdg.portal.enable = true;
  xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  xdg.portal.config.common.default = "*";

  # Configure keymap in X11
  # services.xserver.xkb.layout = "us";
  # services.xserver.xkb.options = "eurosign:e,caps:escape";

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  # services.pulseaudio.enable = true;
  # OR
  services.pipewire = {
    enable = true;
    pulse.enable = true;
    alsa.enable = true;
  };

  security.rtkit.enable = true;

  security.sudo.extraRules = [
    {
      users = [ "homelab" ];
      commands = [
        {
          command = "/run/current-system/sw/bin/nixos-rebuild";
          options = [ "NOPASSWD" ];
        }
      ];
    }
  ];

  # Enable touchpad support (enabled default in most desktopManager).
  # services.libinput.enable = true;

  users.defaultUserShell = pkgs.zsh;
  programs.zsh.enable = true;

  programs.nix-ld.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.homelab = {
    isNormalUser = true;
    extraGroups = [
      "wheel" # ‘sudo’ access
      "video" # GPU access
    ];
  };

  # System-wide packages
  environment.systemPackages = with pkgs; [
    accountsservice
    inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
  };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # D-Bus service for power management
  services.upower.enable = true;
  services.power-profiles-daemon.enable = true;

  # Enable zram to prevent OOM
  zramSwap.enable = true;
  # Enable earlyoom to prevent lockups
  services.earlyoom.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  fileSystems."/nix" = {
    device = "/dev/disk/by-label/nix-store";
    fsType = "ext4";
    neededForBoot = true;
  };

  nix.settings = {
    experimental-features = "nix-command flakes";
    trusted-users = [ "root" "homelab" ];
  };

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "25.11"; # Did you read the comment?

}
