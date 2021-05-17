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

This generator creates an isotropic flux of particles from a spherical surface. It is implemented following the algorithm describe in [this paper](uploads/17a1c0b26e5f81f67ee947b2b7bdfed8/20110908090428_isotropic-distribution-XTM.pdf).  
**NOTE: currently this generator generates only geantinos**

# Plugin library
The generator is built in the plugin library libHerdMCGenerators.so. It is located in the plugin subfolder of the build and install folders.

# Usage
The plugin library must be loaded when launching the GGSPenny simulation using the `-ap` command line option. In the job configuration datacard the generator must be selected with the command:

`/GGS/generatorActions/set isosphere`

and then the following commands can be used to setup the generator:

* `/herd/generators/isosphere/MinTheta`  
  Minimum value for the zenith angle of the generated particles. Default value: 0.
* `/herd/generators/isosphere/MaxTheta`  
  Maximum value for the zenith angle of the generated particles. Default value: 90 deg.
* `/herd/generators/isosphere/Radius`  
  Radius of the generation sphere. Default value: 100 cm.
* `/herd/generators/isosphere/Center`  
  Position of the center of the generation sphere. Default value: (0, 0, 0).
