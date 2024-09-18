from TOSSIM import *
import sys

# Create a TOSSIM object
t = Tossim([])

# Add a channel to capture debug output
t.addChannel("FloodC", sys.stdout)
t.addChannel("NeighborDiscovery", sys.stdout)

# Set up noise model (necessary for simulations)
noise = open("meyer-heavy.txt", "r")
for line in noise:
    str = line.strip()
    if str != "":
        for i in range(10):
            t.getNode(i).addNoiseTraceReading(int(str))

for i in range(10):
    t.getNode(i).createNoiseModel()

# Boot nodes
for i in range(10):
    t.getNode(i).bootAtTime(1000 * i)

# Run simulation
for i in range(10000):
    t.runNextEvent()
