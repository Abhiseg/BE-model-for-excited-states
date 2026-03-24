#!/bin/bash
set -e

echo "Compiling main program only..."
gfortran -std=legacy -O3 -c main_exciton.f90

echo "Linking with existing objective files..."
gfortran -O3 -o my_exe.exe *.o \
   -L/usr/lib/x86_64-linux-gnu -lfftw3 -llapack -lm

echo "Build finished: ./my_exe.exe"
