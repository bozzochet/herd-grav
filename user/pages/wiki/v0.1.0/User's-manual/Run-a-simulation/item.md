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

As explained in the [introduction](Introduction.md), HerdSoftware relies on GGS to run Geant4 Monte Carlo simulations. In HerdSoftware the detector geometry and the particle generator are implemented as plugin libraries to be loaded at runtime by the `GGSPenny` simulation program. The Herd geometry is obviously mandatory, while for generating particles it is possible also to use one of the GGS generators.

# Configure the simulation
The configuration of a GGS simulation run is done with datacard files, where configuration commands in the usual Geant4 syntax are placed. There are 2 different files that can be passed to `GGSPenny`:
* a geometry datacard file  
  This file is passed to `GGSPenny` with the `-gd` option. It is meant to contain the eventual commands defined by the geometry that will be used for the simulation. For example, see the [commands for setting the parameters of the parametric geometry](Detector-geometry:-parametric.md#parameters)

* a job configuration file  
  This file contains the commands for choosing and configuring the particle generator, the simulation output etc. It has to be passed to `GGSPenny` with the `-d` command line option.

The content of the job configuration file might vary, depending on what the user wants to configure. There are however some commands that must always be given:
* the choice of the particle generator
* the definition of active volumes (i.e. volumes for which hits will be produced)
* the creation of user actions (e.g. to actually save the hits on the output file)

A commented example of a datacard file is given in [Ex00](Examples/Ex00:-produce-MC.md).

# Run the simulation
The simulation can be launched by calling the `GGSPenny` executable with the appropriate parameters. For example:

```bash
$ GGSPenny -g /path/to/geometryPluginLibrary -d /path/to/jobDatacard.mac -gd /path/to/geometryDatacard.mac -ro outputFile.root
```
It is not mandatory to specify a geometry datacard if it's not needed (e.g. in case the geometry does not define any command since it has no tunable parameter). If additional components have to be used (e.g. the isosphere generator) their plugin libraries have to be specified with the `-ap` additional flag. See the output of `GGSPenny -h` for more details about the available options.  
**NOTE**: when launching batch jobs it is mandatory to set different values for the initial seeds of the random number generator for each job, to avoid simulating exactly the same events in every job. Please be sure to pass the `--seed1` and `--seed2` options to `GGSPenny` with different values for every job.
