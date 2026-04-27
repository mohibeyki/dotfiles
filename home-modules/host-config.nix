{
  lib,
  ...
}:
let
  inherit (lib) types;
in
{
  options.dotfiles.host = {
    isNvidia = lib.mkOption {
      type = types.bool;
      default = false;
      description = "Whether the current host uses NVIDIA-specific settings.";
    };

    gitSigningKey = lib.mkOption {
      type = types.str;
      description = "SSH public key used for Git signing on this host.";
    };

    gitAllowedSigners = lib.mkOption {
      type = types.listOf types.str;
      default = [ ];
      description = "Allowed SSH signers written to ~/.ssh/allowed_signers.";
    };

    monitors = lib.mkOption {
      type = types.listOf (
        types.submodule {
          options = {
            output = lib.mkOption { type = types.str; };
            mode = lib.mkOption { type = types.str; };
            position = lib.mkOption { type = types.str; };
            scale = lib.mkOption { type = types.number; };
            bitdepth = lib.mkOption { type = types.int; };
            vrr = lib.mkOption { type = types.int; };
            cm = lib.mkOption {
              type = types.nullOr types.str;
              default = null;
            };
            icc = lib.mkOption {
              type = types.nullOr types.str;
              default = null;
            };
          };
        }
      );
      default = [ ];
      description = "Per-host monitor definitions for Hyprland.";
    };

    workspaces = lib.mkOption {
      type = types.listOf types.str;
      default = [ ];
      description = "Per-host Hyprland workspace assignments.";
    };

  };
}
