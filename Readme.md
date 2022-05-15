# Solana Nix Flake

This is repository contains Nix Flake for Solana development.

# How to use

Add this repo to your inputs and reference it in your devShell.

# Organization

### Top level flake

Copies and combines the following with the correct directory structure:

* patched `cargo-build-bpf`
* Solana provided BPF Rust and LLVM packages
* Solana CLI tools

### Patched `cargo-build-bpf`

`cargo-build-bpf` utility is provided as part of Solana CLI zip.  
But the default version has a quirk: it downloads the latest version of Solana BPF Tools (patched Rust & LLVM packages) to `~/.cache` regardless of whether one already exists at the path provided by `--bpf-sdk` or `$BPF_SDK_PATH`.  
So we patch the `install_if_missing()` function to do nothing.  
Despite the name, it will download and install the BPF Tools whether it's missing or not.  
Then in the top level flake, we are copying over our BPF Tools at the default location expected by `cargo-build-bpf`.

### `solana-bpf-tools`

Downloaded from Github releases and `autopatchelf`d

### `solana-cli`

Downloaded from Github releases and `autopatchelf`d

# Known Issues

* Consumes twice the disk space.
	We defined `solana-cli`, `solana-bpf-tools` and `cargo-build-bpf` as separate flakes.  
	They will take up space in `/nix/store` as they are built.  
	Then we are copying over all of them to a single package in the top-level flake.  
	This will create a new folder in `/nix/store` and consume equal amounts of space.  
	Any help is appreciated to help tackle this problem 🙏 .

* Only works on `x86_64-linux`.
	Currently I only have access to a 64bit Linux system.
	Issue/PR is welcome.
