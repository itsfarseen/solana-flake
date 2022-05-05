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
    packages.x86_64-linux = rec {
      solana-cli = inputs.solana-cli.packages.x86_64-linux.default;
      solana-bpf-tools = inputs.solana-bpf-tools.packages.x86_64-linux.default;
      cargo-build-bpf-unwrapped = inputs.cargo-build-bpf.packages.x86_64-linux.default;
    };

    devShells.x86_64-linux.default =  mkShellNoCC {
      packages = with packages.x86_64-linux; [
        solana-cli
        solana-bpf-tools
        cargo-build-bpf-unwrapped
      ];
    };
  };
}
