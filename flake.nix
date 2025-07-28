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
      in
      rec {
        packages = rec {
          dwmblocks = pkgs.stdenv.mkDerivation {
            src = self;
            name = "dwmblocks";
            buildInputs = with pkgs; [ xorg.libX11 pkg-config ];
            makeFlags = [ "PREFIX=$(out)" ];
          };
          default = dwmblocks;
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
