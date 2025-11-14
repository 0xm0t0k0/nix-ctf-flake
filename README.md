# 0xm0t0k0's Flake Environment:3

My Nix flake environment for CTFs, RevEngineering & Binary Exploitation 0.< 

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
- **ghidra-bin**
- **radare2 / rizin**
- **cutter / iaito**

### Binary Exploitation
- **pwntools**
- **ROPgadget / ropper** 

### Debugging
- **gdb with gef**
- **lldb** 
- **ltrace / strace** 

### Binary Analysis
- **binwalk** 
- **file / strings** 
- **hexdump / xxd** 
- **patchelf** 

### Cryptography
- **openssl** 
- **john / hashcat** 

### Networking
- **netcat / socat** 
- **nmap**

### Programming/Assembly
- **gcc / clang** 
- **nasm** 
- **Python 3** with CTF packages (pwntools, pycryptodome, etc.)

## Usage

### Basic Pwntools Script
```python
from pwn import *

# Set context
context.arch = 'amd64'
context.os = 'linux'

# Connect to a challenge
# io = remote('saturn.picoctf', 1337)
io = process('./vuln')

# Your exploit 
payload = b'A' * 64 + p64(0xm0t0k0)
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

### Common Workflow
1. `file binary` - Check binary type and architecture
2. `checksec binary` - Check security features (in gdb with gef)
3. `strings binary` - Look for interesting strings
4. Disassemble with ghidra or radare2
6. Debug with gdb + gef


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

### Updated to support 32-bit libraries (should work, if not contact me on discord)

(This is already set in the shell hook)

### Python package issues
If a Python package is missing, add it to the `pythonEnv` section in `flake.nix`.

## Resources

- [CTF Field Guide](https://trailofbits.github.io/ctf/)
- [Pwntools Documentation](https://docs.pwntools.com/)
- [GEF Documentation](https://hugsy.github.io/gef/)
- [Radare2 Book](https://book.rada.re/)
- [Ghidra Documentation](https://ghidra-sre.org/)

## Contributing to this Setup :3

Feel free to fork this and customize it for your own CTF needs!

---
