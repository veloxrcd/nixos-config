{
  description = "NixOS Flake Configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    
    termipedia = {
      url = "github:kantiankant/Termipedia";
       inputs.nixpkgs.follows = "nixpkgs";
    };

     areofyl-fetch = {
       url = "github:areofyl/fetch";
        inputs.nixpkgs.follows = "nixpkgs";
     };


      nix-flatpak = {
      url = "github:gmodena/nix-flatpak";
     };

    qylock = {
    url = "github:Darkkal44/qylock";
     inputs.nixpkgs.follows = "nixpkgs";
     };
     
   

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, home-manager, nix-flatpak, qylock, ... }@inputs: {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit inputs; };
      modules = [
        ./configuration.nix
        qylock.nixosModules.default
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.extraSpecialArgs = { inherit inputs; };
          home-manager.backupFileExtension = "backup";
          home-manager.users.mo = ./home.nix;
        }
      ];
    };
  };
}
