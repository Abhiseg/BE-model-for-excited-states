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
Before compiling the code, FFTW3 package should be installed in advance. 
The data of triplet excited states should be obtained from an external electronic structure package. 
Before run the code (runme.exe), users must prepare the following input files:

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
Users should follow the formatting illustrated in the example directories:
- acetone_npistar_b3lyp
- C2H2_C1s_npistar_blyp

### 4. Molecular Geometry (sample.inp)
The molecular structure must be supplied:
- In Bohr units
- Using the format demonstrated in the example input files

### Contact: abhisek.ghosal@northwestern.edu for any enquiry.
For more details, see our publication: ... coming soo
