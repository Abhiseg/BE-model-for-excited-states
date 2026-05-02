import numpy as np
import matplotlib.pyplot as plt

# -------------------------------
# Read theoretical energies
# column 1 = energy (eV)
# column 2 = intensity (taken from digitized data)
# -------------------------------
data = np.loadtxt("Theoretical_data.dat")

E_eV = data[:,0]
osc = data[:,1]

# -------------------------------
# Convert eV -> wavelength (nm)
# -------------------------------
wavelength_nm = 1240.0 / E_eV

# Sort by wavelength
sort_idx = np.argsort(wavelength_nm)
wavelength_nm = wavelength_nm[sort_idx]
osc = osc[sort_idx]

# -------------------------------
# Gaussian broadening function
# -------------------------------
def gaussian(x, x0, sigma):
    return np.exp(-(x-x0)**2/(2*sigma**2))

# -------------------------------
# Wavelength grid (match experiment)
# -------------------------------
x = np.linspace(300,700,4000)

sigma = 10.0   # nm broadening

# -------------------------------
# Build theoretical spectrum
# -------------------------------
y = np.zeros_like(x)

for lam, f in zip(wavelength_nm, osc):
    y += f * gaussian(x, lam, sigma)

# -------------------------------
# Load digitized experimental data
# -------------------------------
exp_data = np.loadtxt("Experiment_data.dat")

exp_wavelength = exp_data[:,0]
exp_intensity = exp_data[:,1]

# -------------------------------
# Scale theoretical spectrum
# to experimental intensity scale
# -------------------------------
y *= np.max(exp_intensity) / np.max(y)

# ---------- ADD EXPERIMENTAL STICKS HERE ----------
E_Q  = 1.93
E_S  = 3.06
E_SS = 3.40

exp_nm = {
    "Q-Band": 1240.0 / E_Q,
    "S-Band": 1240.0 / E_S,
    "SS-Band": 1240.0 / E_SS
}

colors = {
    "Q-Band": "blue",
    "S-Band": "purple",
    "SS-Band": "orange"
}

#for label, lam in exp_nm.items():
#    plt.vlines(lam, 0, 0.15, colors=colors[label], linewidth=3)
#    plt.text(lam, 0.32, label, rotation=90,
#             ha='center', va='bottom', fontsize=14, color=colors[label])
# -------------------------------------------------

# -------------------------------
# Plot spectra
# -------------------------------
#plt.figure(figsize=(7,5))

plt.plot(x, y,
         lw=3,
         color='red',
         label="BE Model (SCAN)")

plt.plot(exp_wavelength,
         exp_intensity,
         lw=3,
         color='black',
         label="Experiment")

plt.xlabel("Wavelength (nm)", fontsize=20)
plt.ylabel("Normalised absorption", fontsize=20)

plt.xticks(fontsize=15)
plt.yticks(fontsize=15)

plt.xlim(300,700)

plt.legend(fontsize=16)

plt.tight_layout()

plt.savefig("comparison_spectrum_final.png", dpi=800)

plt.show()
