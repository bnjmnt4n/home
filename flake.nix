{
  description = "bnjmnt4n's NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nixpkgs-wayland.url = "github:colemickens/nixpkgs-wayland";
    emacs-overlay.url = "github:nix-community/emacs-overlay";
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs:
  {
    nixosConfigurations = {
      bnjmnt4n = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ({ ... }: { _module.args.inputs = inputs; })
          ./modules/overlays.nix
          ./hosts/bnjmnt4n/configuration.nix
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.bnjmnt4n = import ./hosts/bnjmnt4n/home.nix;
          }
        ];
      };
    };

    # Based on https://github.com/nix-community/home-manager/issues/1510#issuecomment-735034668.
    homeConfigurations = {
      wsl = inputs.home-manager.lib.homeManagerConfiguration {
        configuration = { ... }: {
          _module.args.inputs = inputs;
          imports = [
            ./modules/overlays.nix
            ./hosts/wsl/home.nix
          ];
        };
        system = "x86_64-linux";
        homeDirectory = "/home/bnjmnt4n";
        username = "bnjmnt4n";
      };
    };

    wsl = self.homeConfigurations.wsl.activationPackage;
    defaultPackage = {
      x86_64-linux = self.homeConfigurations.wsl.activationPackage;
    };
  };
}
