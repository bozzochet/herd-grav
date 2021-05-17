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

## Example 5: particle hits for the PSD

Create and analyze MC files with particle hits for the PSD.

Included files:
* **geometry.mac**  
  Geometry configuration datacard.
* **electrons_10GeV_sphere.mac**  
  Job configuration datacard for generating the Monte Carlo data file
* ** CMakeLists.txt**  
  Build file for the EventAnalysis algorithms.
* **PsdCheckAlgo.h**  
  Header of the analysis algorithm.
* **PsdCheckAlgo.h**  
  Implementation of the analysis algorithm.
* **checkPSD.eaconf**  
  Configuration file for the EventAnalysis job.
  
  
### Description
This example shows how to create and analyze a Monte Carlo file with particle hits for the PSD. As for the STK, the PSD particle
hits contain an array of hits of the single particles that contributed to the total energy release on the single sensitive element.

#### The geometry configuration datacard
The datacard sets the PSD type to tiles. 

#### The job configuration datacard
The job configuration datacard file `electrons_10GeV_sphere.mac` is similar to the ones of the previous examples. Here are the
instructions specific to the PSD particle hits:

* `/GGS/scoring/tiletopPSD.GGSIntHitSD/storeParticleHits`  (row 29)  
  Configure the simulation to use particle (i.e. particle hits in the GGS jargon) for the tile top PSD. 
* `/GGS/scoring/tilesidePSD.GGSIntHitSD/storeParticleHits` (row 31)  
  Same as above for tile lateral PSDs.
* `#/GGS/userActions/hitsAction/setHitThreshold tiletopPSD particle -1 GeV` (row 38)  
  This instruction is commented out. Uncomment it to enable the output of particles that release no energy (e.g. pass-through photons)
  on the top PSD by lowering the output threshold down to a negative number. This might noticeably increase the size of the output 
  file. 
* `#/GGS/userActions/hitsAction/setHitThreshold tilesidePSD particle -1 GeV` (row 39)  
  Same as above for tile lateral PSDs.  

#### Bar geometry
The above instructions are intended for tile PSD. For using a bar PSD with particle hits, some instructions have to be changed:
* Select `bars` PSD in the `geometry.mac` file
* Configure the usage of particle hits in the datacard with these instructions (they replace the tiles ones):
    * `/GGS/scoring/bartopPSD.GGSIntHitSD/storeParticleHits` (particle hits on top)
    * `/GGS/scoring/barsidePSDH.GGSIntHitSD/storeParticleHits` (particle hits on horizontal bars on sides)
    * `/GGS/scoring/barsidePSDV.GGSIntHitSD/storeParticleHits` (particle hits on vertical bars on sides)
    * `#/GGS/userActions/hitsAction/setHitThreshold bartopPSD particle -1 GeV` (uncomment to output also null-release particles for top)
    * `#/GGS/userActions/hitsAction/setHitThreshold barsidePSDH particle -1 GeV` (uncomment to output also null-release particles for horizontal bars on sides)
    * `#/GGS/userActions/hitsAction/setHitThreshold barsidePSDV particle -1 GeV` (uncomment to output also null-release particles for vertical bars on sides)  
    
  Note that vertical and horizontal bars on the side PSDs needs one configuration each, while all the tiles on the sides are configured with
  a single instruction.


#### Launch the simulation 
Same as Ex00.

#### Build and launch the analysis
Use the same procedure described to build and launch the analysis as an EventAnalysis job of Ex02 (with the needed adjustments). 
