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

## Example 3: native STK strips

Repeat Ex00 and Ex01 using native MC strips.

Included files:
* **geometry.mac**  
  Geometry configuration datacard.
* **electrons_10GeV_sphere.mac**  
  Job configuration datacard for generating the Monte Carlo data file to be digitized.
* **digitizeMC.eaconf**  
  Configuration file for the digitization job
  
### Description
This example shows how produce and process simulation files using "native" STK strips. By default the STK is segmented in wafers in
order to reduce the number of volumes in the MC simulation; the energy released in each wafer by every single particle is recorded
in the MC output file, and then the energy deposit in each strip is computed offline by a digitizer algorithm. This workflow can
generate big MC output files, so an alternative workflow is to introduce strip volumes directly in the MC geometry ("native strips")
and output only the total energy deposit on each strip rather than the energy deosit of each particle. This example repeats Ex00 and 
Ex01 using native STK strips instead of wafers. In the following, only the differences with respect to Ex00 and Ex01 are described;
please refer also to those examples for information about how to launch the MC and analysis jobs.    

#### The geometry configuration datacard
The datacard sets the size of the native strips to 150 micron for top and side STKs. 

#### The MC job configuration datacard
* Definition of the sensitive volumes  
  The card activates integrated strip hits for top and side STK. For side STK, due to technical reasons, the hits must be activated
  separately for horizontal and vertical strips.
* Setup of the output information on Root file  
  Since integrated STK strip hits are used there's no necessity to set the threshold for STK particle hits, so these instructions 
  which are present in the MC datacard of Ex00 are not present here.  

#### The digitization job configuration file
The `StkGeometricDigitizerAlgo` is removed from the algorithm sequence since the energy deposit in each strip is already available
in MC output files.
