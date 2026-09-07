{ lib, ... }:
{
  virtualisation.docker.rootless = {
    enable = true;
    setSocketVariable = true;
  };

  # Rootless Docker needs a real user's subordinate IDs, not a greeter account.
  systemd.user.services.docker.unitConfig.ConditionUser = lib.mkForce "!@system";
}
