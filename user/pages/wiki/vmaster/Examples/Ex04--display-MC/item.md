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

## Example 4: Event display

This simple example shows how to display the events using the display algorithm provided with HerdSoftware.

Included files:
* **displayMC.eaconf**
  Configuration file for EventAnalysis

### Description
This example shows how to display the events after the digitization step in example 1. The input file is the `electrons_10GeV_sphere.dig.root` file produced by example 1, containing 100 events with a 10 GeV electron primary particle shot from a spherical surface surrounding the detector and digitized by the HerdSoftware algorithms.

Since the display algorithm currently work only with STK clusters and not with the bare hits, the `StkClusteringAlgo` algorithm also must be run. In this case it is added in `displayMC.eaconf` immediately before initializing the display.

The display algorithm needs a geometry file in order to show the HERD geometry. This file must be created using the `GGSWolowitz` program provided with GGS. Currently two formats are supported:

- `TGeo` (recommended, requires VGM version >= 4.5)
- `GDML` (there are some known bugs with this format and it is quite heavy, better avoid it)

To create the geometry file using `TGeo` run
```bash
$ GGSWolowitz -g /PATH/TO/HERD/PLUGIN/DIRECTORY/libHerdMCParametricGeo.so -gd ../Ex00_produce-mc/geometry.mac -t vgm -o HerdMCParametricGeo.root
```
(just remember that on OSX it's `libHerdMCParametricGeo.dylib`)

otherwise to use `GDML` run
```bash
$ GGSWolowitz -g /PATH/TO/HERD/PLUGIN/DIRECTORY/libHerdMCParametricGeo.dylib -gd ../Ex00_produce-mc/geometry.mac -t gdml -o HerdMCParametricGeo.gdml
```
If you choose `GDML` remember to modify `displayMC.eaconf` accordingly


To run the job just use
```bash
$ EventAnalysis -c displayMC.eaconf -d rootProvider,../Ex01_digitize-mc/electrons_10GeV_sphere.dig.root
```

Remember to set the `EA_PLUGIN_PATH` and `LD_LIBRARY_PATH` environment variables as explained in the [installation guide](User's-manual/Download,-configure,-build-and-install.md#set-the-environment) before launching the job.
