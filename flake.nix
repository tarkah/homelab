{
  description = "Homelab";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.11";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
        };
      in
      with pkgs;
      {
        devShells.default = mkShell {
          shellHook = ''
            fish
          '';

          packages = [
            ansible
            just
            fish
            rsync

            (python3.withPackages (p: with p; [
              jinja2
              # requests
              # requests_toolbelt
            ]))
          ];
        };
      }
    );
}
