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

In ParametricGeo a first acceptance check for generated particles is implemented. Only particle generated inside the defined acceptance is simulated, while Two acceptance categories are now available. 

The first one is named MCCaloAcc1, it requires that the  generated trajectory intercepts a two horizontal planes, named top and bottom  planes. The dimension of these planes are configurable (see below) but the default values are:

| Parameter | default value |
| ------ | ------ |
| top plane X width    | 85 cm    |
| top plane X width    | 85 cm    |
| top plane Y width    | 80 cm    | 
| top plane Z quote    | 3.4 cm   | 
| bottom plane X width | 85 cm    |
| bottom plane Y width | 80 cm    | 
| bottom plane Z quote | -76.6 cm | 

These planes are ~ 10% wider than the calorimeter true top and bottom surfaces. 

The second acceptance is named MCCaloAcc2, it requires the entrance point of a defined cube in one of the activated surfaces of the cube. It also requires a distance between the entrance and the exit point of the cube greater than a shower length, defined in cm. The center of the defined cube has X an Y coordinates = 0, while the Z coordinate of the center depends on the configurable parameters (see below). The default values of the MCCaloAcc2 parameters are:

| Parameter | default value |
| ------ | ------ |
| cube X width | 85 cm |
| cube Y width | 80 cm |
| cube top surface Z quote | 3.4 cm |
| cube bottom surface Z quote | -76.6 cm |
| minimum shower length | 0 cm |
| activated surfaces | top and lateral surfaces (events with entrance point on the bottom surface are rejected) |
  
The default acceptance is MCCaloAcc2. Using the geometric data card of GGS it is possible to specify the other acceptance using the following command:
*  /herd/geometry/parametric/acceptance/MCCaloAccType 1 ##(2 is default)

If MCCaloAcc1 is set, the following commands can be used to specify the acceptance parameters:

| Command | description |
| ------ | ------ |
| /herd/geometry/parametric/acceptance/caloTOPXwidth | set the top plane X width [cm] |
| /herd/geometry/parametric/acceptance/caloTOPYwidth | set the top plane Y width [cm] |
| /herd/geometry/parametric/acceptance/caloTOPZquote | set the top plane Z quote [cm] |
| /herd/geometry/parametric/acceptance/caloBOTTOMXwidth | set the bottom plane X width [cm]  |
| /herd/geometry/parametric/acceptance/caloBOTTOMYwidth | set the bottom plane Y width [cm] |
| /herd/geometry/parametric/acceptance/caloBOTTOMZquote |  set the bottom plane Z quote [cm] |

If MCCaloAcc2 is set, the following commands can be used to specify the acceptance parameters:

| Command | description |
| ------ | ------ |
| /herd/geometry/parametric/acceptance/caloTOPXwidth | set the cube X width [cm] |  
| /herd/geometry/parametric/acceptance/caloTOPYwidth | set the cube Y width [cm] |
| /herd/geometry/parametric/acceptance/caloTOPZquote |  set the cube top surface Z quote [cm] |
| /herd/geometry/parametric/acceptance/caloBOTTOMZquote | set the cube bottom surface Z quote [cm] |    
| /herd/geometry/parametric/acceptance/caloBOTTOMXwidth | **must be set exactly equal to caloTOPXwidth** |
| /herd/geometry/parametric/acceptance/caloBOTTOMYwidth | **must be set exactly equal to caloTOPYwidth** |
| /herd/geometry/parametric/acceptance/selectTOPcalo | if it is = 1 the top surface is activated, 0 it is not |
| /herd/geometry/parametric/acceptance/selectBOTTOMcalo |  if it is = 1 the bottom surface is activated, 0 it is not |
| /herd/geometry/parametric/acceptance/selectXNEGcalo | if it is = 1 the X negative lateral surface is activated, 0 it is not |
| /herd/geometry/parametric/acceptance/selectXPOScalo | if it is = 1 the X positive lateral surface is activated, 0 it is not |
| /herd/geometry/parametric/acceptance/selectYNEGcalo | if it is = 1 the Y negative lateral surface is activated, 0 it is not |
| /herd/geometry/parametric/acceptance/selectYPOScalo | if it is = 1 the Y positive lateral surface is activated, 0 it is not |
| /herd/geometry/parametric/acceptance/caloShowerLenght | set the minimum shower length [cm] |
