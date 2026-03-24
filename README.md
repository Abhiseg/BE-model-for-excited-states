# BE-model-for-excited-states
This repository contains a Fortran90 implementation of the Becke Exciton (BE) model based on the quantum ``virial" theorem.
The code enables the calculation of excitation energies for arbitrary open-shell singlet excited states derived from a closed-shell singlet reference, provided that the corresponding triplet excited states are available. 
Thanks to generalised BE model to incorporate the non-local singlet correlation energy to an arbitrary open-shell singlet excited states using orbital information from corresponding triplet states. 
The underlying formulation incorporates the $K_{if}$ integral--where i and f denote the initial and final orbitals involved in the triplet excitation—plays a central role. 

The $K_{if}$ integrals are evaluated using Fourier convolution theorem as implemented on a real-space grid with a robust optimization strategy, ensuring numerical stability and efficiency. 
In addition, the code includes functionality to compute oscillator strengths within the frozen-core approximation, also implemented on the same real-space grid.

## Available Features : 
- Optical gap of orgaic chromophore.
- The charge-transfer excitaion in TADF systems.
- Low-lying excited states, both valence and Rydberg excitations.
- Core-level K-edge and L-edge excitations of second and third group of elements.
- Topology near connical intersections in between $S_0$ and $S_1$ states. 

## Prerequisites and Required Inputs
Before compiling the code, gfortran (or ifort) and the FFTW3 package must be installed. 
The triplet excited-state data should be generated using an external electronic structure package via unrestricted HF/KS calculations. 

Preparing triplet excited states beyond simple HOMO–LUMO transitions can be challenging due to variational collapse. 
Therefore, particular care is required during state-specific triplet optimizations.

Before running the code (e.g., ./runme.exe from the terminal), users must prepare the following input files:

### 1. Molecular Orbital Energies (mo_en.dat)
This file must contain:
- Ground-state energy and target triplet-state energy
  
### 2. Molecular Orbital Coefficients (mo_cf.dat)
This file should include the molecular orbitals involved in the excitation:
- Initial orbital (phi_i)
- Final orbital (phi_f)
These orbitals must be obtained from the triplet-state electronic structure calculation.

### 3. Basis Set File (basis_ae.inp)
The atomic basis functions must be provided in a specific format required by the code.
Users should follow the formatting llustrated in the example directories:
- acetone_npistar_b3lyp
- C2H2_C1s_npistar_blyp
  
### 4. More about basis set setup 
- The basis functions must be expressed in Cartesian form rather than spherical harmonics. 
- The current implementation supports basis sets up to f-type orbitals.
- The basis set file should follow an ascending order of angular momentum (s, p, d, f).
- It is important to maintain this ordering consistently, including in the external electronic structure package used to generate the input data. 

### 5. Molecular Geometry (sample.inp)
The molecular structure must be supplied:
- In Bohr units.
- Using the format demonstrated in the example input files.
- This geometry should match with the geometry used in external electronic software package.

### 6. More about sample.inp setup 
- carteXXXXX aunits up to end should contain the geometry of the systems.
- unre X (X should be half of the total number of electrons in the system for a closed-shell refrence!)
- Accordingly, next X lines should fill with 2, for unrestricted KS/HF calculations.
- These keywords and their values should be checked carefuly in sample inp file to avoid any backtrace error.

### 7. Real-space grid (std_grid.dat and grid_spacing.dat)
The simulation grid contains 
- The number of grid points in x, y, and z-directions contained in std_grid.dat file.
- The smallest spacing by $\delta_x=\delta_y=\delta_z=0.3$ contained in grid_spacing.dat file.

### 8. Run the code
 To run the code, a set of object files is provided that compute the $K_{if}$ integrals in real space and are used by the main_exciton.f90 routine to evaluate excitation energies. 
 This routine is intended for general use; additional modules may be made available upon reasonable request.

 The code does not use a version-controlled build system; instead, a simple system-specific build script (build.sh) is provided. 
 Users should modify this script according to their system configuration. 
 Relevant build information is specified in the system_specification.dat file. 
 The final output is written to the STS.out file.

### 9. Examples 
     Two examples are added here for the general purpose. 
- C$_2$H$_2$ core excitation from C1s to n$\pi^{\star}$.
- Acetone n$\pi^{star}$ excitation. 

### 10. Contact 
For any enquiry mailed at abhisek.ghosal@northwestern.edu.
For more details, see our publication: ... coming soon
