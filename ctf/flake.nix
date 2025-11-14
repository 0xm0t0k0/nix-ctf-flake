{
  description = "CTF Development Environment for Reverse Engineering and Binary Exploitation";

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
          # z3 # Uncomment if needed - can be heavy
          # angr # Binary analysis - uncomment if needed (large dependencies)
          ropper
          capstone
          # keystone-engine # Assembler engine - uncomment if needed
          # unicorn # CPU emulator - uncomment if needed
        ]);

      in
      {
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            # Reverse Engineering
            ghidra-bin
            radare2
            rizin
            cutter
            # iaito # GUI for rizin, uncomment if available in your nixpkgs
            
            # Disassemblers & Decompilers
            binutils
            gdb
            lldb
            
            # GDB Enhancements
            # gef # GEF needs to be installed via pip or manually
            # pwndbg # You can add this if available in your nixpkgs version
            
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
            # metasploit # Large package, install separately if needed
            
            # ROPgadget tools (ropper is in Python packages)
            
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
            # bless # GTK hex editor - may not be in nixpkgs
            
            # Forensics
            # volatility3 # Memory forensics - install if needed
            sleuthkit
            # autopsy # GUI for sleuthkit - may not be in nixpkgs
            
            # Web Tools (for web challenges)
            curl
            wget
            sqlmap
            
            # Utilities
            tmux
            git
            vim
            ripgrep
            fd
            bat
            jq
            
            # 32-bit support (important for CTFs)
            pkgsi686Linux.glibc
            
            # Misc
            qemu
            # docker # Needs special NixOS configuration, enable in system config
            
          ];

          shellHook = ''
            echo " CTF Environment Loaded "
            echo ""
            echo "Available Tools:"
            echo "  Reverse Engineering: ghidra-bin, radare2, cutter, rizin"
            echo "  Debugging: gdb, lldb"
            echo "  Binary Analysis: binwalk, file, hexdump, ltrace, strace"
            echo "  Exploitation: pwntools (Python), ropper"
            echo "  Networking: netcat, nmap, socat, wireshark"
            echo "  Crypto: openssl, john, hashcat"
            echo "  Assembly: nasm, gcc, clang"
            echo ""
            echo "Python packages: pwntools, ropper, capstone, pycryptodome"
            echo ""
            echo "💡 To install GEF for GDB (recommended):"
            echo "   bash -c \"\$(curl -fsSL https://gef.blah.cat/sh)\""
            echo ""
            
            # Set up some useful aliases
            alias gdb='gdb -q'
            alias r2='radare2'
            alias pwn='python3 -c "from pwn import *"'
            
            # Ensure 32-bit libraries are available
            export LD_LIBRARY_PATH="${pkgs.pkgsi686Linux.glibc}/lib:$LD_LIBRARY_PATH"
          '';
        };
      }
    );
}
