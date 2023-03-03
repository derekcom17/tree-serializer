
import numpy as np
import matplotlib.pyplot as plt

origSer = \
[[380,	411,	669,	1810,	3678,	2333],  # Total cells
[2800,	2824,	4696,	11924,	22075,	15918], # Total area
[0.2382,0.232,	0.5197,	3.825,	21.12,	22.85], # Original power
[7.902,	5.849,	3.961,	2.902,	8.156,	2.761], # Data period
[0.241,	0.238,	0.525,	2.636,	2.590,	4.138], # Freq-adjusted power
[1.9056,1.392,	2.0788,	7.65,	21.12,	11.425]]# Energy/bit

treeSer = \
[[1335,	1335,	1335,	1335,	1335,	1347],  # Total cells
[18205,	18205,	18205,	18205,	18250,	18321], # Total area
[0.7631,1.013,	1.513,	3.011,	6.235,	16.14], # Original power
[0.9135,0.9135,	0.964,	1.0045,	0.949,	1.012], # Data period
[6.683,	6.654,	6.278,	5.995,	6.570,	7.974], # Freq-adjusted power
[6.1048,6.078,	6.052,	6.022,	6.235,	8.07]]  # Energy/bit

fig, ax = plt.subplots(2, 2)
fig.subplots_adjust(wspace=0.5, hspace=0.5)

# Plot number of cells
ax[0, 0].scatter(x=origSer[3], y=origSer[0], label='OpenSerdes')
ax[0, 0].scatter(x=treeSer[3], y=treeSer[0], label='Tree Serializer')
ax[0, 0].set(title='SCs vs Data Period', xlabel='data period (ns)', ylabel='number of cells')
ax[0, 0].set(xbound=[0, 10], ybound=[0, 5000])
ax[0, 0].grid()
ax[0, 0].legend(loc='upper left')

# Cell area
ax[0, 1].scatter(x=origSer[3], y=origSer[1])
ax[0, 1].scatter(x=treeSer[3], y=treeSer[1])
ax[0, 1].set(title='Area vs Data Period', xlabel='data period (ns)', ylabel='cell area (um^2)')
ax[0, 1].set(xbound=[0, 10], ybound=[0, 25000])
ax[0, 1].grid()


# Plot power
ax[1, 0].scatter(x=origSer[3], y=origSer[4])
ax[1, 0].scatter(x=treeSer[3], y=treeSer[4])
ax[1, 0].set(title='Power vs Data Period', xlabel='data period (ns)', ylabel='power (mW)')
ax[1, 0].set(xbound=[0, 10], ybound=[0, 10])
ax[1, 0].grid()

# Plot energy per-bit
ax[1, 1].scatter(x=origSer[3], y=origSer[5])
ax[1, 1].scatter(x=treeSer[3], y=treeSer[5])
ax[1, 1].set(title='Energy/bit vs Data Period', xlabel='data period (ns)', ylabel='Energy per bit (pJ/bit)')
ax[1, 1].set(xbound=[0, 10], ybound=[0, 25])
ax[1, 1].grid()

plt.suptitle('''Cadence flow Serializer PPA
constrainted data rate to: (8ns, 6ns, 4ns, 2ns, 1ns, 0.5ns)''')
plt.show()

