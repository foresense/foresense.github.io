{
  description = "foresense website";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    systems.url = "github:nix-systems/default";
    process-compose-flake.url = "github:Platonic-Systems/process-compose-flake";
    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs =
    inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = import inputs.systems;
      imports = with inputs; [
        process-compose-flake.flakeModule
        treefmt-nix.flakeModule
      ];
      perSystem =
        { pkgs, ... }:
        {
          devShells = {
            default = pkgs.mkShell {
              name = "foresense";
              nativeBuildInputs = [ ];
              packages = with pkgs; [
                live-server
                superhtml
              ];
            };
          };
          process-compose = {
            foresense = {
              settings = {
                environment = { };
                processes = {
                  live-server.command = "${pkgs.live-server}/bin/live-server --open";
                };
              };
            };
          };
          treefmt = {
            projectRootFile = "flake.nix";
            programs = {
              nixfmt.enable = true;
              deno = {
                enable = true;
                excludes = [ "*.html" ];
              };
            };
            settings.formatter = {
              nixfmt = {
                options = [
                  "--strict"
                  "--verify"
                ];
              };
              superhtml = {
                command = "${pkgs.superhtml}/bin/superhtml";
                includes = [ "*.html" ];
                options = [ "fmt" ];
              };
            };
          };
        };
    };
}
