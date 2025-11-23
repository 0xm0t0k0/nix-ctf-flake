{
  description = "0xm0t0k0's Research Lab";

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
      
      pkgs32 = pkgs.pkgsi686Linux;
    in
    {
      devShells.${system}.default = pkgs.mkShell {
        buildInputs = with pkgs; [
          # Debuggers
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
            pycryptodome
            requests
          ]))
          
          # Networking
          netcat-gnu
          nmap
          socat
          
          # Compilers
          gcc_multi
        ];

        # --- THE LOADER (32-bit Support) ---
        NIX_LD_LIBRARY_PATH = pkgs.lib.makeLibraryPath [
          pkgs.stdenv.cc.cc
          pkgs.openssl
          pkgs.glib
          pkgs.zlib
          pkgs.glibc
          
          pkgs32.stdenv.cc.cc
          pkgs32.openssl
          pkgs32.glib
          pkgs32.zlib
          pkgs32.glibc
        ];
        
        NIX_LD = pkgs.lib.fileContents "${pkgs.stdenv.cc}/nix-support/dynamic-linker";

        shellHook = ''
          echo " [+] UwUHackz Loaded."
          echo " [+] 32-bit Support Active :p ."
        '';
      };
    };
}
