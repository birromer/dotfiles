{
  description = "Dotfiles system configuration";

  # dependencies and whatever is needed
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  # packages that will be installed
  outputs = { self, nixpkgs }:

    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
      lib = nixpkgs.lib;
    in {
      nixosConfigurations = {
        birromer = lib.nixosSystem {
          inherit system;
          modules = [ ./hosts/s51/configurations.nix ];
        };
      };
    };

}
