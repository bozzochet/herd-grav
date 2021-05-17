---
title: 'HERD Wiki - Version master'
body_classes: 'header-dark header-transparent'
hero_classes: 'text-light title-h1h1 overlay-dark-gradient hero-tiny'
hero_image: mountain_short.jpg
header_image_height: 10
item_type: 'wiki'
show_sidebar: true
sidebar_root: wiki/vmaster
hero_noarrow: true
process:
    markdown: true
    twig: false
twig_first: false
---

#  HerdSoftware examples

## Example 11: TRD simulation

Configure, run and analyze a Monte Carlo simulation of the TRD.

Included files:
* **geometry.mac**  
  Geometry configuration datacard.
* **physlist.mac**  
  Physics configuration datacard.
* **electrons_10GeV_plane.mac**  
  Job configuration datacard for generating the Monte Carlo data file.
* **analyzeTRD.cpp**
  Offline data analysis routine (can be used as a Root script or as a standalone executable.
* **main.cpp**
  Main file for running `analyzeTRD.cpp` as a standalone executable.
* **CMakeLists.txt**
  Configuration file for building `analyzeTRD.cpp` as a standalone executable

### Description
This example shows how to run a Monte Carlo simulation of the TRD, and how to analyze the output of the simulation. Currently,
analysis is done using the GGS file readout routines instead of using the EventAnalysis pipeline.

### Simulation elements
TR physics is not implemented in GGS, so a set of plugin libraries for GGS have been developed in HerdSoftware. They include:
* **Physics list**    
  The TR physics list adds the creation of TR photons in radiator materials to a standard physics list used as a base list for
  simulating all the other physical processes. The base list is `FTFP_BERT` by default, but it can be set in the physics list
  datacard (see `physlist.mac`).
* **Simulation hits**  
  The simulation hit (`TRIntHit` class) adds class members for storing TR hit information to the standard GGS integrated hit.
  It also adds a method for filling these additional members during the simulation.
* **Output hits**  
  The output hit (`TTRIntHit` class) is used to store the TR hit information in the Root output file.
* **User actions**
  The `TrdTravMatAction` user action computes and stores in the output file the total amount of material traversed by the
  primary particle while crossing the TRD.
  
### Simulation configuration
The TRD simulation can be configured by means of the GGS datacards:
* **Geometry configuration datacard** (`geometry.mac`)  
  The TRD is automatically disabled in the HERD parametric simulation geometry, so it must be added explicitly by setting the
  calibration detector to `trd` (line 6). Once the TRD is added it is possible to customize some of its geometry parameters
  (commented commands on line 9 and below).  
* **Job configuration datacard** (`electrons_10GeV_plane.mac`)  
  This is very similar to the corresponding files used by other examples (see e.g. [Ex00](Ex00:-produce-MC.md)). The
  most relevant differences are:
    * particles are shot from a plane orthogonal to the Y axis horizontally towards negative Y. This generates particles that
    hit the TRD orthogonally on random points
    * When activating hits for the TRD chamber, the `TRIntHit` class is set to be used for integrated hits (line 15)  
    * When activating the hits output, the `TTRIntHit` class is set to be used for the output of chamber simulation hits (line 19)  
    * The user action for traversed material is activated (line 22)
* **Physics configuration datacard** (`physlist.mac`)
  The configuration of the TR physics list consists of two items:
    * the choice of the base list. By default the base list is `FTFP_BERT`, but a different list can be set (in the file, commented
    lines from 2 to 4 show how to use the CRMC physics list described in [Ex10](Ex10:-CRMC-hadronic-physics.md) as the
    base list)  
    * the choice of the XTR production model. By default is is `transpM`, but a different model can be set (line 7)
    
### Launching a simulation
To lauch a siomulation with the full TR simulation output it is necessary to pass to `GGSPenny` the plugin libraries containing the TR simulation
elements and the datacards to configure them:

```
$ GGSPenny -g </path/to/HerdCompiledSoftwareFolder>/plugin/libHerdMCParametricGeo.so -d electrons_10GeV_plane.mac -gd geometry.mac -pl </path/to/HerdCompiledSoftwareFolder>/plugin/libHerdMCTRPhysicsList.so -pd physlist.mac -ap </path/to/HerdCompiledSoftwareFolder>/plugin/libHerdMCUserActions.so -ro electrons_10GeV_plane_withTR.root
```

In the above invocations of GGSPenny the `</path/to/HerdCompiledSoftwareFolder>` can be either the build folder or install folder 
of HerdSoftware. The inclusion of the user actions plugin library `libHerdMCUserActions.so` will automatically include also the plugin
libraries for simulation and output hits 

### Analyzing the simulation output
Currently, there's no support for analyzing the TR information contained in the simulation output file with the EventAnalysis pipeline.
The data can be analyzed using the GGS data readout classes, as shown in the `analyzeTRD.cpp` file. The `analyzeTRD` routine will
produce some plots related to the TR hits and compute the mean material traversed by a primary particle crossing the TRD.

The analysis can be launched interactively from the root shell:

```
$ root
root [0] .L /path/to/HerdSoftware/build/plugin/libHerdMCReaders.so
root [1] .L analyzeTRD.cpp
root [2] analyzeTRD("electrons_10GeV_plane_withTR.root")
[GGSTHitsReader::SetDetector]    INFO      Set detector chamber.[TRIntHit][][]
Mean amount of traversed TRD material: 0.858534 X0, 0.201096 lambda_I
```

(the explicit loading of `libHerdMCReaders.so` is not needed when using an installed version of HerdSoftware).

It is also possible to compile the analysis routine into a standalone executable:

```
$ mkdir build
$ cd build
$ cmake -DHerdSoftware_DIR=</path/to/HerdSoftwareCMakeFolder> ../
$ make
$ ./analyzeTRD ../electrons_10GeV_plane_withTR.root
```

where `</path/to/HerdSoftwareCMakeFolder>` is the path to the folder containing the `HerdSoftwareConfig.cmake` file (i.e. the HerdSoftware
build folder or the `cmake/` subfolder of the HerdSoftware install folder). The standalone executable won't display the TR plots but rather
save them in the `TRDplots.root` file. 
