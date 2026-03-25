{ pkgs, ... }:
{
  virtualisation.docker = {
    enable = true;
  };

  environment.systemPackages = with pkgs; [
    docker
    docker-compose
    podman
    podman-compose
    podman-tui
  ];
}
