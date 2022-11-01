{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Website template
    hugo-coder = {
      url = github:luizdepra/hugo-coder;
      flake = false;
    };
  };

  outputs = inputs@{ self, nixpkgs, flake-parts, hugo-coder }:
    flake-parts.lib.mkFlake { inherit self; } {
      systems = [
        "x86_64-linux"
        "aarch64-linux"
      ];

      perSystem =
        { pkgs
        , self'
        , ...
        }: {
          packages = {

            hugo-coder =
              pkgs.runCommand "hugo-coder"
                {
                  src = hugo-coder;
                } ''
                cp -ra $src $out
              '';

            themes = pkgs.linkFarmFromDrvs "themes" [ self'.packages.hugo-coder ];

            default = pkgs.stdenvNoCC.mkDerivation {
              pname = "stunkymonkey-homepage";
              version = builtins.substring 0 8 self.lastModifiedDate;
              src = self;
              nativeBuildInputs = [
                pkgs.hugo
                # pkgs.asciidoctor
              ];
              HUGO_THEMESDIR = self'.packages.themes;
              buildPhase = ''
                runHook preBuild
                mkdir -p $out
                hugo --minify --destination $out
                runHook postBuild
              '';
              dontInstall = true;
              meta = with pkgs.lib; {
                description = "My awesome homepage";
                license = licenses.mit;
                platforms = platforms.all;
              };
            };

          };

          devShells.default = pkgs.mkShellNoCC {
            name = "home";
            inputsFrom = [
              self'.packages.default
            ];
            HUGO_THEMESDIR = self'.packages.themes;
          };
        };
    };
}
