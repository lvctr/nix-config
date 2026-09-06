{
  description = "NixOS configuration: rainlily (desktop), riverlily (laptop), waterlily (test)";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
  };

  outputs = { self, nixpkgs, disko, home-manager, nixos-hardware, ... }@inputs:
    let
      system = "x86_64-linux";
      overlays = [ (import ./overlays) ];

      # NOTE: "you" is a placeholder username used throughout this repo
      # (modules/users.nix, home/*.nix). Replace every occurrence before
      # first install.
      username = "you";

      mkHost = { hostname, extraModules ? [ ] }:
        nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { inherit inputs username; };
          modules = [
            { nixpkgs.overlays = overlays; }

            disko.nixosModules.disko
            home-manager.nixosModules.home-manager

            # Shared modules. Nothing hardware-specific is allowed to live
            # in any of these - see hosts/<name>/ for that.
            ./modules/boot.nix
            ./modules/networking.nix
            ./modules/users.nix
            ./modules/shell.nix
            ./modules/fonts.nix
            ./modules/hardening.nix
            ./modules/backup.nix
            ./modules/desktop/hyprland.nix
            ./modules/desktop/audio.nix
            ./modules/desktop/theming.nix
            ./modules/desktop/keyring.nix
            ./modules/desktop/apps.nix
            ./modules/desktop/gaming.nix

            # This host's own hardware facts: disk layout, LUKS/TPM2 wiring,
            # CPU/GPU packages, hostname, timezone.
            ./hosts/${hostname}

            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.extraSpecialArgs = { inherit inputs; };
              home-manager.users.${username} = import ./home/${hostname}.nix;
            }
          ] ++ extraModules;
        };
    in
    {
      nixosConfigurations = {
        rainlily = mkHost {
          hostname = "rainlily";
          # No nixos-hardware import here on purpose - for a custom-built
          # desktop the generic component modules amounted to a handful of
          # lines we inlined directly in hosts/rainlily/default.nix instead.
        };

        riverlily = mkHost {
          hostname = "riverlily";
          extraModules = [ nixos-hardware.nixosModules.lenovo-thinkpad-x1-12th-gen ];
        };

        waterlily = mkHost {
          hostname = "waterlily";
          extraModules = [ nixos-hardware.nixosModules.lenovo-thinkpad-t480s ];
        };
      };
    };
}
