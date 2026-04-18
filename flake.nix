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

      in
        {
          apps.default = {
            type = "app";
            program = "${devApp}/bin/purs-typeclasses-dev";
          };

          devShells.default = pkgs.mkShell {
            buildInputs = buildDependencies ++ devOnlyDependencies;
          };
        }

    );
}
