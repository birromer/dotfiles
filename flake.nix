{
  description = "NixOS System Configuration";

  # dependencies and whatever is needed
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  # packages that will be installed
  outputs = { self, nixpkgs, home-manager }:

    let
      system = "x86_64-linux";
      user = "birromer";

      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };

      lib = nixpkgs.lib;

    in {
      nixosConfigurations = (
        import ./hosts {
          inherit (nixpkgs) lib;
          inherit inputs user system home-manager;
        }
      );

      # nixosConfigurations = {
      #   s51 = lib.nixosSystem {
      #     inherit system;
      #     modules = [
      #       ./hosts/s51/configuration.nix
      #       home-manager.nixosModules.home-manager {
      #         home-manager.useGlobalPkgs = true;
      #         home-manager.useUserPackages = true;
      #         home-manager.users.birromer = {
      #           imports = [ ./hosts/s51/home.nix ];
      #         };
      #       }
      #     ];
      #   };
      # };

      # hmConfig = {
      #   s51 = home-manager.lib.homeManagerConfiguration {
      #     inherit system pkgs;
      #     username = "${user}";
      #     homeDirectory = "/home/${user}";
      #     configuration = {
      #       imports = [
      #         ./hosts/s51/home.nix
      #       ];
      #     };
      #   };
      # };

    };

}
