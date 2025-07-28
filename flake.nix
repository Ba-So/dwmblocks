{
  description = "dwmblocks";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, utils }:
    utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        
        # Import configuration generation logic
        configLib = import ./config.nix { inherit pkgs; };
        
        # Function to build dwmblocks with custom configuration
        mkDwmblocks = { blocks ? configLib.defaultBlocks, delimiter ? " " }:
          let
            configContent = configLib.generateConfigH { inherit blocks delimiter; };
          in
          pkgs.stdenv.mkDerivation {
            src = pkgs.lib.cleanSource self;
            name = "dwmblocks";
            buildInputs = with pkgs; [ xorg.libX11 pkg-config ];
            makeFlags = [ "PREFIX=$(out)" ];
            
            preBuild = ''
              cat > config.h << 'EOF'
              ${configContent}
              EOF
            '';
          };
      in
      rec {
        packages = rec {
          dwmblocks = mkDwmblocks {};
          default = dwmblocks;
        };
        
        # Function to create custom dwmblocks builds
        lib = {
          inherit mkDwmblocks;
        };
        
        devShell = pkgs.mkShell {
          nativeBuildInputs = with pkgs; [
            xorg.libX11
            pkg-config
          ];
        };
        
        apps = rec {
          dwmblocks = utils.lib.mkApp {
            drv = packages.dwmblocks;
          };
          default = dwmblocks;
        };
      }
    );
}
