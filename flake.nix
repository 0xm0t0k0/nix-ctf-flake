{
  description = "0xm0t0k0's Research Lab";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
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
        buildInputs = [
          # Debuggers
          pkgs.gdb
          pkgs.pwndbg     
          pkgs.radare2
          pkgs.ghidra
          
          # Analysis
          pkgs.ltrace
          pkgs.strace
          pkgs.file
          pkgs.binwalk
          
          # Networking
          pkgs.netcat-gnu
          pkgs.nmap
          pkgs.socat
          
          # Compilers
          pkgs.gcc_multi
          
          # Python Environment
          (pkgs.python3.withPackages (ps: with ps; [
            pwntools
            ropper
            pycryptodome
            requests
          ]))
        ];

        #  (32-bit Support)
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
          echo " [+] UwUhackz Loaded (PsyOp Mode)."
          echo " [+] 32-bit as well :p."
        '';
      };
    };
}
