{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };
  outputs = inputs: {
    packages.x86_64-linux.default = with import inputs.nixpkgs { 
      system = "x86_64-linux";
    }; stdenv.mkDerivation rec {
      name = "solana-bpf-tools-${version}";
      version = "1.27";
      src = fetchzip {
        url = "https://github.com/solana-labs/bpf-tools/releases/download/v${version}/solana-bpf-tools-linux.tar.bz2";
        sha256 = "sha256-4aWBOAOcGviwJ7znGaHbB1ngNzdXqlfDX8gbZtdV1aA=";
        stripRoot = false;
      };

      nativeBuildInputs = [ autoPatchelfHook ];
      buildInputs = with pkgs; [
        zlib
        stdenv.cc.cc
        openssl
      ];

      installPhase = ''
        mkdir -p $out/dependencies/bpf-tools;
        cp -r $src/llvm $out/dependencies/bpf-tools/;
        cp -r $src/rust $out/dependencies/bpf-tools/;
        chmod 0755 -R $out;
      '';

      meta = with lib; {
        homepage = "https://github.com/solana-labs/bpf-tools/releases";
        platforms = platforms.linux;
      };
    };
  };
}
