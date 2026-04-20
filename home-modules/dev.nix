{ pkgs, config, ... }:
{
  home.packages =
    (with pkgs.llm-agents; [
      claude-code
      opencode
    ])
    ++ [
      (pkgs.symlinkJoin {
        name = "pi-coding-agent";
        buildInputs = [ pkgs.makeWrapper ];
        paths = [ pkgs.llm-agents.pi ];
        postBuild = ''
          wrapProgram $out/bin/pi \
            --set NPM_CONFIG_PREFIX ${config.home.homeDirectory}/.pi/npm \
            --prefix PATH : ${pkgs.lib.makeBinPath [ pkgs.nodejs ]}
        '';
      })
    ];

  home.file = {
    ".pi/agent/extensions/footer.ts".source = ./pi/extensions/footer.ts;
    ".pi/agent/themes/personal.json".source = ./pi/themes/personal.json;
  };
}
