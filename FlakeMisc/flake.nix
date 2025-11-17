{
  description = "0xm0t0k0's CTF lab";

  nixConfig = {
    extra-substituters = [
      "https://pwndbg.cachix.org"
    ];
    extra-trusted-public-keys = [
      "pwndbg.cachix.org-1:HhtIpP7j73SnuzLgobqqa8LVTng5Qi36sQtNt79cD3k="
    ];
  };

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    
    pwndbg = {
      url = "github:pwndbg/pwndbg";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, flake-utils, pwndbg }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        
        
        pwndbg-gdb = pwndbg.packages.${system}.pwndbg;
        
        # Python environment setup
        pythonEnv = pkgs.python3.withPackages (ps: with ps; [
          pwntools
          pycryptodome
          requests
          ropper
          capstone
           z3-solver
           unicorn
           keystone-engine
        ]);

      in
      {
        devShells.default = (pkgs.buildFHSEnv {
          name = "ctf-env";
          
          targetPkgs = pkgs: [
            # Reverse Engineering
            pkgs.ghidra-bin
            pkgs.radare2
            pkgs.rizin
            pkgs.cutter
            
            # Debugging
            pkgs.gdb
            pwndbg-gdb
            pkgs.lldb
            
            # Binary Analysis
            pkgs.file
            pkgs.hexdump
            pkgs.xxd
            pkgs.binwalk
            pkgs.foremost
            pkgs.ltrace
            pkgs.strace
            
            # Exploitation Tools
            pythonEnv
            
            # Networking
            pkgs.netcat-gnu
            pkgs.nmap
            pkgs.socat
            pkgs.wireshark
            pkgs.tcpdump
            
            # Cryptography
            pkgs.openssl
            pkgs.john
            pkgs.hashcat
            
            # Assembly/Compilation
            pkgs.gcc
            pkgs.glibc
            pkgs.clang
            pkgs.nasm
            
            # Patching & Hex Editors
            pkgs.patchelf
            pkgs.hexedit
            
            # Web Tools
            pkgs.curl
            pkgs.wget
            
            # Utilities
            pkgs.tmux
            pkgs.git
            pkgs.vim
            pkgs.ripgrep
            pkgs.fd
            pkgs.bat
            pkgs.jq
            pkgs.which
            
            # Misc
            pkgs.qemu
            
            # 32-bit libraries
            pkgs.pkgsi686Linux.glibc
            pkgs.pkgsi686Linux.stdenv.cc.cc.lib
          ];
          
          # Multi-arch support for 32-bit binaries
          multiPkgs = pkgs: with pkgs; [
            glibc
            gcc-unwrapped
            stdenv.cc.cc.lib
          ];
          
          runScript = "bash";
          
          profile = ''
            export PS1='\[\033[1;32m\][ctf-env]\[\033[0m\] \w \$ '
            
            # Configure pwndbg
            # The pwndbg package provides gdbinit.py
            if [ -d "${pwndbg-gdb}/share/pwndbg" ]; then
              echo "source ${pwndbg-gdb}/share/pwndbg/gdbinit.py" > ~/.gdbinit
            fi
            
            echo "Welcome to the lab"
            echo ""
            echo "FHS Environment so that 32-bit binaries work out of the box hihi"
            echo ""
            echo "Available Tools:"
            echo "  Reverse Engineering: ghidra-bin, radare2, cutter, rizin"
            echo "  Debugging: gdb with pwndbg, lldb"
            echo "  Binary Analysis: binwalk, file, hexdump, ltrace, strace"
            echo "  Exploitation: pwntools (Python), ropper"
            echo "  Networking: netcat, nmap, socat, wireshark"
            echo "  Crypto: openssl, john, hashcat"
            echo "  Assembly: nasm, gcc, clang"
            echo ""
            echo "Python packages: pwntools, ropper, capstone, pycryptodome, z3-solver, unicorn, keystone-engine"
            echo ""
            echo "Have fun hacking"
            echo ""
            
            # you can also set up useful aliases
            alias gdb='gdb -q'
            alias r2='radare2'
            alias pwn='python3 -c "from pwn import *"'
            
            # Ensure 32-bit libraries are available in case of bugs with 32-bit executables
            export LD_LIBRARY_PATH="${pkgs.pkgsi686Linux.glibc}/lib:${pkgs.pkgsi686Linux.stdenv.cc.cc.lib}/lib:$LD_LIBRARY_PATH"
            export GLIBC_32="${pkgs.pkgsi686Linux.glibc}"
          '';
        }).env;
      }
    );
}
