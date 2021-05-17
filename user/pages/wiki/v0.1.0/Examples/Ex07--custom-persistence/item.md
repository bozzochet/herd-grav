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

## Example 7: create a custom output
**Folder:** Ex07_custom-persistence  
Create a custom persistence service that writes output data in a custom format to a Root file.

Included files:

* **SimpleTreePersistence.{h,cpp}** 
  Header and source file of the persistence class.
* **CMakeLists.txt**  
  Build file for the persistence class.
* **customPers.eaconf**  
  Configuration file for converting a file with digitized data to the custom format.
* **customPersFromGGS.eaconf**  
  Configuration file for digitizing a GGS file and saving the information using the custom format.
  
  
### Description
In this example a custom persistence service is created. A custom persistence can be useful to save data in a custom
format, possibly more suitable for subsequent analysis steps. In principle a persistence service might deal with a
fixed set of objects to be written on file and/or some optional objects that can be booked if/when needed. Both
approaches are fine as they might serve different purposes. In this example the custom persistence deals both with
fixed and optional event data objects. The output format is a Root file where all the single variables are written
in a tree as leaves. Some output variables are extraced directly from data objects, while others need to be
computed.

The event objects from which the persistence builds the output are "mcTruth", "caloHitsMC" and, optionally,
"stkHitsCollMC". All of them can be found in the digitized output file produced by Ex01, so that file can be used as
the input file for this example. The event loop needs no alogrithms, since all the objects are already available in
the input file. The EventAnalysis configuration file `customPers.eaconf` reflects this situation; in fact, it sets
up a data conversion using only a data provider to read input and a persistence to ouput it in a different format,
using the Herd data model as the intermediate representation.

In the general case not all the event objects that are needed by the custom persistence will be available from the
input file. In this case they should be produced by some algorithm. For example, using a GGS output file as that 
produced by Ex00 as input file instead of a digitized file will need the digitization algorithms to be run to create
the objects needed by the persistence. In `customPersFromGGS.eaconf` this is done by running the digitization
algorithms as usual (in fact, this is the same as Ex01 with a different output format and without the digitization 
of STK and SCD which are not needed). The output content is the same, just produced in one step (from GGS file to
custom file) instead of two (from GGS file to digitized file to custom file).

 ### Build and launch  
 To build and launch the example follow the corresponding instructions for the EventaAnalysis job of Ex02, adjusting
 them for this example where needed.
