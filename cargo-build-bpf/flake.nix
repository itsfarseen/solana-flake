{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };
  outputs = inputs: {
    defaultPackage.x86_64-linux = with import inputs.nixpkgs { 
      system = "x86_64-linux";
    }; rustPlatform.buildRustPackage rec {
      pname = "solana-cargo-build-bpf";
      version = "1.10.11";

      src = fetchFromGitHub {
        owner = "solana-labs";
        repo = "solana";
        rev = "v${version}";
        hash = "sha256-m2nzpAzWEy5cVe7tCyOv3TC+yFQLQF4sMorTHLorttA=";
      };

      cargoHash = "sha256-gEZdqbXpBwpQzqChA8dDBwvJO+tCbjcnVqMNGAeCyrw=";

      nativeBuildInputs = [
        pkg-config
        perl
        cmake
        clang
        libclang.lib
      ];

      buildInputs = [
        udev
        clang
        libclang.lib
      ];

      LIBCLANG_PATH = "${libclang.lib}/lib";
      NIX_CFLAGS_COMPILE  = "-I${libclang.lib}/clang/11.1.0/include";

      doCheck = false;

      cargoPatches = [ ./patches/main.rs.diff ./patches/Cargo.toml.diff ./patches/Cargo.lock.diff ];

      meta = with lib; {
        homepage = "https://github.com/solana-labs/solana/tree/master/sdk/cargo-build-bpf";
        platforms = platforms.linux;
      };
    };
  };
}
