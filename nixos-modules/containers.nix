{ pkgs, ... }:
{
  virtualisation.docker.rootless = {
    enable = true;
    setSocketVariable = true;
    daemon.settings = {
      dns = [
        "192.168.1.10"
        "1.1.1.1"
        "8.8.8.8"
      ];
    };
  };

  environment.systemPackages = with pkgs; [
    docker
    docker-compose
  ];
}
