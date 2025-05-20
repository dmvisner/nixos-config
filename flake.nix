{
  description = "NixOS WSL Configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";

    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nixos-wsl, home-manager, ...}@inputs: {
    nixosConfigurations.nixos-wsl = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit inputs; };
      modules = [
        nixos-wsl.nixosModules.wsl

        ./modules/configuration.nix

        home-manager.nixosModules.home-manager
        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            users.derek = import ./modules/home.nix;
          };
        }      

        ({ pkgs, lib, ...}: {
          wsl = {
            enable = true;
            defaultUser = "derek";
            startMenuLaunchers = true;
            wslConf.network.generateResolvConf = false;
          };
        })
      ];
    };
  };
}
