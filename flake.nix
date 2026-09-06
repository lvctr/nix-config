{
  description = "NixOS configuration: rainlily (desktop), riverlily (laptop), waterlily (test)";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, disko, home-manager, ... }@inputs:
    let
      system = "x86_64-linux";
      overlays = [ (import ./overlays) ];

      username = "aru";

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
            ./modules/system.nix
            ./modules/locale.nix
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
        };

        riverlily = mkHost {
          hostname = "riverlily";
        };

        waterlily = mkHost {
          hostname = "waterlily";
        };
      };
    };
}
