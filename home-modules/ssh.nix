_: {
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    settings = {
      galadriel = {
        HostName = "192.168.1.16";
        User = "root";
      };
      nazgul = {
        HostName = "192.168.1.10";
        User = "mohi";
      };
      truenas = {
        HostName = "192.168.1.17";
      };
      sauron = {
        HostName = "192.168.1.11";
        User = "mohi";
      };
      legolas = {
        HostName = "192.168.1.12";
        User = "mohi";
      };
      deck = {
        HostName = "192.168.1.14";
        User = "deck";
      };
      elrond = {
        HostName = "elrond.biook.me";
        User = "mohi";
      };
    };
  };
}
