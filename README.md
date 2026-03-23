# BE-model-for-excited-states
This repository contains a Fortran90 implementation of the Becke Exciton (BE) model based on the quantum virial theorem.
The code is designed for efficient excited-state simulations and enables the calculation of:
- Arbitrary open-shell singlet excited states: Optical Gap, Charge Tranfer state and Rydberg State
- Core excitation

## Prerequisites and Required Inputs
The BE-model code requires data obtained from an external electronic structure calculation.
Users must prepare the following input files:

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
