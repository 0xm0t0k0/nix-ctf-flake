# CTF Development Environment

A comprehensive Nix flake-based environment for CTF challenges, reverse engineering, and binary exploitation.

## Quick Start

```bash
# Enter the development environment
nix develop

# Or use direnv (recommended)
echo "use flake" > .envrc
direnv allow
```

## Included Tools

### Reverse Engineering
- **ghidra** - NSA's software reverse engineering suite
- **radare2 / rizin** - Advanced command-line reverse engineering framework
- **cutter / iaito** - GUI for radare2/rizin
- **IDA alternatives** - Full suite of open-source RE tools

### Binary Exploitation
- **pwntools** - CTF framework and exploit development library
- **ROPgadget / ropper** - Find ROP gadgets in binaries
- **angr** - Binary analysis framework
- **metasploit** - Penetration testing framework

### Debugging
- **gdb with gef** - Enhanced GDB with better UI and features
- **lldb** - LLVM debugger
- **ltrace / strace** - Library and system call tracers

### Binary Analysis
- **binwalk** - Firmware analysis and extraction
- **file / strings** - File type identification and string extraction
- **hexdump / xxd** - Hex viewers
- **patchelf** - Modify ELF binaries

### Cryptography
- **openssl** - Crypto library and tools
- **john / hashcat** - Password cracking
- **z3** - Theorem prover (useful for crypto challenges)

### Networking
- **netcat / socat** - Network Swiss Army knives
- **nmap** - Network scanner
- **wireshark / tcpdump** - Packet analysis

### Programming/Assembly
- **gcc / clang** - C compilers
- **nasm** - Assembler
- **Python 3** with CTF packages (pwntools, pycrypto, etc.)

## Usage Examples

### Basic Pwntools Script
```python
from pwn import *

# Set context for your target
context.arch = 'amd64'
context.os = 'linux'

# Connect to a challenge
# io = remote('challenge.ctf', 1337)
io = process('./vuln_binary')

# Your exploit here
payload = b'A' * 64 + p64(0xdeadbeef)
io.sendline(payload)

io.interactive()
```

### GDB with GEF
```bash
# Start gdb (gef is automatically loaded)
gdb ./binary

# Useful gef commands:
# checksec - Check binary protections
# pattern create 200 - Create a cyclic pattern
# pattern offset 0x41414141 - Find offset in pattern
# rop - Find ROP gadgets
# vmmap - View memory mappings
```

### Radare2 Quick Reference
```bash
# Open binary
r2 ./binary

# Auto-analyze
aaa

# List functions
afl

# Disassemble main
pdf @main

# Visual mode
VV
```

### Ghidra
```bash
# Launch Ghidra
ghidra
```

## 32-bit Binary Support

This environment includes 32-bit library support. When debugging 32-bit binaries:

```bash
# Check if binary is 32-bit
file ./binary

# GDB will automatically handle 32-bit binaries
gdb ./binary_32bit
```

## Tips & Tricks

### Setting up a CTF Challenge Structure
```bash
mkdir challenge_name
cd challenge_name
# Put binary here
# Create exploit.py
# Take notes in notes.md
```

### Common Workflow
1. `file binary` - Check binary type and architecture
2. `checksec binary` - Check security features (in gdb with gef)
3. `strings binary` - Look for interesting strings
4. Disassemble with ghidra or radare2
5. Develop exploit with pwntools
6. Debug with gdb + gef

### Useful Aliases (already set up)
- `gdb` - Starts gdb in quiet mode
- `r2` - Alias for radare2
- `pwn` - Quick pwntools import

## Customization

To add more tools, edit `flake.nix` and add packages to the `buildInputs` list:

```nix
buildInputs = with pkgs; [
  # Add your tools here
  your-favorite-tool
];
```

Then reload with `nix develop` or `direnv reload`.

## Troubleshooting

### Missing 32-bit libraries
If you encounter issues with 32-bit binaries, ensure you have:
```bash
export LD_LIBRARY_PATH="/nix/store/.../lib:$LD_LIBRARY_PATH"
```
(This is already set in the shell hook)

### Python package issues
If a Python package is missing, add it to the `pythonEnv` section in `flake.nix`.

## Resources

- [CTF Field Guide](https://trailofbits.github.io/ctf/)
- [Pwntools Documentation](https://docs.pwntools.com/)
- [GEF Documentation](https://hugsy.github.io/gef/)
- [Radare2 Book](https://book.rada.re/)
- [Ghidra Documentation](https://ghidra-sre.org/)

## Contributing to Your Setup

Feel free to fork this and customize it for your own CTF needs!

---

Happy Hacking! 🚩
