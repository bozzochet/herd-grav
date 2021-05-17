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

## Example 13: use of trigger algorithms
**Folder:** Ex13_trigger
In this example, the high energy trigger algorithm is used to fill histograms for the events that pass the trigger condition.

Included files:
* **e-_1-100GeV_sphere.mac**
  Job configuration datacard to generate a Monte Carlo sample of electrons with energies from 1 to 100 GeV.
* **geometry.mac**
  Geometry configuration datacard from Ex00.
* **digitizeMC.eaconf**
  Simple configuration file for the digitization job.
* **CaloEDepEGenHisto.{h,cpp}**
  Source files for a custom analysis, implementing the algorithms to fill histograms with the total energy deposition in CALO and the particle generated energy.
* **analyzeMC.eaconf**
  Configuration file for the custom analysis.

### Description

#### Simulation
For this example, we need to produce a Monte Carlo sample with generated energies in a range, for instance, electrons between 1 and 100 GeV. We use the geometry datacard from Ex00 and a configuration datacard for the GGS gun generator to produce the sample of study.
To launch the simulation (see Ex00), use

```bash
$ GGSPenny -g </path/to/HerdCompiledSoftwareFolder>/plugin/libHerdMCParametricGeo.so -d e-_1-100GeV_sphere.mac -gd geometry.mac -ro e-_1-100GeV_sphere.root
```

where:
`</path/to/HerdCompiledSoftwareFolder>` is the path to the compiled Herd software (i.e. the 'build' directory or the 'install' one)

This will generate a file called `e-_1-100GeV_sphere.root` with 50 electron events with energies between 1 and 100 GeV shot from a spherical surface surrounding the detector. To obtain more statistics, increase the number of events to be simulated by setting the argument of the `/run/beamOn` command in the `e-_1-100GeV_sphere.mac` datacard before runnig `GGSPenny`.

#### Digitization
The next step is the digitization of the Monte Carlo output file using the configuration datacard (see Ex01):

```bash
$ EventAnalysis -c digitizeMC.eaconf
```

#### Use of the high energy trigger algorithm
After the digitized file is produced, a custom analysis making use of the trigger algorithms can be applied. For this analysis, use the corresponding configuration file with EventAnalysis:

```bash
$ EventAnalysis -c analyzeMC.eaconf
```
In this example, the custom analysis CaloEDepEGenHisto is built and run twice. The first time, it fills two histograms with the total energy deposition in CALO and the generated MC energy of all the simulated particles. The second time, it is called after the trigger algorithm, meaning that a dedicated set of histograms for the selected events passing the trigger condition will be filled. In this manner, it is possible to have a very first estimation of the trigger efficiency from the selected and total number of events at each generated energy (remember that for a meaningful calculation of the trigger efficiency a fiducial volume sample has to be defined, so that this is simple algorithm is just a naive approximation). In order to build the codeas an external file, a `CMakeLists.txt` file is provided so that the usual procedure can be followed (see Ex02 for more details):

```bash
$ mkdir build; cd build
$ cmake -DHerdSoftware_DIR=/path/to/HerdSoftwareBuildDir/ ../
$ make -j
```
