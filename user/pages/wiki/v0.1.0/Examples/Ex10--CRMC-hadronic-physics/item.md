---
title: 'HERD Wiki - Version 0.1.0'
body_classes: 'header-dark header-transparent'
hero_classes: 'text-light title-h1h1 overlay-dark-gradient hero-tiny'
hero_image: mountain_short.jpg
header_image_height: 10
item_type: 'wiki'
show_sidebar: true
sidebar_root: wiki/v0.1.0
hero_noarrow: true
process:
    markdown: true
    twig: false
twig_first: false
---

#  HerdSoftware examples

## Example 10: simulation using CRMC hadronic physics engine

Configure and run a Monte Carlo simulation using the CRMC hadronic physics models.

Included files:
* **geometry.mac**  
  Geometry configuration datacard.
* **physics.mac**  
  Physics configuration datacard.
* **protons_500GeV_sphere.mac**  
  Job configuration datacard for generating the Monte Carlo data file.

### DISCLAIMER
The usage of CRMC hadronic physics has to be considered as experimental. There might be crashes, and validation of the physics results
is yet to be done.

Currently there is no support for OSX due to unresolved, OSX-specific bugs in CRMC code.de.
  
### Description
This example shows how to run a Monte Carlo simulation using the CRMC high-energy hadronic models. Standard Geant4 models are capped
at 100 TeV/n, and are usually considered not-so-accurate especially for Z>1. For this reason high-energy hadrons can be simulated
using one of the high-energy hadronic engines (e.g. DPMJET-3, QGSJET, Sybill, ...) provided by the CRMC package. 

### The CRMC physics list for GGS
GGS provides a Geant4 physics list based on CRMC. It currently uses one of the CRMC engines for hadronic physics above a given
energy threshold, and the standard FTFP_BERT list below that threshold (and also for all the non-hadronic processes at all energies).
This list is not standard so it is placed in a plugin library for GGS that has to be loaded when launching `GGSPenny`. 

#### The physics configuration datacard
The CRMC physics list can be tuned by selecting the hadronic model and the energy threshold. This can be done by means of the
physics configuration datacard, where the appropriate settings can be placed as Geant4 commands. This datacard must be passed
to `GGSPenny`, and consists of two commands:

```
   /GGS/physicsList/crmc/modelName name
   /GGS/physicsList/crmc/modelThreshold value unit
```

The first command specifies which model to use. The possbile values currently are:

* EPOS-LHC
* QGSJETII-04 (currently not working)
* SIBYLL-2.3 (currently not working)
* DPMJET-3.06
* EPOS-1.99
* QGSJET-01 (currently not working)
* QGSJETII-03 (currently not working)

If this command is missing then DPMJET-3.06 will be used. The second command specifies the threshold energy above which the CRMC
hadronic model will be used. If this command is missing the value 300 GeV will be used.

In this example the EPOS-LHC model and the 400 GeV value for the threshold are used.

### The job configuration datacard
Even if the CRMC models are aimed at simulating the highest energies, in this example protons at 1 TeV are used in order to reduce
the processing time. Higher initial energies can be set by modifying the job configuration datacard.

#### Launch the simulation 
The simulation job can be run by adding to `GGSPenny` the `-pl` option for loading the CRMC physics plugin library and the `-pd` option for
loading the physics configuration datacard. The complete command is:

```bash
$ GGSPenny -g </path/to/HerdCompiledSoftwareFolder>/plugin/libHerdMCParametricGeo.so -pl $GGS_SYS/lib/libGGSPhysicsLists.so -d protons_500GeV_sphere.mac -gd geometry.mac -pd physics.mac -ro protons_10TeV_sphere.root
```

Note that the initialization of some CRMC hadronic engine might take up to some minutes, giving the false impression that the simulation job
is stuck. In particular, DPMJET-3.06 is extremely slow in this phase, while EPOS-LHC is quite fast. 
