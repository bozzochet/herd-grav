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

Currently, HERD data are available only as Monte Carlo simulations, so the
first step after setting up the environment is to understand how to run the
simulation.

The HERD simulation in HerdSoftware is currently implemented using the external
GGS package, which makes use of Geant4. If you are familiar with building a
Geant4 application then you'll know that there are several components that have
to be implemented: geometry, hits, particle generator, user actions, output to
file etc., and this takes time. GGS provides an implementation of almost all
the needed user classes, together with automatic output on Root file, that can
be used with any kind of detector; the user is left with implementing just the
detector geometry, which is then plugged into the GGS simulation program called
`GGSPenny`. In HerdSoftware, the HERD geometry is implemented as a Geant4
detector construction class (or more precisely, a GGS geometry construction
class which inherits from the Geant4 detector construction class) written in
C++. The geometry consists of the various HERD sub-detectors (calorimeter,
tracker etc.) and has various tunable parameters that can be set at the moment
of launching the simulation job; for this reason it is currently known as the
`parametric geometry`. A detailed description of the parametric geometry is
given in the [detector geometry](User's-manual/Detector-geometry:-parametric.md)
page of the user's manual. You don't need to understand every detail of the
geometry to run a simulation, but in case you have doubts about the actual
detector geometry or if you want to change some parameters (to e.g. remove one
sub-detector from the simulation) then please refer to that page.  

Simulations are launched using the `GGSPenny` executable provided by GGS; the
configuration of each job (output file, which detector geometry to use, which
information to save in the output file etc.) is given to GGSPenny by means of:
- command line parameters (e.g. to specify the output file)  
- geometry library file (i.e. the library with the compiled C++ code of the
  detector geometry definition implemented inside HerdSoftware)  
- configuration files (text files containing Geant4 commands used to define
  e.g. particle type and energy, details of the geometry etc.)
    
The complete procedure is described in [this wiki page](User's-manual/Run-a-simulation.md).


The [example 00](Examples/Ex00:-produce-MC.md) example shows how to launch a
fully-configured simulation job. Look at the content of the two datacards (i.e.
the files with extension .mac) located in
`HerdSoftware/examples/Ex00_produce-mc` to learn how to configure the
parametric geometry and how to configure the simulation run. Then launch the
simulation job as explained at the end of the description of the example.
This will produce a Root output file containing the simulation output in the
GGS format. 
Should you want to change some geometry parameter then refer to the 
[detector geometry](User's-manual/Detector-geometry:-parametric.md) page. 

The example contains basically all the information you need to configure and
run the simulation of HERD, but if you want to understand more about GGS
(which is a standalone package and can be used also for simulating detectors
other than HERD) then refer to:

*  [GGS project site](https://baltig.infn.it/mori/GGSSoftware/)
*  [GGS documentation](https://wizard.fi.infn.it/ggs/)
