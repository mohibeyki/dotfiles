{ ... }:
{
  flake.nixosModules.containers =
    { pkgs, ... }:
    {
      virtualisation.docker = {
        enable = true;
        storageDriver = "btrfs";
      };

      environment.systemPackages = with pkgs; [
        docker
        docker-compose
        podman
        podman-compose
        podman-tui
      ];
    };
}
