{
  description = "Development environment for xv6-riscv";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";

  outputs = { nixpkgs, ... }:
    let
      systems = [ "x86_64-linux" "aarch64-linux" ];
    in
    {
      devShells = nixpkgs.lib.genAttrs systems (system:
        let
          pkgs = import nixpkgs { inherit system; };
          cross = pkgs.pkgsCross.riscv64-embedded;
        in
        {
          default = pkgs.mkShell {
            packages = [
              cross.stdenv.cc
              pkgs.gdb
              pkgs.gnumake
              pkgs.qemu
              pkgs.perl
              pkgs.bc
              pkgs.clang-tools
            ];

            TOOLPREFIX = cross.stdenv.cc.targetPrefix;
            hardeningDisable = [ "all" ];
          };
        });
    };
}
