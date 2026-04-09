{ pkgs, ... }:
{
  virtualisation.docker.rootless = {
    enable = true;
    setSocketVariable = true;

    daemon.settings = {
      dns = [
        # Host systemd-resolved
        "127.0.0.53"
      ];
    };
  };

  environment.systemPackages = with pkgs; [
    docker
    docker-compose
  ];
}
