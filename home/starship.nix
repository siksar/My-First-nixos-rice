{ config, pkgs, ... }:

{
  programs.starship = {
    enable = true;
    enableZshIntegration = false;
    
    # settings - removed to allow dynamic config via STARSHIP_CONFIG env var
    # pointing to ~/.config/noctalia/generated/starship.toml
  };
}
