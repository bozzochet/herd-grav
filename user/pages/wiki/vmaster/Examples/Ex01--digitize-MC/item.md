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

## Example 1: digitization of Monte Carlo files

This simple example shows how to define an analysis job by means of an EventAnalysys configuration file.

Included files:
* **digitizeMC.eaconf**  
  Configuration file for the digitization job
  
### Description
This example shows how to process a Monte Carlo output file to produce a digitized data file. A zero suppression algorithm is also used to store the photo diode signals which are above thresholds, which are 3 times the noise of the corresponding channel. The input file is the `electrons_10GeV_sphere.root` file produced by example 0, containing 100 events with a 10 GeV electron primary particle shot from a spherical surface surrounding the detector. The file can be digitized using the configuration file:

```bash
$ EventAnalysis  c digitizeMC.eaconf
```
Remember to set the `EA_PLUGIN_PATH` and `LD_LIBRARY_PATH` environment
variables as explained in the
[installation guide](User's manual/Download,-configure,-build-and-install.md#set the environment)
before launching the analysis. The output data is written to file
`electrons_10GeV_sphere.dig.root`. This file contains the geometric parameters
of STK and PSD, and the hits for CALO, STK and PSD; for the latter two 
detectors the hits are digitized using the geometric digitization algorithm, as
specified in the configuration file. The CALO hits are digitized according to
the photodiode read out. The output format is that of the
HerdRootPersistenceService; see the related section in the
[EventAnalysis user's manual](https://wizard.fi.infn.it/eventanalysis/manual/)
for some details about the format.
