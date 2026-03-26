{
  description = "A flake that loads some packages and provides a dev shell for development.";
  
  inputs = {
    nixpkgs.url = "nixpkgs";
    flake-utils.url = "github:numtide/flake-utils";
  };

  
  outputs = { nixpkgs, flake-utils, ... }:
    let
      supportedSystems = [
        "x86_64-linux"
        "aarch64-linux"
      ];
      
    in {
      nixosModules.default = { ... }: {};
    } // flake-utils.lib.eachSystem supportedSystems (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          config.allowUnfree = true;
          environment.sessionVariables = {
	          NIXOS_OZONE_WL = "1";
          };
        };
        # "User environment" inside the devshell
        userEnv = pkgs.buildEnv {
          name = "user-env";
          paths = [
            pkgs.vscode        # VS Code behaves like a user package
          ];
        };
      in {
        devShells.default = pkgs.mkShell {
          packages = with pkgs; [
            bashInteractive
            userEnv   # add the "user-env" to the devshell
            jdk21_headless
          ];
          shellHook = ''
            echo "Starting VS Code..."
            code .
          '';
        };
      }
    );
}
