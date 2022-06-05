{ lib, inputs, system, home-manager, user, ... }:

{
  s51 = lib.nixosSystem {
    inherit system;
    specialArgs = { inherit user inputs; };  # access variables inside flake
    modules = [
      ./s51
      ./configuration.nix

      home-manager.nixosModules.home-manager {
        home-manager.useGlobalPkgs = true;  # access packages as module
        home-manager.useUserPackages = true;
        home-manager.extraSpecialArgs = { inherit user; };  # use variables inside home-manager
        home-manager.users.${user} = {
          # import global home-manager configuration and specific for this build
          imports = [(import ./home.nix)] ++ [(import ./s51/home.nix)];
        };
      }
    ];
  };

  cosynus = lib.nixosSystem {
    inherit system;
    specialArgs = { inherit user inputs; };
    modules = [
      ./cosynus
      ./configuration.nix

      home-manager.nixosModules.home-manager {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.users.${user} = {
          imports = [(import ./home.nix)] + [(import ./cosynus/home.nix)];
        };
      }
    ];
  };

  vm = lib.nixosSystem {
    inherit system;
    specialArgs = { inherit user inputs; };
    modules = [
      ./vm
      ./configuration.nix

      home-manager.nixosModules.home-manager {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.users.${user} = {
          imports = [(import ./home.nix)] + [(import ./vm/home.nix)];
        };
      }
    ];
  };

}
