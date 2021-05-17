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

The simulation elements implemented in Herdsoftware consists of detector geometry and particle generator to be used in a GGS simulation. For all the other simulation entities (hits, sensitive detectors, other generators etc.) the standard GGS implementations are used. Currently, the available elements are:
* Detector geometries:
  * [Parametric](Detector-geometry:-parametric.md)
    * [Acceptance check for paramteric geometry](Acceptance-check-in-MC.md)
* Generators:
  * [IsoSphere](Particle-generator:-IsoSphere.md)

Other resources:
* [How to run a simulation](Run-a-simulation.md)
