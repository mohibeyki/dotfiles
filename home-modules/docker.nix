{
  home.sessionVariables.DOCKER_HOST = "unix://$XDG_RUNTIME_DIR/docker.sock";

  xdg.configFile."docker/daemon.json".text = builtins.toJSON {
    dns = [
      "192.168.1.10"
      "1.1.1.1"
      "8.8.8.8"
    ];
  };
}
