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

## Example 12: CSS

Run a MC simulation including the Chinese Space Station (CSS) structure in the simulation geometry.

Included files:
* **geometry.mac**  
  Geometry configuration datacard.
* **electrons_10GeV_bigSphere.mac**  
  Job configuration datacard for the Monte Carlo run.
  
  
### Description
This example shows how to add the CSS structure to the Monte Carlo simulation, and how to generate events to take into
account the presence of the CSS.

#### The geometry configuration datacard
The datacard sets a geometry including the Herd detector with a given set of subdetectors and the CSS.
##### Angles of the solar panels
The angles of the solar panels can be set by uncommenting out the relative instructions in the geometry datacard. Angles
can be set independently or in groups.  

#### The job configuration datacard
The job configuration datacard file `electrons_10GeV_bigSphere.mac` is similar to the datacards in other examples.
The only notable diffrences are:
- the generation surface is a sphere with radius 45m: it encompasses the whole CSS, so the generated primaries can hit
  the space station structures before eventually arriving on the detector;
- the range of the polar angles is limited between 0 and 3.82 degrees (please take in mind that the polar angle is
  referred to the normal direction to the sphere in the generation point, not to the Z axis): this ensures that only
  those events directed towards the detector are generated. In particular, only those events hitting a sphere with
  radius 3mm around the detector are generated, so that the generation on the 45m sphere with limited polar angle
  range is equivalent to the generation on the 1.5m sphere with full span in polar angle;
- both spheres are centered on the center of the bottom surface of calo.
