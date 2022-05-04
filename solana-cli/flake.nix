{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };
  outputs = inputs: {
    defaultPackage.x86_64-linux = with import inputs.nixpkgs { 
      system = "x86_64-linux";
    }; stdenv.mkDerivation rec {
      name = "solana-cli";
      version = "1.10.11";
      filename = "solana-release-x86_64-unknown-linux-gnu.tar.bz2";
      src = fetchzip {
        url = "https://github.com/solana-labs/solana/releases/download/v${version}/${filename}";
        sha256 = "sha256-e/ubeRclr1B5B9CMGMhbue8XuxSK8bQbhXxXI1+IHF4=";
      };
      nativeBuildInputs = [ autoPatchelfHook pkgs.makeWrapper ];
      buildInputs = with pkgs; [
        sgx-sdk
        ocl-icd
        eudev
      ];

      installPhase = ''
        mkdir -p $out;
        cp -r bin $out;
        chmod 0755 -R $out;
      '';

      meta = with lib; {
        homepage = "https://docs.solana.com/cli/install-solana-cli-tools#download-prebuilt-binaries";
        platforms = platforms.linux;
      };
    };
  };
}
