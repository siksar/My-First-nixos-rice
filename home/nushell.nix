{ config, pkgs, ... }:
{
  programs.nushell = {
    enable = true;
    
    # Environment variables
    environmentVariables = {
      EDITOR = "hx";
      VISUAL = "hx";
    };

    # Shell Aliases (Ported from Zsh)
    shellAliases = {
      ll = "ls -la";  # Nu's ls is already colorful and structured
      la = "ls -a";
      
      # NixOS
      rebuild = "cd /etc/nixos; git add .; git commit -m 'auto'; sudo nixos-rebuild switch --flake .#nixos";
      fullrebuild = "rebuild; home-manager switch --flake .#zixar";
      cleanup = "sudo nix-collect-garbage -d; sudo nix-store --optimize";
      
      # Editors
      v = "hx";
      vim = "hx";
      vi = "hx";
      
      # Git
      gs = "git status";
      ga = "git add";
      gc = "git commit";
      gp = "git push";
      gl = "git log --oneline -10";
      
      # Configs
      hypr = "hx ~/.config/hypr/hyprland.conf";
      conf = "z /etc/nixos"; # Using zoxide
    };
    
    # Extra Config
    extraConfig = ''
      $env.config = {
        show_banner: false,
        ls: {
          use_ls_colors: true,
          clickable_links: true,
        },
        rm: {
          always_trash: true, # Safety first!
        },
        table: {
          mode: "rounded", # Aesthetic table borders
        },
        # Integration with other tools
        completions: {
          external: {
            enable: true,
            max_results: 100,
          }
        }
      }
      
      # Zoxide hook is auto-added by programs.zoxide module
      # Starship hook is auto-added by programs.starship module
      # Carapace hook is auto-added by programs.carapace module
    '';
  };
  
  # Carapace - Multi-shell completion tailored for Nushell
  programs.carapace = {
    enable = true;
    enableNushellIntegration = true;
  };
}
