{
  description = "Zixar's NixOS Configuration";
  
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    
    # Hyprland - Latest features
    hyprland.url = "github:hyprwm/Hyprland";
    
    # CachyOS Kernel - Performance optimized
    nix-cachyos-kernel = {
      url = "github:xddxdd/nix-cachyos-kernel/release";
      # Do NOT override nixpkgs - prevents version mismatch
    };
  };
  
  outputs = { self, nixpkgs, home-manager, hyprland, nix-cachyos-kernel, ... }: {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      
      specialArgs = { inherit hyprland; };
      
      modules = [
        ./configuration.nix
        
        # CachyOS Kernel overlay
        ({ pkgs, ... }: {
          nixpkgs.overlays = [
            nix-cachyos-kernel.overlays.pinned
          ];
        })
        
        # Hyprland NixOS module
        hyprland.nixosModules.default
      ];
    };

    # Standalone Home Manager Configuration
    homeConfigurations."zixar" = home-manager.lib.homeManagerConfiguration {
      pkgs = nixpkgs.legacyPackages.x86_64-linux;
      extraSpecialArgs = { inherit hyprland; };
      modules = [
        ./home.nix
      ];
    };
  };
}
