{ inputs, pkgs, ... }:
{
  # packages.aarch64-darwin.default = inputs.fenix.packages.aarch64-darwin.minimal.toolchain;
  # packages.x86_64-linux.default = inputs.fenix.packages.x86_64-linux.minimal.toolchain;

  nixpkgs.overlays = [ inputs.fenix.overlays.default ];
  environment.systemPackages = with pkgs; [
    (fenix.complete.withComponents [
      "cargo"
      "clippy"
      "rust-src"
      "rustc"
      "rustfmt"
    ])
    rust-analyzer-nightly
  ];
}
