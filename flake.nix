{
  description = "foresense website";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    systems.url = "github:nix-systems/default";
    process-compose-flake.url = "github:Platonic-Systems/process-compose-flake";
  };

  outputs =
    inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = import inputs.systems;
      imports = with inputs; [ process-compose-flake.flakeModule ];

      perSystem =
        {
          pkgs,

          ...
        }:
        let
          python-environment = pkgs.python312.withPackages (
            pp: with pp; [
              ipython
              ipykernel
              django
              django-stubs
            ]
          );
        in
        {
          devShells = {
            default = pkgs.mkShell {
              name = "foresense";
              nativeBuildInputs = [ ];
              packages = with pkgs; [
                python-environment
                live-server
                superhtml
              ];
            };
          };

          process-compose = {
            foresense = {
              settings = {
                environment =
                  {
                  };
                processes = {
                  live-server.command = "${pkgs.live-server}/bin/live-server --hard --open";
                };
              };
            };
          };

          # formatter =
        };
    };
}
