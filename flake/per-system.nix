{ inputs, ... }:
{
  perSystem =
    { pkgs, ... }:
    let
      src = inputs.self.outPath;
    in
    {
      formatter = pkgs.nixfmt;

      devShells.default = pkgs.mkShellNoCC {
        packages = with pkgs; [
          deadnix
          git
          nil
          nixfmt
          statix
        ];
      };

      checks = {
        nixfmt = pkgs.runCommand "nixfmt-check" { nativeBuildInputs = [ pkgs.nixfmt ]; } ''
          cd ${src}
          mapfile -t nix_files < <(find . -type f -name '*.nix')
          nixfmt --check "''${nix_files[@]}"
          touch "$out"
        '';

        deadnix = pkgs.runCommand "deadnix-check" { nativeBuildInputs = [ pkgs.deadnix ]; } ''
          cd ${src}
          deadnix --fail .
          touch "$out"
        '';

        statix = pkgs.runCommand "statix-check" { nativeBuildInputs = [ pkgs.statix ]; } ''
          cd ${src}
          statix check .
          touch "$out"
        '';
      };
    };
}
