#!/bin/bash
set -e

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
SRC="$ROOT/src"
MOD="$ROOT/mod"

cd "$SRC"

echo "Compiling main program only..."
rm -f main_rixs.o
gfortran -std=legacy -O3 -I"$MOD" -J"$MOD" -c main_rixs.f90

echo "Linking with objective files in src/..."
gfortran -O3 -o "$ROOT/runme.exe" *.o \
   -L/usr/lib/x86_64-linux-gnu -lfftw3 -llapack -lm

# Remove stale copy if present (do not run this; use $ROOT/runme.exe)
rm -f "$ROOT/build/runme.exe"

echo "Build finished: $ROOT/runme.exe"
echo "Run: cd $ROOT && ./runme.exe"
echo "(Do not copy runme.exe from build/ — the executable is written in the model root.)"
