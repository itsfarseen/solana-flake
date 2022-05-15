{
  description = "Solana";
  inputs = {
    solana-bpf-tools.url = "path:./solana-bpf-tools";
    solana-cli.url = "path:./solana-cli";
    cargo-build-bpf.url = "path:./cargo-build-bpf";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };
  outputs = inputs: with import inputs.nixpkgs { 
      system = "x86_64-linux";
  }; rec {
    packages.x86_64-linux.default = with import inputs.nixpkgs { 
      system = "x86_64-linux";
    }; stdenv.mkDerivation rec {
      name = "solana-${version}";
      version = "1.23.1";

      phases = [ "installPhase" ];

      installPhase = ''
        mkdir -p $out
        cp -rf ${inputs.solana-cli.packages.x86_64-linux.default}/* $out
        chmod 0755 -R $out;

        cp -rf ${inputs.cargo-build-bpf.packages.x86_64-linux.default}/* $out
        chmod 0755 -R $out;

        mkdir -p $out/bin/sdk/bpf
        cp -rf ${inputs.solana-bpf-tools.packages.x86_64-linux.default}/* $out/bin/sdk/bpf/
        chmod 0755 -R $out;
      '';

      meta = with lib; {
        homepage = "https://github.com/solana-labs";
        platforms = platforms.linux;
      };
    };

    devShells.x86_64-linux.default =  mkShellNoCC {
      packages = with packages.x86_64-linux; [
        default
      ];
    };
  };
}
