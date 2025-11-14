{
  description = "CTF Development Environment with FHS support for 32-bit binaries";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        
        # Python environment with CTF tools
        pythonEnv = pkgs.python3.withPackages (ps: with ps; [
          pwntools
          pycryptodome
          requests
          ropper
          capstone
        ]);

      in
      {
        devShells.default = (pkgs.buildFHSEnv {
          name = "ctf-env";
          
          targetPkgs = pkgs: with pkgs; [
            # Reverse Engineering
            ghidra-bin
            radare2
            rizin
            cutter
            
            # Disassemblers & Decompilers
            binutils
            gdb
            lldb
            
            # Binary Analysis
            file
            hexdump
            xxd
            binwalk
            foremost
            ltrace
            strace
            
            # Exploitation Tools
            pythonEnv
            
            # Networking
            netcat-gnu
            nmap
            socat
            wireshark
            tcpdump
            
            # Cryptography
            openssl
            john
            hashcat
            
            # Assembly/Compilation
            gcc
            glibc
            clang
            nasm
            
            # Patching & Hex Editors
            patchelf
            hexedit
            
            # Web Tools
            curl
            wget
            
            # Utilities
            tmux
            git
            vim
            ripgrep
            fd
            bat
            jq
            
            # Misc
            qemu
            which
            
            # 32-bit libraries (CRITICAL for CTFs)
            pkgsi686Linux.glibc
            pkgsi686Linux.stdenv.cc.cc.lib
          ];
          
          # This is the key - it includes 32-bit support automatically
          multiPkgs = pkgs: with pkgs; [
            glibc
            gcc-unwrapped
            stdenv.cc.cc.lib
          ];
          
          runScript = "bash";
          
          profile = ''
            export PS1='\[\033[1;32m\][ctf-env]\[\033[0m\] \w \$ '
            
            echo " CTF Development Environment Loaded "
            echo ""
            echo "FHS Environment - 32-bit binaries should work"
            echo ""
            echo "Available Tools:"
            echo "  Reverse Engineering: ghidra-bin, radare2, cutter, rizin"
            echo "  Debugging: gdb, lldb"
            echo "  Binary Analysis: binwalk, file, hexdump, ltrace, strace"
            echo "  Exploitation: pwntools (Python), ropper"
            echo "  Networking: netcat, nmap, socat, "
            echo "  Crypto: openssl, john, hashcat"
            echo "  Assembly: nasm, gcc, clang"
            echo ""
            echo "Python packages: pwntools, ropper, capstone, pycryptodome"
            echo "
            
            # Set up some useful aliases
            alias gdb='gdb -q'
            alias r2='radare2'
            alias pwn='python3 -c "from pwn import *"'
          '';
        }).env;
      }
    );
}
