_: {
  programs.noctalia = {
    enable = true;
    systemd.enable = false;
    settings = ../noctalia.toml;
  };
}
