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

[[_TOC_]]

The Parametric geometry is based on the [Baseline geometry](http://twiki.ihep.ac.cn/twiki/view/HERD/MCDetectorConstruction) implemented by IHEP with the following modifications:
* the silicon layers of the STK are segmented either in wafers (default) or strips (on user's request)
* tungsten layers alternate with the Si STK layers
* the top and side PSDs are segmented either in bars or tiles

No support structures are implemented in this geometry, except for honeycomb trays in STK.

In addition to the detectors of the baseline geometry, three other detectors are available:  
* the Silicon Charge Detector (SCD) placed outside the PSD
* the FIber Tracker (FIT) that can be selected as a replacement for the STK
* the Transition Radiation Detector (TRD) placed outside the PSD/SCD
These detectors are not present by default and must be explicitly activated by means of geometry datacard commands (see below).
Other than optional detectors, also the CSS structure and a simplified anti-meteorite shield can be added to the simulation geometry.

Together with the default sub-detectors, more advanced versions of some sub-detectors with a more realistic design and support structures are available.
These can be used to replace the default ones by properly setting some of the parameters described below. Please refere to the description of
each sub-detector to get more details about the available versions.  

# Plugin library
The geometry is built as the plugin library `libHerdMCParametricGeo.so`. It is located in the `plugin` subfolder of the build and install folders.

# Reference frame and detector placement
The detector geometry is defined in a reference frame where the positive Z axis
points towards the zenith, and the top surface of the upper CALO layer is at
z=0.
<img src="../objects/images/ParamGeoRefFrame.png" height="400"> 

The sub-detectors on top of the CALO are stacked along Z, and extend on X and
Y directions. For the lateral sides it is not possible to define the stacking
and extension directions univocally in terms of X, Y and Z, since on each side
the standard reference axes have different meaning (e.g. on X sides, X is the
stacking axis while on Y sides the stacking axis is Y). For this reason, for
the lateral sides the directions are defined in terms of a transverse
(stacking) axis (T), a vertical axis (V) which always corresponds to the Z
axis, and a horizontal axis (H).

The positioning of the different sub-detectors on the top (lateral) side is
defined in terms of the distance from the neighboring sub-detector along the Z
(T) axis, and in terms of absolute X,Y (V,H) positions. The distances are
defined among the envelopes of the different subdetectors which might enclose
support structures; for this reason the placement distances does not
necessarily represent the distance between active elements.

<img src="../objects/images/ParamGeoTopDistances.png" width="400"> 

For the lateral sides,
the H position is defined so that a detector moves in clockwise direction as
seen from positive Z when its H position is increased. In the picture below,
the purple arrows show the displacement of a lateral detector when its H
position is increased:

<img src="../objects/images/increasingHPos.png" width="400">  

# Parameters
Some geometry parameters can be set at run time by means of datacard commands (to be placed in the geometry data card). These commands and the related meanings are:
* **General commands**  
  * `/herd/geometry/parametric/general/chargeID`  
    Sets the charge ID detector. Possible values: none, scd, scdTop (i.e. only top SCD), scdSide (i.e. SCD only on sides). Default value: none.
  * `/herd/geometry/parametric/general/tracker`  
    Sets the trackig detector. Possible values: none, stk, stkTop (i.e. only top STK), stkSide (i.e. STK only on sides), fit, fitTop, fitSide. Default value: stk.
  * `/herd/geometry/parametric/general/calorimeter`  
    Sets the calorimeter. Possible values: calo, calo_v2, none. Default value: calo.
  * `/herd/geometry/parametric/general/antiCoincidence`  
    Sets the anticoincidence detector. Possible values: none, psd, psdTop, psdSide, psd_v2, psdTop_v2, psdSide_v2. Default value: psd.
  * `/herd/geometry/parametric/general/calibration`  
    Sets the calibration detector. Possible values: none, trd. Default value: none.
  * `/herd/geometry/parametric/general/shield`  
    Sets the external shield. Possible values: none, antiMeteorite. Default value: none.
  * `/herd/geometry/parametric/general/spaceStation`  
    Adds the space station to the simulated geometry. Possible values: none, css. Default value: none.  
  *`/herd/geometry/parametric/general/caloTopFitDistance`  
    Sets the distance between the CALO and the top FIT. Default value: 15 cm  
  *`/herd/geometry/parametric/general/caloTopStkDistance`  
    Sets the distance between the CALO and the top STK. Default value: 5 cm
  * `/herd/geometry/parametric/general/topFitTopPsdDistance`  
    Sets the distance between the top FIT and the top PSD. Default value: 6.1 cm for v1 tiles PSD.
  * `/herd/geometry/parametric/general/topStkTopPsdDistance`  
    Sets the distance between the top STK and the top PSD. Default value: 6.1 cm for v1 tiles PSD.
  * `/herd/geometry/parametric/general/topPsdTopScdDistance`  
    The distance between the top PSD and the top SCD. Default value: 2 cm
  * `/herd/geometry/parametric/general/caloSideXFitDistance`  
    Sets the distance between the CALO and the lateral X FITs. Default value: 8.63 cm
  * `/herd/geometry/parametric/general/caloSideYFitDistance`  
    Sets the distance between the CALO and the lateral Y FITs. Default value: 11.53 cm
  * `/herd/geometry/parametric/general/caloSideFitDistance`  
    Sets the distance between the CALO and the lateral FITs both for X and Y sides.
  * `/herd/geometry/parametric/general/caloSideXStkDistance`  
    The distance between the CALO and the lateral STK on X sides. Default value: 5 cm
  * `/herd/geometry/parametric/general/caloSideYStkDistance`  
    The distance between the CALO and the lateral STK on Y sides. Default value: 5 cm
  * `/herd/geometry/parametric/general/sideFitSidePsdDistance`  
    Sets the distance between the side FIT and the side PSD on X and Y sides. Default value: 7.75 cm for v1 tiles PSD.
  * `/herd/geometry/parametric/general/sideStkSidePsdDistance`  
    Sets the distance between the side STK and the side PSD on X and Y sides. Default value: 17.75 cm for v1 tiles PSD.
  * `/herd/geometry/parametric/general/sidePsdSideScdDistance`  
    Sets the distance between the side PSD and the side SCD on X and Y sides. Default value: 2 cm
  

* **CALO commands**  
  * `/herd/geometry/parametric/calo/monolithic`  
  If set to true then the CALO will be built as a monolithic block of LYSO instead of being made by cubes. For testing purposes. In can be used only with the base calo geometry ( it has not effect with calo_v2). Default value: false.
  * `/herd/geometry/parametric/calo/crystalSize`  
  Set the size of LYSO crystals. Default value: 3 cm.
  * `/herd/geometry/parametric/calo/crystalDensity`  
  Set the density of LYSO crystals. Default value: 7.4 g/cm3 for calo v1 and 7.2 g/cm3 for calo v2..
  * `/herd/geometry/parametric/calo/crystalSlotSize`  
  Set the size of the tray slots containing each LYSO crystal. Cannot be set for calo_v2 geometry. Default value: 3 cm.
  * `/herd/geometry/parametric/calo/fillerMaterial`  
  Set the material that will be used to fill the gaps in CALO. Possible values are the names of the materials available in  Geant4, e.g. `G4_C`. Cannot be set for calo_v2 geometry. Default value: G4_Galactic.
  * `/herd/geometry/parametric/calo/fillerDensity` 
  Set the density of the filler material. If not set then the standard density for the given filler material will be used. Cannot be set for calo_v2 geometry. Default value: the standard density of the chosen filler material.
  * `/herd/geometry/parametric/calo/cubeMaskPath` 
  Path of a text file containing the GGS volume IDs of cubes that will be masked, i.e. made of vacuum instead of LYSO. The default value is an empty string, which means that cubes are not masked. The text file shoud only contain a list of integers separated by spaces or new lines. The cube mask can be applied only with the calo base geometry (i.e. can not be used with "calo_v2").


* **PSD commands**  
  * `/herd/geometry/parametric/psd/type`  
  Sets the PSD type either to bars or tiles. In case of bars, each PSD will be constituted of two layers of plastic scintillator bars, while in case of tiles there will be just one layer of square tiles. Possible values: tiles, bars. Default value: tiles.
  * `/herd/geometry/parametric/psd/topThickness`   
  Sets the thickness of the scintillator material in the top PSD. Default value: 1 cm (tiles), 1 cm (bars)
  * `/herd/geometry/parametric/psd/sideThickness`   
  Sets the thickness of the scintillator material in the side PSD. Default value: 1 cm (tiles), 1 cm (bars)
  * `/herd/geometry/parametric/psd/nTopBarsAlongX`  
  Number of bars on X layers. Default value: 180 (v1), 45 (v2)
  * `/herd/geometry/parametric/psd/nTopBarsAlongY`  
  Number of bars on Y layers (must be set equal to nTopBarsAlongX). Default value: 180 (v1), 45 (v2)
  * `/herd/geometry/parametric/psd/topBarWidth`  
  Width of top bars. Default value: 1 cm (v1), 3 cm (v2)
  * `/herd/geometry/parametric/psd/topBarGap`  
  Gap between bars on each top layer. Default value: 0 mm (v1), 14 mm (v2)
  * `/herd/geometry/parametric/psd/topBarLayerGap`  
  Gap between two top layers on the same view. Default value: 0 mm (v1), 4 mm (v2)
  * `/herd/geometry/parametric/psd/topBarPlaneGap`  
  Gap between X and Y planes. Default value: 10 mm (v1), 2mm (v2)
  * `/herd/geometry/parametric/psd/nSideBarsAlongH`  
  Number of bars on H layers (i.e. segmented along the horizontal direction). Default value: 162 (v1), 36 (v2)
  * `/herd/geometry/parametric/psd/nSideBarsAlongV`  
  Number of bars on V layers. Default value: 102 (v1), 25 (v2)
  * `/herd/geometry/parametric/psd/sideBarWidth`  
  Width of side bars. Default value: 1 cm (v1), 3 cm (v2)
  * `/herd/geometry/parametric/psd/sideBarGap`  
  Gap between bars on each side layer. Default value: 0 mm (v1), 14 mm (v2)
  * `/herd/geometry/parametric/psd/sideBarLayerGap`  
  Gap between two side layers on the same view. Default value: 0 mm (v1), 4 mm (v2)
  * `/herd/geometry/parametric/psd/sideBarPlaneGap`  
  Gap between H and V planes. Default value: 10 mm (v1), 2 mm (v2)
  * `/herd/geometry/parametric/psd/nTopTileLayers`  
  Number of tile layers on top (must be set either to 1 or 2). Default value: 1 (v1), 1 (v2)
  * `/herd/geometry/parametric/psd/nTopTilesAlongX`  
  Number of tiles along X on top layers. Default value: 180 (v1), 20 (v2)
  * `/herd/geometry/parametric/psd/nTopTilesAlongY`  
  Number of tiles along Y on top layers. Default value: 180 (v1), 20 (v2)
  * `/herd/geometry/parametric/psd/topTileSizeX`  
  Size of top tiles along X. Default value: 1 cm (v1), 10 cm (v2)
  * `/herd/geometry/parametric/psd/topTileSizeY`  
  Size of top tiles along Y. Default value: 1 cm (v1), 10 cm (v2)
  * `/herd/geometry/parametric/psd/topTileGapX`  
  Gap among top tiles along X. Default value: 0 mm (v1), 0 mm (v2)
  * `/herd/geometry/parametric/psd/topTileGapY`  
  Gap among top tiles along Y. Default value: 0 mm (v1), 0 mm (v2)
  * `/herd/geometry/parametric/psd/topTileLayerGap`  
  Gap between top layers. Default value: 0 mm (v1), 4 mm (v2)
  * `/herd/geometry/parametric/psd/nSideTileLayers`  
  Number of tile layers on side (must be set either to 1 or 2). Default value: 1 (v1), 1 (v2)
  * `/herd/geometry/parametric/psd/nSideTilesAlongH`  
  Number of tiles along H on side layers. Default value: 160 (v1), 16 (v2)
  * `/herd/geometry/parametric/psd/nSideTilesAlongV`  
  Number of tiles along V on side layers. Default value: 100 (v1), 11 (v2)
  * `/herd/geometry/parametric/psd/sideTileSizeH`  
  Size of side tiles along H. Default value: 1 cm (v1), 10 cm (v2)
  * `/herd/geometry/parametric/psd/sideTileSizeV`  
  Size of side tiles along V. Default value: 1 cm (v1), 10 cm (v2)
  * `/herd/geometry/parametric/psd/sideTileGapH`  
  Gap among side tiles along H. Default value: 0 mm (v1), 0 mm (v2)
  * `/herd/geometry/parametric/psd/sideTileGapV`  
  Gap among side tiles along V. Default value: 0 mm (v1), 0 mm (v2)
  * `/herd/geometry/parametric/psd/sideTileLayerGap`  
  Gap between side layers. Default value: 0 mm (v1), 4 mm (v2)
  * `/herd/geometry/parametric/psd/topXPos`  
  Position along X of the top PSD. Default value: 0. (v1), 0. (v2)
  * `/herd/geometry/parametric/psd/topYPos`  
  Position along Y of the top PSD. Default value: 0. (v1), 0. (v2)
  * `/herd/geometry/parametric/psd/xSideVPos`  
  Position along V of the side PSDs on X sides. Default value: -18.988 cm (v1), -14.5 cm (v2)
  * `/herd/geometry/parametric/psd/ySideVPos`  
  Position along V of the side PSDs on Y sides. Default value: -18.988 cm (v1), -14.5 cm (v2)
  * `/herd/geometry/parametric/psd/xSideHPos`  
  Position along H of the side PSDs on X sides. Default value: 0 cm (v1), 7.9 cm (v2)
  * `/herd/geometry/parametric/psd/ySideHPos`  
  Position along H of the side PSDs on Y sides. Default value: 0 cm (v1), 7.9 cm (v2)

  
* **STK commands** 
  * `/herd/geometry/parametric/stk/nTopLayers`  
  Number of X-Y double Si layers in the top STK. Default value: 6.
  * `/herd/geometry/parametric/stk/nTopWlayers`  
  Number of tungsten layers in the top STK; see below for details. Default value: 3.  
  * `/herd/geometry/parametric/stk/nSideLayers`  
  Number of X-Y double Si layers in the side STK. Default value: 6.
  * `/herd/geometry/parametric/stk/nTopWafers`  
  Number of wafers along X and Y in top STK. Default value: 14
  * `/herd/geometry/parametric/stk/nSideWafersH`  
  Number of wafers along H in side STKs. Default value: 12
  * `/herd/geometry/parametric/stk/nSideWafersV`  
  Number of wafers along V in side STKs. Default value: 6
  * `/herd/geometry/parametric/stk/topAbsThickness`   
  Sets the thickness of the absorber material in the STK. Default value: 1 mm
  * `/herd/geometry/parametric/stk/topStripPitch`  
  Strip pitch for top STK; if set it will add strip volumes to the simulation geometry.  
  * `/herd/geometry/parametric/stk/sideStripPitch`  
  Strip pitch for side STKs; if set it will add strip volumes to the simulation geometry.
  * `/herd/geometry/parametric/stk/topXPos`  
  Position along X of the top STK. Default value: 0.
  * `/herd/geometry/parametric/stk/topYPos`  
  Position along Y of the top STK. Default value: 0.
  * `/herd/geometry/parametric/stk/xSideVPos`  
  Position along V of the side STKs on X sides. Default value: 26.026 cm.
  * `/herd/geometry/parametric/stk/ySideVPos`  
  Position along V of the side STKs on Y sides. Default value: 26.026 cm.
  * `/herd/geometry/parametric/stk/xSideHPos`  
  Position along H of the side STKs on X sides. Default value: 20.455 cm.
  * `/herd/geometry/parametric/stk/ySideHPos`  
  Position along H of the side STKs on Y sides. Default value: 17.556 cm.
  
* **SCD commands**  
  * `/herd/geometry/parametric/scd/siliconThickness`  
  Sets the thickness of the silicon sensors in the SCD. Default value: 150 um
  * `/herd/geometry/parametric/scd/nTopLayers`  
  Number of X-Y double Si layers in the top SCD. Default value: 4.
  * `/herd/geometry/parametric/scd/nSideLayers`  
  Number of X-Y double Si layers in the side SCD. Default value: 4.
  * `/herd/geometry/parametric/scd/nTopWafers`  
  Number of wafers along X and Y in top SCD. Default value: 20
  * `/herd/geometry/parametric/scd/nSideWafersH`  
  Number of wafers along H in side SCDs. Default value: 18
  * `/herd/geometry/parametric/scd/nSideWafersV`  
  Number of wafers along V in side SCDs. Default value: 9
  * `/herd/geometry/parametric/scd/topStripPitch`  
  Strip pitch for top SCD; if set it will add strip volumes to the simulation geometry.  
  * `/herd/geometry/parametric/scd/sideStripPitch`  
  Strip pitch for side SCDs; if set it will add strip volumes to the simulation geometry.
  * `/herd/geometry/parametric/scd/topXPos`  
  Position along X of the top SCD. Default value: 0.
  * `/herd/geometry/parametric/scd/topYPos`  
  Position along Y of the top SCD. Default value: 0.
  * `/herd/geometry/parametric/scd/xSideVPos`  
  Position along V of the side SCDs on X sides. Default value: fixed w.r.t top PSD.
  * `/herd/geometry/parametric/scd/ySideVPos`  
  Position along V of the side SCDs on Y sides. Default value: fixed w.r.t top PSD.
  * `/herd/geometry/parametric/scd/xSideHPos`  
  Position along H of the side SCDs on X sides. Default value: 2 cm.
  * `/herd/geometry/parametric/scd/ySideHPos`  
  Position along H of the side SCDs on Y sides. Default value: 2 cm.
  * `/herd/geometry/parametric/scd/topXYGap`  
  Sets the gap between X and Y layers in the top SCD. Default value: 0.5 mm.  
  * `/herd/geometry/parametric/scd/sideXYGap`  
  Sets the gap between X and Y layers in the side SCD. Default value: 0.5 mm.  
  * `/herd/geometry/parametric/scd/topTrayGap`  
  Sets the gap between trays in the top SCD. Default value: 2 mm.  
  * `/herd/geometry/parametric/scd/sideTrayGap`  
  Sets the gap between trays in the side SCD. Default value: 2 mm.  
  * `/herd/geometry/parametric/scd/hasFoam`  
  Fills the SCD volume with foam. Default value: false
  * `/herd/geometry/parametric/scd/foamDensity`  
  Density of the foam. Default value: 192 kg/m3
  * `/herd/geometry/parametric/scd/foamMaterial`  
  Material of the foam. Default value: polyurethane


* **FIT commands**  
  * `/herd/geometry/parametric/fit/nTopLayers`   
  Number of top FIT X-Y double layers. Default value: 5.
  * `/herd/geometry/parametric/fit/nSideLayers`   
  Number of X-Y double layers inside each side FIT. Default value: 9.
  * `/herd/geometry/parametric/fit/nTopWLayers`  
  Number of top FIT trays with tungsten (nTopWLayers<=(nTopLayers-2)). Do not use this command together with "listOfTopWDoubleLayers" command. By using nTopWLayers command the positions of the tungsten layers are fixed, see FIT description. Default value: 0.
  * `/herd/geometry/parametric/fit/nSideWLayers`  
  Number of side FIT trays with tungsten (nSideWLayers<=(nSideLayers-2)). Do not use this command together with "listOfSideWDoubleLayers" command. By using nSideWLayers command the positions of the tungsten layers are fixed, see FIT description. Default value: 0.
  * `/herd/geometry/parametric/fit/listOfTopWDoubleLayers`  
  Presence of tungsten layer above each fiber double layer of top fit. Do not use this command together with "nTopWLayers" command. The command must be written as a sequence of ones or zeros, the first number is connected to the outer layer, e.g. 001100 means that tungsten layers are placed above the third and fourth fit layers starting from the outer.
  * `/herd/geometry/parametric/fit/listOfSideWDoubleLayers`  
  Presence of tungsten layer above each fiber double layer of side fit. Do not use this command together with "nSideWLayers" command. This string must be written as a sequence of ones or zeros, the first number is connected to the outer layer, e.g. 001100 means that tungsten layers are placed above the third and fourth fit layers starting from the outer one.
  * `/herd/geometry/parametric/fit/WThickness`  
  Thickness of the FIT tungsten layers [cm]. Default value: 0.2 cm.
  * `/herd/geometry/parametric/fit/sidePlaneSizeH`  
  Size of side FIT planes along the horizontal direction. Default value: 106.0 cm
  * `/herd/geometry/parametric/fit/sidePlaneSizeV`  
  Size of side FIT planes along the vertical direction. Default value: 74.2 cm
  * `/herd/geometry/parametric/fit/topPlaneSize`  
  Dimension of planes on top FIT, i.e. along X and Y. Default value: 116.6 cm
   * `/herd/geometry/parametric/fit/topXPos`  
  Position along X of the top FIT. Default value: 0.
  * `/herd/geometry/parametric/fit/topYPos`  
  Position along Y of the top FIT. Default value: 0.
  * `/herd/geometry/parametric/fit/xSideVPos`  
  Position along V of the side FITs on X sides. Default value: -26.19 cm
  * `/herd/geometry/parametric/fit/ySideVPos`  
  Position along V of the side FITs on Y sides. Default value: -26.19 cm
  * `/herd/geometry/parametric/fit/xSideHPos`  
  Position along H of the side FITs on X sides. Default value: 6.42 cm
  * `/herd/geometry/parametric/fit/ySideHPos`  
  Position along H of the side FITs on Y sides. Default value: 6.42 cm


* **TRD commands**  
  * `/herd/geometry/parametric/trd/nModulesH`   
  Number of modules along the horizontal direction. Default value: 3.
  * `/herd/geometry/parametric/trd/nModulesV`   
  Number of modules along the vertical direction. Default value: 3.
  * `/herd/geometry/parametric/trd/posH`   
  Position of the TRD center-of-mass along the horizontal direction. Default value: 0. cm
  * `/herd/geometry/parametric/trd/posV`   
  Position of the TRD center-of-mass along the horizontal direction. Default value: -36.6 cm ( -> center of the calorimeter)
  * `/herd/geometry/parametric/trd/gapFromSideDetector`
  Gap from the nearest side detector (PSD or SCD). Default value: 5 cm.


* **Shield commands**
  * `/herd/geometry/parametric/shield/amThickness`  
  Thickness of the anti-meteorite shield. Default value: 1. mm
  * `/herd/geometry/parametric/shield/amMaterial`  
  Material of the anti-meteorite shield. Possible values: Al. Default value: Al
  * `/herd/geometry/parametric/shield/amGap`  
  Gap between the AM shield and the nearest (i.e. SCD) detector. Default value: 5 cm  


* **CSS commands**
  * `/herd/geometry/parametric/css/spSpinAngleM1_1`  
  Spin angle of panel 1 on module 1. Default value: 0.
  * `/herd/geometry/parametric/css/spSpinAngleM1_2`  
  Spin angle of panel 2 on module 1. Default value: 0.
  * `/herd/geometry/parametric/css/spSpinAngleM2_1`  
  Spin angle of panel 1 on module 2. Default value: 0.
  * `/herd/geometry/parametric/css/spSpinAngleM2_2`  
  Spin angle of panel 2 on module 2. Default value: 0.
  * `/herd/geometry/parametric/css/spSpinAngleMC_1`  
  Spin angle of panel 1 on module Core. Default value: 0.
  * `/herd/geometry/parametric/css/spSpinAngleMC_2`  
  Spin angle of panel 2 on module Core. Default value: 0.
  * `/herd/geometry/parametric/css/spRevAngleM1`  
  Revolution angle of the couple of panels on module 1. Default value: 0.
  * `/herd/geometry/parametric/css/spRevAngleM2`  
  Revolution angle of the couple of panels on module 2. Default value: 0.
  * `/herd/geometry/parametric/css/spSpinAngleM1`  
  Spin angle of both panels on module 1. Default value: 0.
  * `/herd/geometry/parametric/css/spSpinAngleM2`  
  Spin angle of both panels on module 2. Default value: 0.
  * `/herd/geometry/parametric/css/spSpinAngleM1M2`  
  Spin angle of all the panels on modules 1 and 2. Default value: 0.
  * `/herd/geometry/parametric/css/spSpinAngleMC`  
  Spin angle of both panels on module Core. Default value: 0.
  * `/herd/geometry/parametric/css/spRevAngleM1M2`  
  Revolution angle of both couples of panels on modules 1 and 2. Default value: 0.


# Details
## CALO
* Names of sensitive volume: `Crystal`
* GGS hit type: integrated

The CALO is made of LYSO cubes with a default size of 3 cm and a default density of 7.4 g/cm3. Its depth from top
to bottom is 21 cubes. The baseline of the calorimeter is include by using the
name "calo". The structure is the same of the baseline geometry by IHEP, which
includes only the LYSO crystals, all the supporting structures are not included
and the space between crystals (gaps) is empty by default. It is possible to
specify a material to fill the gaps, in order to add passive material roughly
representing a support structure. The filler material is homogeneous but its
density can be set as well to mimic a non-homogenous fill. Some cubes can be filled
with vacuum instead of LYSO if a cube mask is indicated: it is usefull to mimic a calorimeter
which contains a smaller number of cube with respect to the base geometry.

The size of the cubes can be set by means of a datacard command, together with
the size of the tray slots holding each cube. In this way a cube smaller than
the slot containing it can be defined. Note that currently the position of the
center of the cube is unchanged when changing its dimensions; in particular
this means that it will sit at mid-air in its tray slot, and not lay on the
bottom of the slot. The calo geometry does not include the support trays so
these considerations are to be considered as applied to a hypothetical tray.

A more refined geometry can be activated using the name "calo_v2". This
geometry includes supporting structures, mostly made by carbon fiber ("G4_C"
inside the simulation). The number of crystals is the same of the "calo" but
the positions are slightly different since some gaps between crystals were
decreased, and the defult density is 7.2 g/cm3. The GGS ID of the crystals of "calo_v2" are completely different
with respect to the "calo", since it is convenient to use the position of the
crystals instead of the GGS ID for the calculation (e.g. inside the
GGSDataProvider).

Currently it is possible to set the cube side for calo_v2 but not the tray slot
size which is forced to its default value of 3 cm.

## PSD
* Names of sensitive volumes for bar PSD: `bartopPSD` (for top PSD), `barsidePSDH`and `barsidePSDV` (for side PSD, where "V" indicates the vertical bars and "H" the horizontal one)
* Names of sensitive volumes for tiles PSD: `tiletopPSD` (for top PSD), `tilesidePSD` (for side PSD)
* GGS hit type: particle or integrated

The PSD sensitive elements are made of the standard Geant4 material [G4_PLASTIC_SC_VINYLTOLUENE](http://geant4-userdoc.web.cern.ch/geant4-userdoc/UsersGuides/ForApplicationDeveloper/html/Appendix/materialNames.html). They are shaped either as bars or tiles, depending on the [chosen PSD type](#parameters).
When tiles are selected a single layer of squared tiles is used for all the PSDs.

There are currently two available mainline versions of the PSD: version 1 (v1) and version 2 (v2). The version can be chosen by means of the  `/herd/geometry/parametric/general/antiCoincidence`
general command described above in the [Parameters](#parameters) section. After choosing the version, the single parameters can be set if values different from the
default ones are needed. Below, a brief description of the two versions is given.

### PSD v1
This PSD is made just of scintillating elements, with no support structures. The bar version consists of two planes of bars:
* on top, the bars in the layer farthest from the calorimeter are aligned along Y, so the layer is segmented along X; the other layer is segmented along Y  
* on sides, the bars in the layer farthest from the calorimeter are aligned along the horizontal (H) direction, so the layer is segmented along the vertical (V)
  direction; the other layer is segmented along H (Note: V is always Z, while H is X for PSDs on Y sides and Y for PSDs on X sides).  

The tile version consists of just one layer both on top and on sides.

On each layer there is no gap between the sensitive elements, i.e. bars and tiles are placed contiguously.

### PSD v2
This PSD includes support structures made of carbon fiber above and below the layers of sensitive elements, and also a more realistic design including gaps
between the scintillators. The bars version is still made of two planes like v1, but each plane is made of two staggered layers of bars, for a total of 4 layers:

<img src="../objects/images/psd_v2_bars.svg" width="800">  

and here's how a simplified view of the detector geometry including the bars PSD v2 looks like:  

<img src="../objects/images/G4Geo_barspsdv2_calo.png" width="600">

The tiles version of PSD v2 is much similar to the v1, except for the addition of support structures and of different geometric quotes. Each PSD is made
of a single plane with a single layer of tiles, with no spacing between tiles:

<img src="../objects/images/psd_v2_tiles.svg" width="800">

### Setting the PSD parameters
The PSD parameters can be set in the geometry datacard after selecting the PSD version. The complete list of the parameter setting commands is reported above
in the `PSD commands` sub-section of the [Parameters](#parameters) section, together with a brief description and the default values for each version. As an example,
putting these commands:

```
/herd/geometry/parametric/psd/type tiles
/herd/geometry/parametric/general/antiCoincidence psd_v2
/herd/geometry/parametric/psd/nTopTileLayers 2
/herd/geometry/parametric/psd/topTileGapX 5 mm
/herd/geometry/parametric/psd/topTileGapY 5 mm
```

in the geometry datacard, a tile PSD v2 will be built, using two layers instead of one on top, and placing the tiles 5 mm apart both on X and Y. Here's how the
resulting top PSD looks like:  

<img src="../objects/images/toppsdv2_tiles_nonstandard.png" width="800">

Notice the staggering of the tho layers, to try to minimize the dimension of the empty channels due to gaps.

## STK

### Hits and segmentation
The sensitive volumes and hit types for STK depends on whether it is segmented in wafers or in strips.
* Wafer segmentation  
  * Names of sensitive volumes: `siWaferTop` (for top STK), `siWaferSideH` and `siWaferSideV` (for lateral STKs)
  * GGS hit type: particle
* Strip segmentation  
  * Names of sensitive volumes: `siStripTop` (for top STK), `siStripSideH` and `siStripSideV` (for lateral STKs)
  * GGS hit type: integrated

The STK is made of pairs of layers of Si microstrip detectors. Each layer is segmented in wafers (tiles of Si) but the single microstrips are not implemented by default, to keep the runtime geometry simple and reduce the memory footprint and the computation time. Thus the STK sensitive element is the single wafer. The energy deposits in the single strips must be reconstructed by a digitization algorithm during offline processing of the MC output file. For doing so, the energy deposit and the impact point of each particle on Si wafers must be recorded; this means that hits on Si wafers must be GGS particle hits.

Volumes for STK strips can be enabled in the geometry datacard in order to produce smaller output files. With native strips, integrated hits can be used and then the output file can generally be smaller. And generally again the results will be different from those obtained by simulating a geometry with wafer, using particle hits and digitizing the particle hits into strip hits. Also, the simulation times are likely longer (no measurement yet).

The two different segmentation types are mutually exclusive, so the user must choose which one to use before starting the simulation runs. Also, the datacard commands for the two cases are slightly different; see [Ex00](Examples/Ex00:-produce-MC.md) for a complete datacard example for each case.

### Layers layout
The STK layers  are arranged as:  
<img src="../uploads/a30798aeeafd11edff76b14e6cab46e3/STKstruct.png" width="240">  
The green layers are Si layers while the yellow ones are tungsten. The first tungsten layer is placed just above the second couple of Si layers. In current implementation **there are no tungsten layers in the lateral STKs**.

### Segmentation directions
The outmost (i.e. the one farthest from the calorimeter) silicon layer of top STK is segmented along X. The outmost layer of each side STK is segmented along the horizontal direction (i.e. X for STKs on Y sides and vice versa).
These segmentation conventions are implemented directly in the detector geometry when using strip volumes; 

## FIT

### Hits and segmentation
Currently there is no segmentation in the FIT. Implementing fibers would be too stressful to the simulation due to the very large number of volumes involved.


The current FIT implementation consists of 5 double layers of scintillating fibers on top and 9 double layers on side. The single fibers are not implemented in the
simulated geometry: each layer is thus a single piece of scintillator. Only particle hits are implemented for the FIT. If you need to work with mats and SiPMs please check the dedicated digitization algorithm.

### Layers layout
The FIT layers are arranged as:  
<img src="../objects/images/FitGeo.png" width="400">  
(side represented here, top is similar but with less total layers). The red layers are the FIT sensitive layers while the gray ones are the support structures.


The standard FIT configuration does not contain tungsten layers. It is possible to add tungsten layers above the double layers of scintillating fibers. By using "listOfTopWLayers" and "listOfSideWLayers" commands, it is allowed to add W layers above each fiber double layers (see command description). By using "nTopWLayers" and "nSideWLayers" commands,  position and number of tungsten layers are constraint with the following rules. The maximum number of tungsten layers is equal to the number of X-Y double layers - 2; this configuration ensures that the bottom two double layers of scintillating fibers can not be covered by tungsten. For the top (side) FIT, tungsten layers are added starting from the third double layers of scintillating fibers and moving to the top (external) plane; e.g. if the number of top tungsten layers is equal to 2, these layers are added above the second and the third layer starting from the top. The latter way of palcing tungsten layers is mantained for backwards compatibility,

<img src="../objects/images/FITWimage.png" width="400">  
Side FIT with 4 tungsten layers (yellow lines) using "nSideWLayers" option.

### Placement
By default the lateral fits are placed at the same distance from the Z axis,
on all the four sides. This means that the the distance from the calorimeter is
not the same on X and on Y sides, since the calorimeter have different
extension along the two axes. The CALO-FIT distance is settable independently
for X and Y sides by means of geometry datacard commands, and there is also one
command for setting the same distance for all the 4 sides: in this case the X
and Y FITs wil be placed at different coordinates so that the distance from the
CALO is fixed.

## SCD
The SCD description follows closely the one of the STK, with the exception that there are no tungsten planes involved. Also there are a few more geometric parameters to play with (see the full parameter description above).

### Production cuts
One of the few differences w.r.t. the STK is that in the SCD we can set the value for the kinematic production cuts for particles in the simulation. In the geometry a dedicated region has been defined, calles `SCDSiWafer`; any cut applied to this region will be applied to all particles traversing the silicon wafers of the SCD. To change the default values add the following commands:

```
# change production cut to 10 micron
/run/setCutForRegion SCDSiWafer 0.01 mm
/run/initialize
```

at the beginning of the the GGS datacard (the one set with the `-d` parameter of GGSPenny, not the geometry datacard).

### Foam
The SCD can optionally be filled with foam, to simulate one of the possible versions of the support mechanics. The
foam density and the material can be set (currently only the polyurethane is available as the materials). The default
values (192 kg/m3 polyurethane) are matched to those of the PORON 4701-43RL-12 foam, just taken as a reference;
currently there's no indication about the most suitable foam model, nor about the actual usage of foam in the final SCD
model.

## TRD
The TRD is currently present in a very simplified form. It consists of several modules placed side by side; each module is composed as shown in this picture:  
<img src="../objects/images/SimpleTRDModule.png" width="400">  

The current default configuration consists of 3x3 modules. The TRD is placed on the Xpos face, outside the outmost of the other sub-detectors (i.e. the PSD, or the
SCD if it is present). The center of the PSD is placed by default at the same vertical (Z) and horizontal (X) coordinates of the center of the calorimeter.

<img src="../objects/images/TRDPosition1.png" width="400">  
<img src="../objects/images/TRDPosition2.png" width="400">  
<img src="../objects/images/TRDPosition3.png" width="400">

The position and the dimensions of the TRD can be adjusted with datacard commands. 

## Shield
The outer detector shield is currently not defined; it is assumened that an
anti-meteorite shielding and a thermal blanket at least will be present.
Currently, a reference implementation of a simplified anti-meteorite shield is
optionally available in the simulation geometry. It consists of simple aluminum
layers on all the top and lateral sides.

<img src="../objects/images/amShield.png" width="400">  

In the above picture the HERD detector enclosed in the reference anti-meteorite shield is shown. 

## CSS
The space station can be added to the simulation geometry for those studies where the presence of surrounding structures might be significant. This will not impact
the detector placement, i.e. the detector is always placed at the same coordinates with the same orientation.  

<img src="../objects/images/CSS1.png" width="400">  
<img src="../objects/images/CSS2.png" width="400">  
<img src="../objects/images/CSS3.png" width="400">

(Note: in the above picture the CSS geometry is an old version, with the Italian module and no solar panels.) 

### Solar panels
The orientation of the CSS solar panels can be adjusted by setting the spin and revolution angles. The angles are defined following the
left-hand rule as in this picture:

<img src="../objects/images/CSS-panels.png" width="400">

The direction of the arrows denotes the positive direction of rotation and revolution angles.
