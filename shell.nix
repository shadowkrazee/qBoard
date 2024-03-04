{ pkgs ? import <nixpkgs> {} }:

pkgs.mkShell {
  buildInputs = [
    pkgs.xorg.libX11
    pkgs.xorg.libxcb
    pkgs.xorg.libXrender
    pkgs.xorg.libXfixes
    pkgs.xorg.libXext
    pkgs.rustup
    pkgs.gcc
  ];
}
