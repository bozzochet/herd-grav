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

## Example 9: FIT

Repeat Ex00 and Ex01 using FIT detector.

Included files:
* **geometry.mac**  
  Geometry configuration datacard.
* **electrons_10GeV_sphere.mac**  
  Job configuration datacard for generating the Monte Carlo data file to be digitized.
* **digitizeMC.eaconf**  
  Configuration file for the digitization job
  
### Description
This example shows how produce and process simulation files using the FIT tracker. By default the FIT is monolithical in
order to reduce the number of volumes in the MC simulation; the energy released in each mat by every single particle is recorded
in the MC output file, and then the energy deposit in each SiPM channel is computed offline by a digitizer algorithm. This example repeats Ex00 and 
Ex01 using the FIT tracker instead of the STK. In the following, only the differences with respect to Ex00 and Ex01 are described;
please refer also to those examples for information about how to launch the MC and analysis jobs.    

#### The geometry configuration datacard
The datacard sets the FIT as the active tracker detector for both top and sides. 
The standard FIT geometry does not contain tungsten layers.
To insert tungsten layers inside FIT add the following commands inside geometry.mac:
* /herd/geometry/parametric/fit/nTopWLayers 3 # adding 3 W layers inside the top FIT
* /herd/geometry/parametric/fit/nSideWLayers 7 # adding 7 W layers inside each side FIT

#### The MC job configuration datacard
* Definition of the sensitive volumes  
  The card activates particle hits for top and side FIT.
* Setup of the output information on Root file  
* Simulation of 10 events (modify the parameter of the `/run/beamOn` command to
  change the number of simulated events).

#### The digitization job configuration file
The `FitDigitizerAlgo` is used in the algorithm sequence instead of the STK one.
