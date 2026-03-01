{
  inputs.nixpkgs.url = "github:nixos/nixpkgs";

  outputs = {nixpkgs, ...}: let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
  in {
    devShell.${system} = pkgs.mkShell {
      packages = with pkgs; [
        (python312.withPackages (ps:
          with ps; [
            pillow
            pycairo
            pygobject3
            syncedlyrics
          ]))
      ];
    };
  };
}
