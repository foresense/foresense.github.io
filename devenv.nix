{
  pkgs,
  lib,
  config,
  inputs,
  ...
}:
{
  languages.javascript = {
    enable = true;
    npm = {
      enable = true;
      install.enable = true;
    };
  };

  packages = with pkgs; [
    git
    tailwindcss
  ];

  pre-commit.hooks = {
    prettier.enable = true;
    nixfmt = {
      enable = true;
      package = pkgs.nixfmt-rfc-style;
    };
  };
}
