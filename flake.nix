{
  description = "Cyberdeck: Multi-Arch Research Lab";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
      
      # We explicitly grab the 32-bit package set
      pkgs32 = pkgs.pkgsi686Linux;
    in
    {
      devShells.${system}.default = pkgs.mkShell {
        # --- THE ARSENAL ---
        buildInputs = with pkgs; [
          # Debuggers (GDB handles both 32/64 automatically)
          gdb
          pwndbg
          radare2
          ghidra
          
          # Analysis
          ltrace
          strace
          file
          binwalk
          
          # Python & Pwn
          python3
          (python3.withPackages (ps: with ps; [
            pwntools
            ropper
            capstone
            pycryptodome
            requests
          ]))
          
          # Network
          netcat-gnu
          nmap
          socat
          
          # Compilers (Enable 32-bit compilation support)
          gcc_multi  # This will allow use of gcc -m32 to compile 32-bit binaries
        ];

        # HYBRID LOADER 
        # We mix both architecture libraries into the path so the binary can find what it needs.
        NIX_LD_LIBRARY_PATH = pkgs.lib.makeLibraryPath [
          # 64-bit Libs
          pkgs.stdenv.cc.cc
          pkgs.openssl
          pkgs.glib
          pkgs.zlib
          pkgs.glibc
          
          # 32-bit Libs 
          pkgs32.stdenv.cc.cc
          pkgs32.openssl
          pkgs32.glib
          pkgs32.zlib
          pkgs32.glibc
        ];
        
        # Point to the dynamic loader
        NIX_LD = pkgs.lib.fileContents "${pkgs.stdenv.cc}/nix-support/dynamic-linker";

        shellHook = ''
          echo " [+] UwUHackz Loaded  (Multi-Arch Capabilities)."
          echo " [+] 32-bit support active via NIX_LD."
        '';
      };
    };
}
