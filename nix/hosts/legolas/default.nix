{ self, ... }:
{
  environment.systemPackages = [ ];

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;

  # Touch ID sudo!
  security.pam.enableSudoTouchIdAuth = true;

  # programs.fish.shellInit = ''
  #   for p in /run/current-system/sw/bin
  #     if not contains $p $fish_user_paths
  #       set -g fish_user_paths $p $fish_user_paths
  #     end
  #   end
  # '';

  # Set Git commit hash for darwin-version.
  system.configurationRevision = self.rev or self.dirtyRev or null;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;

  # The platform the configuration will be used on.
  nixpkgs.hostPlatform = "aarch64-darwin";
}
