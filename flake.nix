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
            ./modules/core/boot.nix
            ./modules/core/system.nix
            ./modules/core/locale.nix
            ./modules/core/networking.nix
            ./modules/core/users.nix
            ./modules/core/shell.nix
            ./modules/core/utils.nix
            ./modules/desktop/session.nix
            ./modules/desktop/audio.nix
            ./modules/desktop/fonts.nix
            ./modules/desktop/theme.nix
            ./modules/desktop/keyring.nix
            ./modules/desktop/apps.nix
            ./modules/desktop/gaming.nix
            ./modules/security/hardening.nix
            ./modules/services/backup.nix

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
