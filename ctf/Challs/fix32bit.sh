#!/usr/bin/env bash
# fix32bit.sh - Fix 32-bit ELF binaries to work in the nix environment

set -e

if [ $# -eq 0 ]; then
    echo "Usage: fix32bit.sh <binary>"
    echo "This script patches 32-bit binaries to use the correct interpreter and libraries"
    exit 1
fi

BINARY="$1"

# Check if file exists
if [ ! -f "$BINARY" ]; then
    echo "Error: File '$BINARY' not found"
    exit 1
fi

# Check if it's a 32-bit ELF
if ! file "$BINARY" | grep -q "ELF 32-bit"; then
    echo "Error: '$BINARY' is not a 32-bit ELF binary"
    file "$BINARY"
    exit 1
fi

echo "Fixing 32-bit binary: $BINARY"

# Find the 32-bit glibc in nix store
GLIBC_32=$(nix eval --raw nixpkgs#pkgsi686Linux.glibc)

if [ -z "$GLIBC_32" ]; then
    echo "Error: Could not find 32-bit glibc"
    exit 1
fi

INTERPRETER="$GLIBC_32/lib/ld-linux.so.2"

echo "Using interpreter: $INTERPRETER"

# Check if interpreter exists
if [ ! -f "$INTERPRETER" ]; then
    echo "Error: Interpreter not found at $INTERPRETER"
    exit 1
fi

# Create a backup
cp "$BINARY" "$BINARY.backup"
echo "Created backup: $BINARY.backup"

# Patch the binary
patchelf --set-interpreter "$INTERPRETER" "$BINARY"
patchelf --set-rpath "$GLIBC_32/lib" "$BINARY"

echo "✓ Binary patched successfully!"
echo ""
echo "You can now run:"
echo "  ./$BINARY"
echo "  gdb ./$BINARY"
echo ""
echo "To restore the original:"
echo "  mv $BINARY.backup $BINARY"
