{ config, pkgs, ... }:

{
  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    
    settings = builtins.fromTOML (builtins.readFile ./themes/tokyo-night.toml);
  };
}
