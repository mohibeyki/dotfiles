{
  config,
  lib,
  pkgs,
  ...
}:
{
  virtualisation.docker.rootless = {
    enable = true;
    setSocketVariable = true;
    daemon.settings.dns = lib.mkDefault config.networking.nameservers;
  };

  environment.systemPackages = with pkgs; [
    docker
    docker-compose
  ];
}
