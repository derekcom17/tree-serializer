# EE 541 Tree Serializer Project
For this project, we designed and tested a Tree-Serializer which could be used as a replacement for 
the OpenSerDes serializer. Please read our 
[project report](https://docs.google.com/document/d/1erOO4S1geyRubeenMeuFR7pid_qqNJQ-uvTnONMM5Ss/edit?usp=sharing)
for more details. Instructions are included for implementing this design in the OpenLane
tool flow, or the Hammer tool flow used in the ECE computing lab. 

The original serializer design from the 
[OpenSerDes project](https://github.com/SparcLab/OpenSERDES)
can be found here in the `openserdes-serializer` directory for simple comparison. 

## OpenLane Implementation Instructions
After setting up OpenLane, clone this repo into the `OpenLane/designs` directory. Run this command to build your design:
```
make quick_run QUICK_RUN_DESIGN=tree-serializer
```
To build the OpenSerDes serializer, run:
```
make quick_run QUICK_RUN_DESIGN=tree-serializer/openserdes-serializer
```

## "Hammer" Cadence flow Implementation instructions

### Hammer Setup
Assuming you are in the UW ECE computing lab, install our Cadence flow with:
```
git clone https://github.com/bsg-external/ee477-hammer-cad.git
cd ee477-hammer-cad
make
```
Then, in the same directory as `ee477-hammer-cad`, clone this repo. If you clone this repo
elsewhere, you will need to edit `Makefile` and `openserdes-serializer/Makefile` to point to
the correct CAD directory location. 

The Make targets for that flow are listed int the CAD Readme, but the most important are 
`make sim` to run RTL simulation, `make view-sim-rtl` to view the waveform, and `make par` to 
implement your design.
