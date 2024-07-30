{ pkgs, lib, config, inputs, ... }:

{
  packages = with pkgs; [
    git
  ];

  pre-commit.hooks.prettier.enable = true;
}
