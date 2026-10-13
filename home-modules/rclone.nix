{ pkgs, ... }:
{
  # Remotes are created with `rclone config` and stored in
  # ~/.config/rclone/rclone.conf. Do not put OAuth tokens in this flake.
  programs.rclone = {
    enable = true;
    package = pkgs.rclone;
  };
}
