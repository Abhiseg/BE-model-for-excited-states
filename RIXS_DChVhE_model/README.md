## Methanol example

O K-edge: **core excitation 1s → 3sa′**, **RIXS emission** to **1a′**.

## Directories (you prepare all inputs)

**`core/`** — core-hole state: `mo_cf.dat`, `en.dat`, `mo_en.dat`

**`valence/`** — valence-hole state: `mo_cf.dat`, `en.dat`, `mo_en.dat`

**`osc/`** —  emission osc. strength:

 `mo_cf.dat` | Initial and final MOs for emission (e.g. 1s and 1a′ columns) |
 `en.dat` | Triple energies of core-hole and valence-hole calculation |
 `mo_en.dat` | Simple copy of en.dat |

Also in the run directory: `sample.inp`, `basis_ae.inp`, `std_grid.dat` needed in BE-Model.

## Build and run

```bash
cd build && ./build.sh
cd .. && ./runme.exe
```

## Important Outputs

- `RIXS.out` — core/valence excitation (eV), **rixs_emission_energy_eV** = core − valence, **emission_osc_strength_au**
