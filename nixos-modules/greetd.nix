{
  inputs,
  pkgs,
  ...
}:
{
  services.displayManager = {
    # Both Hyprland and Plasma are registered by their respective NixOS modules.
    defaultSession = "hyprland-uwsm";
    dms-greeter = {
      enable = true;
      compositor.name = "hyprland";
      configHome = "/home/mohi";
      package = inputs.dms.packages.${pkgs.stdenv.hostPlatform.system}.default;
    };
  };

  # Preserve KDE Wallet unlock for Plasma sessions started through greetd.
  security.pam.services.greetd.kwallet.enable = true;
}
