{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs { inherit system; };

        buildDependencies = [
          pkgs.elmPackages.elm
          pkgs.elmPackages.elm-live
          pkgs.dhall
          pkgs.dhall-json
          pkgs.http-server
        ];

        devOnlyDependencies = [
          pkgs.dhall-lsp-server
          pkgs.elmPackages.elm-format
          pkgs.elmPackages.elm-language-server
        ];

        devApp = pkgs.writeShellApplication {
          name = "purs-typeclasses-dev";
          runtimeInputs = buildDependencies;
          text = ''
            elm-live ./src/Main.elm --start-page=./index.html -- --output=./app.js
          '';
        };

        buildApp = pkgs.writeShellApplication {
          name = "purs-typeclasses-build";
          runtimeInputs = [ pkgs.elmPackages.elm pkgs.dhall-json ];
          text = ''
            dhall-to-json --file ./classes.dhall > ./gen/purs-typeclasses.json
            elm make src/Main.elm --optimize --output=app.js
          '';
        };

      in
        {
          apps.default = {
            type = "app";
            program = "${devApp}/bin/purs-typeclasses-dev";
          };

          apps.build = {
            type = "app";
            program = "${buildApp}/bin/purs-typeclasses-build";
          };

          devShells.default = pkgs.mkShell {
            buildInputs = buildDependencies ++ devOnlyDependencies;
          };
        }

    );
}
