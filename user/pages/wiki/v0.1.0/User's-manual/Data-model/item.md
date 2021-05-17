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

[[_TOC_]]

The set of data objects that are manipulated by the algorithms constitutes the so-called Herd data model. The data objects are encoded as C++ types, either standard ones or defined in HerdSoftware (e.g. classes). All of them are enclosed in the Herd namespace.

Currently the Herd data model consists of data objects describing different entities. Below a brief description of each data object is given. The name of each data objects correspond to that of the C++ type/class implementing it. Additional information for each data object can be found in the [doxygen documentation](https://wizard.fi.infn.it/herd/software/doxygen) of each class.

# Where is the `Event` object?
In the HerdSoftware data model there's no `Event` class or object. The purpose of this entity is usually to provide a unique point of access to all the data regarding an event. In EventAnalysis this is already accomplished by the event data store, which naturally contains all the data objects related to the event, so an `Event` class/object is not needed. This solution is more flexible since it allows to add new event data very easily (it is sufficient to add a new object to the event data store) and concurrently by different developers (as long as they use different names there will be no clash), and doesn't require to modify (and re-distribute to everybody) a C++ class.

Algorithms needing event data should then fetch each event data object separately.

# Measurement Units convention
In the HerdSoftware data model the following conventions are used, unless otherwise specified in the documentation.

| Quantity | Unit |
|----------|------|
| Length | cm |
| Time | ns |
| Time (slow control) | s | 
| Temperature | Celsius degrees |
| Energy | GeV |
| Momentum | GeV/c |
| Mass | GeV/c^2 |

Exceptions to this convention (*e.g.* digitized hits where the energy deposit is expressed in ADC counts, or pathlength expressed in units of radiation length) are always specified in the doxygen documentation for the corresponding algorithms that produced the object so, whenever in doubt, consult the documentation. Usually also the object name or alias contain hints on the units used.

# Reference frame entities
These are mainly enums used to assign an alias to the various entities defining the reference frame, e.g. the axes or the directions. All of them are defined in the [RefFrame](https://wizard.fi.infn.it/herd/software/doxygen/master/namespaceHerd_1_1RefFrame.html) namespace. Their goal is to avoid mistakes in associating integer values or any other numerical identifier to the entities defining the reference frame (typical example: does 0 means X or Y??). In addition there are some custom containers that are indexed by the RefFrame enums instead of integers and some utilities to ease looping over al the values of an enum.

* [**Coo**](https://wizard.fi.infn.it/herd/software/doxygen/master/namespaceHerd_1_1RefFrame.html)
Enumeration for all the coordinate labels (X, Y and Z).

* [**Axis**](https://wizard.fi.infn.it/herd/software/doxygen/master/namespaceHerd_1_1RefFrame.html)
Enumeration for the axis values. Currently it contains only X, Y and Z axes, but other values can be added to identify other axes if needed, e.g. XY and YX for the bisector axes of the X-Y plane.

* [**Direction**](https://wizard.fi.infn.it/herd/software/doxygen/master/namespaceHerd_1_1RefFrame.html)
Enumeration for direction values.

* [**View**](https://wizard.fi.infn.it/herd/software/doxygen/master/namespaceHerd_1_1RefFrame.html)
Enumeration for 2D projections or "views".

* [**Side**](https://wizard.fi.infn.it/herd/software/doxygen/master/namespaceHerd_1_1RefFrame.html)
Enumeration for the experiment sides (currently the top and the four lateral sides).

* [**AxesArray**](https://wizard.fi.infn.it/herd/software/doxygen/master/classHerd_1_1AxesArray.html), [**CooArray**](https://wizard.fi.infn.it/herd/software/doxygen/master/classHerd_1_1CooArray.html), [**SidesArray**](https://wizard.fi.infn.it/herd/software/doxygen/master/classHerd_1_1SidesArray.html)
Having enums for Axis, Coo, Side that helps in identifying axis, coordinate or side, it is useful to have containers that can be indexed using such enums. For example it is safe and clear to retrieve the X coordinate from an array of three coordinate values e.g. as coordinate[RefFrame::Coo::X]. For this purpose some custom containers that can be indexed with Axis or Coo or Side are present.

* [**Axes, Sides**](https://wizard.fi.infn.it/herd/software/doxygen/master/namespaceHerd_1_1RefFrame.html)
In order to loop over all the elements of an AxesArray or a SidesArray, two containers containing all the Axis and Side values are present. As an example one can loop over all the Side values by means of:
   for (auto &side : Sides){ ... }
and similarly for Axes.

# Geometric entities
These data objects model the geometric entities that are used in the analysis.

* [**Point**](https://wizard.fi.infn.it/herd/software/doxygen/master/classPoint.html)
A point in 3D space, with coordinate values.

* [**PhysPoint**](https://wizard.fi.infn.it/herd/software/doxygen/master/classHerd_1_1PhysPoint.html)
A physical point with coordinate values and resolution (for modeling points whose position is known with finite accuracy).

* [**Line**](https://wizard.fi.infn.it/herd/software/doxygen/master/classHerd_1_1Line.html)
A line in 3D space with some utility methods (not completely implemented yet).

* [**Plane**](https://wizard.fi.infn.it/herd/software/doxygen/master/classHerd_1_1Plane.html)
A plane in 3D space with some utility methods (not completely implemented yet), including a method which computes the intersection between the Plane and a Line.

* [**Parallelogram**](https://wizard.fi.infn.it/herd/software/doxygen/master/classHerd_1_1Parallelogram.html)
A rectangular portion of a 3D plane, i,.e. a flat parallelogram in 3D space.

* [**Rectangle**](https://wizard.fi.infn.it/herd/software/doxygen/master/classHerd_1_1Rectangle.html)
A rectangular portion of a 3D plane, i,.e. a flat rectangle in 3D space. Implemented as a special case of `Parallelogram`

* [**Line2D**](https://wizard.fi.infn.it/herd/software/doxygen/master/classHerd_1_1Line2D.html)
A line in 2D space with some utility methods (not completely implemented yet).

# Bitmasks
Bitmasks are implemented as type-safe `enum class` types with additional properties, detailed ["here"](BitMasks.md)

# Hits and reconstructed quantities
These data objects model the quantities directly measured by the detector (i.e. energy releases or "hits") and the physical quantities that can be reconstructed starting from them. Various kind of hits are available, and they are organized in containers to reflect the physical structure of the detector (i.e. all the hits recorded on a detector layer may be grouped into an array). The geometry information related to the hits, e.g. the position of the sensor that recorded the hit, is stored in different objects, described in ["Geometry parameters"](#geometry-parameters).

* [**Hit**](https://wizard.fi.infn.it/herd/software/doxygen/master/classHerd_1_1Hit.html)
An energy deposit in a single sensitive element. Might describe the energy released in a single LYSO crystal of the calorimeter, or in a single tile of the PSD etc. It stores the deposited energy and an unambiguous volume ID of the sensor that recorded the hit. The volume ID should be used to retrieve geometry information regarding the hit element, e.g. the position.

* [**Cluster**](https://wizard.fi.infn.it/herd/software/doxygen/master/classHerd_1_1Cluster.html)
A cluster is a collection of contiguous Silicon Detector strip with a hit. The exact definition of which strips contribute to a cluster depends on the clusterization criterion. The Cluster holds a collection of the Hits constituting it, and provides some utility methods.


* **Hit containers**
Hits of a single detector (e.g. the calorimeter or the top PSD) are placed in a hit container.
STK and PSD hits are grouped by layers, with one vector of hits per layer. These vectors will have one element per each hit element (e.g. PSD tile, Si strip etc.), so if an element does not register any energy deposit then its hit will not be present. Thus the number of hits is different event by event. Each layer vector is an element of a vector of vectors of Hits. So a given hit can be accessed by means of a double subscript notation, where the first index is the layer and the second one is the hit number on that layer, e.g. stkHits[iLayer][iHit]. The number of hits in a given layer is given by e.g. stkHits[iLayer].size().
Calo hits are grouped all together, thus  a given hit can be accessed using a single index which is the hit number, e.g caloHits[iHit].

  * [**CaloHits**](https://wizard.fi.infn.it/herd/software/doxygen/master/namespaceHerd.html)
Container for the Hits in the LYSO cubes of the calorimeter.

  * [**SiliconDetectorHits**](https://wizard.fi.infn.it/herd/software/doxygen/master/namespaceHerd.html)
Container for the Hits on the strips of a silicon detector (e.g. top STK or one of the lateral SCDs). The first layer (layer 0) is the farthest one from the calorimeter.

  * [**StkHits**](https://wizard.fi.infn.it/herd/software/doxygen/master/namespaceHerd.html)
Container for the Hits on the strips of a single STK detector (e.g. top STK or one of the lateral STKs). The first layer (layer 0) is the farthest one from the calorimeter. StkHits is an alias for SiliconDetectorHits so far.

  * [**ScdHits**](https://wizard.fi.infn.it/herd/software/doxygen/master/namespaceHerd.html)
Container for the Hits on the strips of a single SCD detector (e.g. top SCD or one of the lateral SCDs). The first layer (layer 0) is the farthest one from the calorimeter. ScdHits is an alias for SiliconDetectorHits so far.

  * [**FitHits**](https://wizard.fi.infn.it/herd/software/doxygen/master/namespaceHerd.html)
Container for the Hits on the SiPMs of a single FIT detector (e.g. top FIT or one of the lateral FITs). The first layer (layer 0) is the farthest one from the calorimeter.

  * [**PsdHits**](https://wizard.fi.infn.it/herd/software/doxygen/master/namespaceHerd.html)
Container for the Hits on the bars or tiles of a single PSD detector (e.g. top PSD or one of the lateral PSDs). For tile PSDs there is just one layer, while for bar PSDs there are two layers, with layer 0 being the farthest one from the calorimeter.

* **Collections of hit containers**
Having more detectors of a given type (e.g. an STK on each of the 5 sides) the data model includes collection of hit containers. Each collection is a [SidesArray](https://wizard.fi.infn.it/herd/software/doxygen/master/classHerd_1_1SidesArray.html) with one hit container per side.

  * [**SiliconDetectorHitsColl**](https://wizard.fi.infn.it/herd/software/doxygen/master/namespaceHerd.html)
A collection of the SiliconDetectorHits for all the sides.

  * [**StkHitsColl**](https://wizard.fi.infn.it/herd/software/doxygen/master/namespaceHerd.html)
A collection of the SiliconDetectorHits for all the sides.

  * [**ScdHitsColl**](https://wizard.fi.infn.it/herd/software/doxygen/master/namespaceHerd.html)
A collection of the SiliconDetectorHits for all the sides.

  * [**FitHitsColl**](https://wizard.fi.infn.it/herd/software/doxygen/master/namespaceHerd.html)
A collection of the FitHits for all the sides.

  * [**PsdHitsColl**](https://wizard.fi.infn.it/herd/software/doxygen/master/namespaceHerd.html)
A collection of the PsdHits for all the sides.

* **Cluster containers and collections**

  * [**CaloClusters**](https://wizard.fi.infn.it/herd/software/doxygen/master/classCaloClusters.html)
Container for the Calo hit clusters.

  * [**SiliconDetectorClusters and SiliconDetectorClustersColl**](https://wizard.fi.infn.it/herd/software/doxygen/master/namespaceHerd.html)
The SiliconDetector Clusters are organized in a cluster container with a layout that is identical to that of hit containers (e.g. one vector of clusters per layer etc.). The SiliconDetectorClusters for each side are placed inside a SiliconDetectorClustersColl.

  * [**StkClusters and StkClustersColl**](https://wizard.fi.infn.it/herd/software/doxygen/master/namespaceHerd.html)
The STK Clusters are organized as the SiliconDetectorClusters. StkClusters and StkClustersColl are aliases for SiliconDetectorClusters and SiliconDetectorClustersColl.

  * [**ScdClusters and ScdClustersColl**](https://wizard.fi.infn.it/herd/software/doxygen/master/namespaceHerd.html)
The SCD Clusters are organized as the SiliconDetectorClusters. ScdClusters and ScdClustersColl are aliases for SiliconDetectorClusters and SiliconDetectorClustersColl.

  * [**FitClusters and FitClustersColl**](https://wizard.fi.infn.it/herd/software/doxygen/master/namespaceHerd.html)
The Fit Clusters are organized in a cluster container with a layout that is identical to that of hit containers (e.g. one vector of clusters per layer etc.). The FitClusters for each side are placed inside a FitClustersColl.

* [**CaloAxis**](https://wizard.fi.infn.it/herd/software/doxygen/master/classHerd_1_1CaloAxis.html)
A Calo track reconstructed by Calo tracking algorithms. The track represents the axis of the shower development. It provides geometrical information on the shower energy development: energy centroid, shower main axes and direction, energy geometrical 3D momenta (sigma, skewness, kurtosis), axis entry and exit point from extreme Calo crystals, pathlength of track inside Calo crystals, lateral and longitudinal energy deposits around the shower axis (with longitudinal and lateral interval customizable by the user).

* [**Track**](https://wizard.fi.infn.it/herd/software/doxygen/master/classHerd_1_1Track.html)
A track is the reconstructed direction of propagation of a particle. It includes a Line encoding the reconstructed direction and a set of the Clusters used to fit the Line.

* [**Track2D**](https://wizard.fi.infn.it/herd/software/doxygen/master/classHerd_1_1Track2D.html)
A track in 2D space. Usually reconstructed by Hits on projective tracking detectors. It includes a Line2D encoding the reconstructed direction and a set of the Clusters used to fit the Line2D.

* **Track containers**

* [**CaloAxes**](https://wizard.fi.infn.it/herd/software/doxygen/master/classCaloAxes.html)
Container for the reconstructed CaloAxis objects.

* [**TrackInfoForCalo**](https://wizard.fi.infn.it/herd/software/doxygen/master/classHerd_1_1TrackInfoForCalo.html)
This object contains information regarding a track and the Calo, e.g. the entrance point, the exit points and the track length.

* [**StkIntersections**](https://wizard.fi.infn.it/herd/software/doxygen/master/classHerd_1_1StkIntersections.html)
This object contains information regarding the intersections between a track and the STK layer. Each intersection is stored inside a STKintersection object, and all the intersections are grouped thogheter inside a vector of STKintersection.

  * [**StkIntersection**](https://wizard.fi.infn.it/herd/software/doxygen/master/classHerd_1_1StkIntersection.html)
This object contains the intersection between a track and a single STK layer, including some additional information, e.g the number of the layer and the detector side.

* [**CaloPDChannelInfo**](https://wizard.fi.infn.it/herd/software/doxygen/master/classHerd_1_1CaloPDChannelInfo.html)
This object contains information regarding the calorimeter channels connected to photdiodes (e.g. the electronic noise, the pdestal value ...). The content of this class should not change event by event, it is meant to be a gloabl object.

* [**CaloPDEventChannelInfo**](https://wizard.fi.infn.it/herd/software/doxygen/master/classHerd_1_1CaloPDEventChannelInfo.html)
This object contains information regarding the calorimeter channels connected to photdiodes (e.g. the gain of the channel, saturation flag). The content of this class could change event by event, it is meant to be an event object. A custom streamer (CaloPDEventChannelInfoStreamer) is used for I/O with ROOT: only channels with information different with respect to the default value are stored inside output files. The latter achieves a reduced file dimension (e.g. information of zero suppressed channels is not stored inside ouput files) while otaining a fast acces to the information inside memory.

# Geometry parameters
These objects carry the information about the geometric configuration of the detector, e.g. the position of calorimeter cubes, the size of the PSD bars or tiles, the number of a given STK ladder. The volume ID (which is stored in Hits) allows to retrieve the geometric information connected to a element, e.g. the position of the center of a hit cube can be retrieved using the volume ID of the Hit and a CaloGeoParmas object. The geometry information of the calorimeter are stored in a single object, while those of the PSD and STK are stored in a object per layer.

* **[CaloGeoParams](https://wizard.fi.infn.it/herd/software/doxygen/master/structHerd_1_1CaloGeoParams.html)**
Geometry parameters for the entire calorimeter: size of a cube, indexes and position of each cube. The indexes can be used to compute the projection of the calorimeter for a given axes, e.g the sum of Hits corresponding to Z index = 0 gives the energy deposit in the top horizontal layer. The following images show the volume ID and the indexes of the cubes of the top horizontal layer (left image) and the Z index for the other horizontal layers (right image). The volume ID of a cube of a given layer is the same of the corresponding cube inside the top layer, summed by 357*LayerNumber, i.e. the volume ID decreases with the Z coordinate while it increases with the Z index (see left image, black and red axes).

<img src="../objects/images/CubeIDTop.jpeg" width="400">
<img src="../objects/images/CubeIDLateral.jpeg" width="400">

* **[PsdGeoParams](https://wizard.fi.infn.it/herd/software/doxygen/master/structHerd_1_1PsdGeoParams.html)**
Geometry parameters for a single layer of the PSD, e.g. the size of the PSD elements (tiles or bars), the number of PSD elements, the position and indexes of each element (see CaloGeoParams for a brief description of the indexes), the normal of the layer and the main and secondary segmentation directions. The volume ID increments by one along the main segmentation direction, e.g. for PSD bars those is the direction orthogonal to the long bar side. The secondary segmentation direction is meaningful only for the tiles and it represents the other direction for which the volume ID increases (by a factor equal to the number of tiles along the main direction). The following images shows the volume ID and the indexes for the top PSD tiles: for this layer the main segmentation direction is Y positive, and the secondary is X positive.

<img src="../objects/images/PsdTopTileID.jpeg" width="400">

The connection between the volume ID and the tile position and indexes for the lateral PSD detectors are shown in the following images: the main segmentation direction is along Z, pointing the bottom of the detector, while the secondary is parallel to X or Y depending on the side, e.g for the X negative side the secondary segmentation direction is y negative, thus the opposite of the Y coordinate axis.

<img src="../objects/images/PsdXnegTileID.jpeg" width="400">  <img src="../objects/images/PsdXposTileID.jpeg" width="400">

<img src="../objects/images/PsdYnegTileID.jpeg" width="400">  <img src="../objects/images/PsdYposTileID.jpeg" width="400">

For a PSD made of bars (which is currently implemented with two layers) the main segmentation direction of the even layers (layer 0 is the external one) is the same of the tile PSD main direction, while the main direction of the odd layers is equal to the secondary direction of the tile PSD. Thus regarding the top bar PSD, the main segmentation direction of the first layer is along X while the one of the second layer is along Y.

* **[SiliconDetectorGeoParams](https://wizard.fi.infn.it/herd/software/doxygen/master/classHerd_1_1SiliconDetectorGeoParams.html)**
Geometry parameters for a single layer of a Silicon detector (e.g. the STK or the SCD), including the size of the wafers, the number of wafers inside each ladder, the number of ladders, the number of strips in each ladder, the normal of the layer, the main and secondary segmentation directions for strips and wafers (or ladder, which are the same with respect to the wafer ones), the strip pitch. The main segmentation direction for strips is the direction along which the volume ID of strips increases by 1 and the main direction for strips is the secondary direction for wafers (and ladders). An example of the wafer, ladder and strip ID in function of the segmentation directions is showed in the following images (the STK is taken as example but the same convntions is valid for all the Silicon detectors). As showed in the images the ID is unambiguous inside the entire layer for both wafers, ladders and strips.

<img src="../objects/images/StkWafer.jpeg" width="400">  <img src="../objects/images/StkStrip.jpeg" width="400">

The segmentation directions of each Silicon detector are summarized in the following table.

| Detector Side | Layer | Main dir. (strip) | Secondary dir. (strip) | Main dir. (ladder) | Secondary dir. (ladder) |
|----------|-------|-------|----------|-------------|-----------|
| Top | even | X pos | Y pos | Y pos | X pos |
| Top | odd | Y pos | X pos | X pos | Y pos |
| Y neg | even | X pos | Z neg | Z neg | X pos |
| Y neg | odd | Z neg | X pos | X pos | Z neg |
| Y pos | even | X neg | Z neg | Z neg | X neg |
| Y pos | odd | Z neg | X neg | X neg | Z neg |
| X neg | even | Y neg | Z neg | Z neg | Y neg |
| X neg | odd | Z neg | Y neg | Y neg | Z neg |
| X pos | even | Y pos | Z neg | Z neg | Y pos |
| X pos | odd | Z neg | Y pos | Y pos | Z neg |


* **[StkGeoParams](https://wizard.fi.infn.it/herd/software/doxygen/master/classStkGeoParams.html)**
Geometry parameters for a single layer of a STK detector, it is an alias for SiliconDetectorGeoParams so far.

* **[ScdGeoParams](https://wizard.fi.infn.it/herd/software/doxygen/master/classScdGeoParams.html)**
Geometry parameters for a single layer of a SCD detector, it is an alias for SiliconDetectorGeoParams so far.

* **[SiliconDetectorChannelGeoInfo](https://wizard.fi.infn.it/herd/software/doxygen/master/classHerd_1_1SiliconDetectorChannelGeoInfo.html)**   
In silicon detectors, not all the strips are read out by the electronics. All the strips have a geometric identifier,
but an identifier for the readout channel can be defined only for the strips that are actually read out. This class manages
the correspondence between the geometric IDs of the strips (the "volume IDs") and the IDs of the readout channels (the
"channel IDs"). Currently it assumes that the strips are read with a given periodicity starting from a given first strip.
For example, if each ladder has 9 strips read out with a period of 3 starting from strip 1 (relative to the ladder) the
volume-channel correspondence for the ladder containing the 9 strips with volume IDs from M*9 to M*9+8 is:

```
                             readout                 readout
                                |                       |
                                |       floating        |
                                |       |       |       |
                                V       V       V       V
                     |--*-------o-------*-------*-------o-------*-------*-------o-------*--|

volume ID (on layer)   M*9    M*9+1   M*9+2   M*9+3   M*9+4   M*9+5   M*9+6   M*9+7   M*9+8
volume ID (on ladder)   0       1       2       3       4       5       6       7       8
channel ID                     M*3                    M*3+1                   M*3+2
```
Note: for the sake of clarity, M is not the ladder ID as would be returned by SiliconDetectorGeoParams::LadderIDFromStripID
since the main segmentation directions for strips and ladders are different.

* **[FitGeoParams](https://wizard.fi.infn.it/herd/software/doxygen/master/classHerd_1_1FitGeoParams.html)**
Geometry parameters for a single layer of the FIT tracker. Includes the number of mats in the layer, how many SiPMs for each mat, how many channels, the normal of the layer, the main and secondary segmentation directions (even if only the main one is actually useful), the channel pitch.
Each SiPM is built up by two die chips, with a small gap in between and a small dead zone at the SiPM edges. Each chip is made out by 64 readout channels with a pitch of 0.25 mm. At the moment the `FitGeoParams` object will try to place as many SiPMs as allowed by the Mat size, adjusting the gap between SiPMs. The other gaps and SiPM parameters are fixed.
The segmentation directions are the same as in the case of Silicon detectors, please refer to the corresponding table.

<img src="../objects/images/FitMat.png" width="800">

* **[CssGeoParams](https://wizard.fi.infn.it/herd/software/doxygen/master/classHerd_1_1CssGeoParams.html)**
Geometry parameters for the Chinese Space Sattion (CSS).

* **Geometry parameters collections**

  * [**SiliconDetectorGeoParamsColl, FitGeoParamsColl and PsdGeoParamsColl**](https://wizard.fi.infn.it/herd/software/doxygen/master/namespaceHerd.html)
The geometry parameter objects for the detectors on each side are stored in a
[SidesArray](https://wizard.fi.infn.it/herd/software/doxygen/master/classHerd_1_1SidesArray.html). Each element of the
collection is a vector containing one geometry parameter object per layer, where the first element represents the farthest
layer from the calorimeter.

  * [**StkGeoParamsColl**](https://wizard.fi.infn.it/herd/software/doxygen/master/namespaceHerd.html)
The geometry parameter objects for the STK detectors on each side are stored in a [SidesArray]. StkGeoParamsColl is an alias
for SiliconDetectorGeoParamsColl.

  * [**ScdGeoParamsColl**](https://wizard.fi.infn.it/herd/software/doxygen/master/namespaceHerd.html)
The geometry parameter objects for the SCD detectors on each side are stored in a [SidesArray]. ScdGeoParamsColl is an
alias for SiliconDetectorGeoParamsColl.

* [**SiliconDetectorChannelGeoInfoColl**](https://wizard.fi.infn.it/herd/software/doxygen/master/namespaceHerd.html)
The channel geometry info objects for the silicon detectors on each side are stored in a
[SidesArray](https://wizard.fi.infn.it/herd/software/doxygen/master/classHerd_1_1SidesArray.html).
Each element of the collection is a vector containing one channel geometry info object per layer, where the first element
represents the farthest layer from the calorimeter.

  * [**StkChannelGeoInfoColl**](https://wizard.fi.infn.it/herd/software/doxygen/master/namespaceHerd.html)
The channel geometry info objects for the STK detectors on each side are stored in a [SidesArray]. StkChannelGeoInfoColl is an
alias for SiliconDetectorChannelGeoInfoColl.

  * [**ScdChannelGeoInfoColl**](https://wizard.fi.infn.it/herd/software/doxygen/master/namespaceHerd.html)
The channel geometry info objects for the SCD detectors on each side are stored in a [SidesArray]. ScdChannelGeoInfoColl is an
alias for SiliconDetectorChannelGeoInfoColl.


# Detector parameters

These objects describe the physical state of a detector in terms of electronic channels and physical response to the passage of particles.

  * [**FitChannelInfo and FitChannelInfoColl**](https://wizard.fi.infn.it/herd/software/doxygen/master/namespaceHerd.html)
The FitChannelInfo describes the state of the various channels of a FIT detector (TOP or on one of the sides). For the moment basic quantities such as pedestals, noise and calibration flags are foreseen and provided.

# Monte Carlo
These data objects describe the information that is only available through Monte Carlo simulations.

* [**ParticleHit**](https://wizard.fi.infn.it/herd/software/doxygen/master/classHerd_1_1ParticleHit.html)
Energy release of a single particle in a given sensitive element; it contains also the PDG code of the particle, its entrance position and momentum in the sensitive volume etc. All the ParticleHit associated to a volume contribute to the Hit of that volume. Please notice that "particle" here refers to any particle involved in the simulation that release energy on a detector, either primaries or secondaries generated by interactions inside the detector.

* **ParticleHit containers and collections**

  * [**SiliconDetectorParticleHits and SiliconDetectorParticleHitsColl**](https://wizard.fi.infn.it/herd/software/doxygen/master/namespaceHerd.html)
The silicon detector particle hit are organized in a SiliconDetectorParticleHitsColl container with a layout that is logically identical to that of hit containers, in the sense that it contains all the particle hits of a single silicon detector (e.g. theone on the top of the instrument) in the same layout. However, the Hit-ParticleHit correspondence is one-to-many, since many ParticleHits can contribute to the same Hit, so ParticleHits has one additional depth level:
```
    SiliconDetectorHits:  vector<vector<Hit>>
                            ^      ^
                            |      |
                            |  one element per hit
                   one element per layer

    SiliconDetectorParticleHits: vector<vector<vector<ParticleHit>
                                   ^      ^      ^
                                   |      |      |
                                   |      |  one element per particle hit
                                   |  one element per hit
                           one element per layer
```
The access to data members follows the above scheme:
```
    stkHits[i][j]  -> j-th hit on i-th layer
    stkParticleHits[i][j][k]  -> k-th particle hit of j-th hit on i-th layer
```
The SiliconDetectorParticleHitsColl contains the five SiliconDetectorParticleHits of the five detectors on each side.

  * [**StkParticleHits and StkParticleHitsColl**](https://wizard.fi.infn.it/herd/software/doxygen/master/namespaceHerd.html)
These objects are alias for SiliconDetectorParticleHits and SiliconDetectorParticleHitsColl respectivly.

  * [**ScdParticleHits and ScdParticleHitsColl**](https://wizard.fi.infn.it/herd/software/doxygen/master/namespaceHerd.html)
These objects are alias for SiliconDetectorParticleHits and SiliconDetectorParticleHitsColl respectivly.

  * [**PsdParticleHits and PsdParticleHitsColl**](https://wizard.fi.infn.it/herd/software/doxygen/master/namespaceHerd.html)
Container and collection of containers for the PSD particle hits, similar to the previous ones.

  * [**FitParticleHits and FitParticleHitsColl**](https://wizard.fi.infn.it/herd/software/doxygen/master/namespaceHerd.html)
Container and collection of containers for the FIT particle hits, similar to the previous ones.

* [**MCInteraction**](https://wizard.fi.infn.it/herd/software/doxygen/master/structHerd_1_1MCInteraction.html)
Information about a Monte Carlo interaction, it is currently used for hadronic interactions and for the primary disappearance. It contains the interaction point, the process name obtained with the simulation and a list of the produced particles (if enabled in the corresponding GGS user action).
  * NB: to enable the output of hadronic interactions in GGS add the following command to the datacard:
    ```
    /GGS/userActions/addGGSHadrIntAction
    ```
  * NB: to enable the output of primary disappearance info in GGS add the following command to the datacard:
    ```
    /GGS/userActions/addGGSPrimaryDisAction
    ```

* [**MCParticle**](https://wizard.fi.infn.it/herd/software/doxygen/master/structHerd_1_1MCParticle.html)
A generic description of a montecarlo particle. It contains information about the particle generation such as the particle PDG code, the initial position and momentum and the time of creation.

* [**MCPrimaryParticle**](https://wizard.fi.infn.it/herd/software/doxygen/master/structHerd_1_1MCPrimaryParticle.html)
A primary particle used to simulate a single Monte Carlo event. It is inherited from `MCParticle`. It contains also information about the first hadronic interaction, quasi-elastic hadronic interactions and primary disappearance. Please check for the presence of interaction information with the dedicated methods before accessing it.

* [**MCTruth**](https://wizard.fi.infn.it/herd/software/doxygen/master/structHerd_1_1MCTruth.html)
The set of Monte Carlo information about one Monte Carlo event. Currently it consists only of a vector of MCPrimaryParticles.

* [**MCGenerationInfo**](https://wizard.fi.infn.it/herd/software/doxygen/master/classHerd_1_1MCGenerationInfo.html)
Information about the generation of primary particles (spectrum, position, direction, acceptance check etc.).

# Trigger entities

They are mainly containers that include the information needed at the different steps of the trigger logic. This information can be physical quantities (inputs) from each subdetector, bitmasks as a result of the comparison of the previous quantities with thresholds, and booleans corresponding to the trigger pattern of an event. Additionally, geometric regions needed for trigger evaluation are also defined.
* [**CaloPMTTriggerInputs**](https://wizard.fi.infn.it/herd/software/doxygen/master/classHerd_1_1CaloPMTTriggerInputs.html)
Contains information about the energy deposition in Calo, in particular, the total energy deposited and the energy deposited in each trigger region.

* [**CaloPMTTriggerFlags**](https://wizard.fi.infn.it/herd/software/doxygen/master/classHerd_1_1CaloPMTTriggerFlags.html)
Contains a bitmask as a result of the comparison of the CaloPMTTriggerInputs with given thresholds, with bits associated to the total energy deposition in Calo for the HE trigger, and energy deposition in the shell trigger regions for the UNB and LEG triggers

* [**PsdTriggerInputs**](https://wizard.fi.infn.it/herd/software/doxygen/master/classHerd_1_1PsdTriggerInputs.html)
Contains information about the energy deposition in the top and lateral sides of the Psd.

* [**PsdTriggerFlags**](https://wizard.fi.infn.it/herd/software/doxygen/master/classHerd_1_1PsdTriggerFlags.html)
Contains a bitmask as a result of the comparison of the PsdTriggerInputs with a given thresholds, to assess if there is Psd veto or not (none of the sides has energy deposited above the threshold).

* [**TriggerPattern**](https://wizard.fi.infn.it/herd/software/doxygen/master/classHerd_1_1TriggerPattern.html)
Contains the list with the fired triggers for each event. Each Boolean of the list is filled by a dedicated trigger algorithm that effectively implements the trigger logic using the trigger flags.

# List of objects

Using the classes of the data model, providers and algorithms produce several objects. Each object has a unambiguous name but similar objects can be retrieved from a data store using a common "alias" (see [EventAnalysis](https://wizard.fi.infn.it/eventanalysis) for description of alias). The same alias can be connected to several objects which represent the same information provided with different configurations, e.g. the hits of the simulated PSD have the same alias even if those hits are read-out from GGS files, or if those are provided by a digitization algorithm. If the user is not interested in a specific object, the alias allows to retrieve information about a given categories, otherwise the true name of the object should be used. 

Some details of the data model objects are summarized in the tables and brief descriptions of the latter are visualized when the mouse cursor is placed above the object name.

## **CALO**

| Object name | Category |Class | Alias | Producer |
|----------|-------|-------|-------|----------|
| <abbr title="Container for the collection of CaloAxis objects">caloAxes</abbr>| EVENT | [CaloAxes](https://wizard.fi.infn.it/herd/software/doxygen/master/classCaloAxes.html) | |[PcaCaloAxisTrackingAlgo](Algorithms.md#tracking-algorithms) |
|  <abbr title="Container for the collection of Calo hit clusters">caloClusters</abbr> | EVENT | [CaloClusters](https://wizard.fi.infn.it/herd/software/doxygen/master/classCaloClusters.html) | | [CaloDBSCANClustering](Algorithms.md#clustering-algorithms) |
| <abbr title="Calorimeter hits extracted from GGS files">caloHitsGGS</abbr> | EVENT |[CaloHits](https://wizard.fi.infn.it/herd/software/doxygen/master/namespaceHerd.html) | caloHitsMC | [GGSDataProvider](Data-providers.md) |
| <abbr title="Calorimeter hits obtained by the calo digitizer and related to the large photodiodes">caloLPDHitsMCDigitADC</abbr> | EVENT | [CaloHits](https://wizard.fi.infn.it/herd/software/doxygen/master/namespaceHerd.html) | caloLPDHitsADC | [CaloPDDigitizerAlgo](Algorithms.md#digitization-algorithms) |
| <abbr title="Calorimeter hits obtained by the calo digitizer and related to the small photodiodes">caloSPDHitsMCDigitADC</abbr> | EVENT | [CaloHits](https://wizard.fi.infn.it/herd/software/doxygen/master/namespaceHerd.html) | caloSPDHitsADC | [CaloPDDigitizerAlgo](Algorithms.md#digitization-algorithms) |
| <abbr title="Calorimeter hits obtained by the calo zero suppresion and related to the large photodiodes">caloLPDHitsMCDigitZeroSupADC</abbr> | EVENT | [CaloHits](https://wizard.fi.infn.it/herd/software/doxygen/master/namespaceHerd.html) | caloLPDHitsADC | [CaloPDZeroSuppressionAlgo](Algorithms.md#digitization-algorithms) |
| <abbr title="Calorimeter hits obtained by the calo zero suppresion and related to the small photodiodes">caloSLPDHitsMCDigitZeroSupADC</abbr> | EVENT | [CaloHits](https://wizard.fi.infn.it/herd/software/doxygen/master/namespaceHerd.html) | caloSPDHitsADC | [CaloPDZeroSuppressionAlgo](Algorithms.md#digitization-algorithms) |
| <abbr title="Calorimeter hits obtained by converting the calo digitized LPD hits from ADC to GeV">caloLPDHitsMCDigitGeV</abbr> | EVENT | [CaloHits](https://wizard.fi.infn.it/herd/software/doxygen/master/namespaceHerd.html) | caloLPDHitsGeV | [CaloPDCalibrationAlgo](Algorithms.md#digitization-algorithms) |
| <abbr title="Calorimeter hits obtained by converting the calo digitized SPD hits from ADC to GeV">caloSPDHitsMCDigitGeV</abbr> | EVENT | [CaloHits](https://wizard.fi.infn.it/herd/software/doxygen/master/namespaceHerd.html) | caloSPDHitsGeV | [CaloPDCalibrationAlgo](Algorithms.md#digitization-algorithms) |
| <abbr title="Calorimeter hits obtained by converting the calo digitized PD hits from ADC to GeV, the SPD signal is used when the LPD is saturated">caloHitsMCDigitGeV</abbr> | EVENT | [CaloHits](https://wizard.fi.infn.it/herd/software/doxygen/master/namespaceHerd.html) | caloHitsGeV | [CaloPDCalibrationAlgo](Algorithms.md#digitization-algorithms) |
| <abbr title="Information related to channels connected to large photodiodes">caloLPDEventChannelInfoMCDigitADC</abbr> | EVENT | [CaloPDEventChannelInfo](https://wizard.fi.infn.it/herd/software/doxygen/master/classHerd_1_1CaloPDEventChannelInfo.html) | caloLPDEventChannelInfo | [CaloPDDigitizerAlgo](Algorithms.md#digitization-algorithms) | 
| <abbr title="Information related to channels connected to small photodiodes">caloSPDEventChannelInfoMCDigitADC</abbr> | EVENT | [CaloPDEventChannelInfo](https://wizard.fi.infn.it/herd/software/doxygen/master/classHerd_1_1CaloPDEventChannelInfo.html) | caloSPDEventChannelInfo | [CaloPDDigitizerAlgo](Algorithms.md#digitization-algorithms) |
| <abbr title="Information related to channels connected to large photodiodes, obtained after zero suppression">caloLPDEventChannelInfoZeroSup</abbr> | EVENT | [CaloPDEventChannelInfo](https://wizard.fi.infn.it/herd/software/doxygen/master/classHerd_1_1CaloPDEventChannelInfo.html) | caloLPDEventChannelInfo | [CaloPDCalibrationAlgo](Algorithms.md#digitization-algorithms) | 
| <abbr title="Information related to channels connected to small photodiodes, obtained after zero suppression">caloSPDEventChannelInfoZeroSup</abbr> | EVENT | [CaloPDEventChannelInfo](https://wizard.fi.infn.it/herd/software/doxygen/master/classHerd_1_1CaloPDEventChannelInfo.html) | caloSPDEventChannelInfo | [CaloPDCalibrationAlgo](Algorithms.md#digitization-algorithms) | 
| <abbr title="Information of the geometry of the calorimeter implemented in GGS simulation">caloGeoParamsGGS</abbr> | GLOBAL |[CaloGeoParams](https://wizard.fi.infn.it/herd/software/doxygen/master/structHerd_1_1CaloGeoParams.html) | caloGeoParams | [GGSDataProvider](Data-providers.md) | 
| <abbr title="Information related to channels connected to large PD obtained by the calo digitizer">caloLPDChannelInfoMC</abbr> | GLOBAL | [CaloPDChannelInfo](https://wizard.fi.infn.it/herd/software/doxygen/master/classHerd_1_1CaloPDChannelInfo.html) | caloLPDChannelInfo | [CaloPDChannelInfoAlgo](Algorithms.md#digitization-algorithms) |
| <abbr title="Information related to channels connected to small PD obtained by the calo digitizer">caloSPDChannelInfoMC</abbr> | GLOBAL | [CaloPDChannelInfo](https://wizard.fi.infn.it/herd/software/doxygen/master/classHerd_1_1CaloPDChannelInfo.html) | caloSPDChannelInfo | [CaloPDChannelInfoAlgo](Algorithms.md#digitization-algorithms) |

## **PSD**
| Object name | Category |Class | Alias | Producer |
|----------|-------|-------|-------|----------|
| <abbr title="PSD hits extracted from GGS files">psdHitsCollGGS</abbr> | EVENT |[PsdHitsColl](https://wizard.fi.infn.it/herd/software/doxygen/master/namespaceHerd.html) | psdHitsCollMC | [GGSDataProvider](Data-providers.md) |
| <abbr title="PSD particle hits extracted from GGS files">psdParticleHitsCollGGS</abbr> | EVENT | [PsdParticleHitsColl](https://wizard.fi.infn.it/herd/software/doxygen/master/namespaceHerd.html) | psdParticleHitsCollMC | [GGSDataProvider](Data-providers.md) |
| <abbr title="PSD hits computed by summing the energy deposit in two or more nearby PSD elements">psdHitsCollAggregated</abbr> | EVENT |[PsdHitsColl](https://wizard.fi.infn.it/herd/software/doxygen/master/namespaceHerd.html) | psdHitsCollMC | [PsdGeometricDigitizerAlgo](Algorithms.md#digitization-algorithms) |
| <abbr title="PSD particle hits on aggregated PSD elements">psdParticleHitsCollAggregated</abbr> | EVENT |[PsdParticleHitsColl](https://wizard.fi.infn.it/herd/software/doxygen/master/namespaceHerd.html) | psdParticleHitsCollMC | [PsdGeometricDigitizerAlgo](Algorithms.md#digitization-algorithms) |
| <abbr title="Information about the geometry of the PSD used in the GGS simulation">psdGeoParamsCollGGS</abbr> | GLOBAL |[PsdGeoParamsColl](https://wizard.fi.infn.it/herd/software/doxygen/master/namespaceHerd.html) | psdGeoParamsColl | [GGSDataProvider](Data-providers.md) |
| <abbr title="Information about the geometry of the PSD after the aggregation of MC PSD elements">psdGeoParamsCollAggregated</abbr>  | GLOBAL |[PsdGeoParamsColl](https://wizard.fi.infn.it/herd/software/doxygen/master/namespaceHerd.html) | psdGeoParamsColl | psdGeoParamsColl | [PsdGeometricDigitizerAlgo](Algorithms.md#digitization-algorithms) |

## **FIT**

| Object name | Category |Class | Alias | Producer |
|----------|-------|-------|-------|----------|
| <abbr title="FIT hits extracted from GGS files">fitHitsCollGGS</abbr> | EVENT | [FitHitsColl](https://wizard.fi.infn.it/herd/software/doxygen/master/namespaceHerd.html) | fitHitsCollMC | [GGSDataProvider](Data-providers.md) |
| <abbr title="FIT particle hits extracted from GGS files">fitParticleHitsCollGGS</abbr> | EVENT | [FitParticleHitsColl](https://wizard.fi.infn.it/herd/software/doxygen/master/namespaceHerd.html) | fitParticleHitsCollMC | [GGSDataProvider](Data-providers.md) |
| <abbr title="FIT hits which have been digitized (ADC)">fitDigHitsCollMC</abbr> | EVENT | [FitHitsColl](https://wizard.fi.infn.it/herd/software/doxygen/master/namespaceHerd.html) | fitHitsCollADC | [FitDigitizerAlgo](Algorithms.md#digitization-algorithms) |
| <abbr title="Clusters of FIT hits (ADC)">fitClustersCollADC</abbr> | EVENT | [FitClustersColl](https://wizard.fi.infn.it/herd/software/doxygen/master/namespaceHerd.html) | | [FitClusteringAlgo](Algorithms.md#clustering-algorithms)|
| <abbr title="Information about the geometry of the FIT used in the GGS simulation">fitGeoParamsCollGGS</abbr> | GLOBAL |[FitGeoParamsColl](https://wizard.fi.infn.it/herd/software/doxygen/master/namespaceHerd.html) | fitGeoParamsColl | [GGSDataProvider](Data-providers.md) |
| <abbr title="Information about the geometry of the FIT after the digitization step">fitDigitizedGeoParamsColl</abbr> | GLOBAL |[FitGeoParamsColl](https://wizard.fi.infn.it/herd/software/doxygen/master/namespaceHerd.html) | fitGeoParamsColl | [FitDigitizerAlgo](Algorithms.md#digitization-algorithms) |
| <abbr title="Information about the channels of the FIT after the digitization step">fitDigitizedChannelInfoColl</abbr> | GLOBAL |[FitChannelInfoColl](https://wizard.fi.infn.it/herd/software/doxygen/master/namespaceHerd.html) | fitChannelInfoColl | [FitDigitizerAlgo](Algorithms.md#digitization-algorithms) |

## **STK**

| Object name | Category |Class | Alias | Producer |
|----------|-------|-------|-------|----------|
| <abbr title="STK hits in wafers extracted from GGS files">stkWaferHitsCollGGS</abbr> | EVENT |[StkHitsColl](https://wizard.fi.infn.it/herd/software/doxygen/master/namespaceHerd.html) | stkWaferHitsCollMC | -[GGSDataProvider](Data-providers.md)
| <abbr title="STK particle hits on wafers extracted from GGS files">stkWaferParticleHitsCollGGS</abbr> | EVENT |[StkParticleHitsColl](https://wizard.fi.infn.it/herd/software/doxygen/master/namespaceHerd.html) | stkWaferParticleHitsCollMC | [GGSDataProvider](Data-providers.md)
| <abbr title="STK hits on strips reconstructed from particle hits on wafers with a purely geometric criterion">stkGeomDigHitsCollMC</abbr> | EVENT | [StkHitsColl](https://wizard.fi.infn.it/herd/software/doxygen/master/namespaceHerd.html) | stkHitsCollMC | [StkGeometricDigitizerAlgo](Algorithms.md#digitization-algorithms)
| <abbr title="STK hits on strips reconstructed from particle hits on wafers with charge drift diffusion">stkDriftDiffHitsCollMC</abbr> | EVENT | [StkHitsColl](https://wizard.fi.infn.it/herd/software/doxygen/master/namespaceHerd.html) | stkHitsCollMC | [StkDriftDiffusionAlgo](Algorithms.md#digitization-algorithms)
| <abbr title="STK hits on readout strips from from hits on implanted strips">stkCapNetHitsCollMC</abbr> | EVENT | [StkHitsColl](https://wizard.fi.infn.it/herd/software/doxygen/master/namespaceHerd.html) | stkHitsCollMC | [StkCapacitiveNetAlgo](Algorithms.md#digitization-algorithms)
| <abbr title="STK hits on strips extracted from GGS files">stkStripHitsCollGGS</abbr> | EVENT |[StkHitsColl](https://wizard.fi.infn.it/herd/software/doxygen/master/namespaceHerd.html) | stkHitsCollMC | -[GGSDataProvider](Data-providers)-or-[StkGeometricDigitizerAlgo](Algorithms.md#digitization-algorithms) |
| <abbr title="STK hits of the strips after the bonding of different wafers">stkBondedHitsCollMC</abbr> | EVENT |[StkHitsColl](https://wizard.fi.infn.it/herd/software/doxygen/master/namespaceHerd.html) | stkHitsCollMC | [StkBondingDigitizerAlgo](Algorithms.md#digitization-algorithms) |
| <abbr title="STK clusters of strip hits">stkClustersCollMC</abbr> | EVENT | [StkClustersColl](https://wizard.fi.infn.it/herd/software/doxygen/master/namespaceHerd.html) |  | [StkClusteringAlgo](Algorithms.md#clustering-algorithms)|
| <abbr title="Information about the geometry of the STK used in the GGS simulation when the strips are not simulated (default-configuration).">stkGeoParamsCollGGS</abbr> | GLOBAL |[StkGeoParamsColl](https://wizard.fi.infn.it/herd/software/doxygen/master/namespaceHerd.html) | stkGeoParamsColl | [GGSDataProvider](Data-providers.md) |
| <abbr title="Information about the geometry of the STK with strips; it describes geometry used in the GGS simulation when the strips are simulated, or the STK obtained with the digitization algorithm">stkGeoParamsCollWaferStrip</abbr> | GLOBAL |[StkGeoParamsColl](https://wizard.fi.infn.it/herd/software/doxygen/master/namespaceHerd.html) | stkGeoParamsColl | [GGSDataProvider](Data-providers)-or-[StkGeometricDigitizerAlgo](Algorithms.md#digitization-algorithms) |
| <abbr title="Information about the geometry of the STK with strips; it describes the geometry of the STK strips resulting from the application of the drift/diffusion algorithm">stkGeoParamsDriftDiffColl</abbr> | GLOBAL |[StkGeoParamsColl](https://wizard.fi.infn.it/herd/software/doxygen/master/namespaceHerd.html) | stkGeoParamsColl | -[StkDriftDiffusionAlgo](Algorithms.md#digitization-algorithms) |
| <abbr title="Information about the geometry of the STK after the bonding of different wafers">stkGeoParamsBondedStripColl</abbr> | GLOBAL | [StkGeoParamsColl](https://wizard.fi.infn.it/herd/software/doxygen/master/namespaceHerd.html) | stkGeoParamsColl | [StkBondingDigitizerAlgo](Algorithms.md#digitization-algorithms) |
| <abbr title="Information about the geometry of the STK readout strips">stkChannelGeoInfoCapNetColl</abbr> | GLOBAL | [StkChannelGeoInfoColl](https://wizard.fi.infn.it/herd/software/doxygen/master/namespaceHerd.html) | stkChannelGeoInfoColl |[StkCapacitiveNetAlgo](Algorithms.md#digitization-algorithms) |

## **SCD**

| Object name | Category |Class | Alias | Producer |
|----------|-------|-------|-------|----------|
| <abbr title="SCD hits in wafers extracted from GGS files">scdWaferHitsCollGGS</abbr> | EVENT |[ScdHitsColl](https://wizard.fi.infn.it/herd/software/doxygen/master/namespaceHerd.html) | scdWaferHitsCollMC | -[GGSDataProvider](Data-providers.md)
| <abbr title="SCD particle hits on wafers extracted from GGS files">scdWaferParticleHitsCollGGS</abbr> | EVENT |[ScdParticleHitsColl](https://wizard.fi.infn.it/herd/software/doxygen/master/namespaceHerd.html) | scdWaferParticleHitsCollMC | [GGSDataProvider](Data-providers.md)
| <abbr title="SCD hits on strips reconstructed from particle hits on wafers with a purely geometric criterion">scdGeomDigHitsCollMC</abbr> | EVENT | [ScdHitsColl](https://wizard.fi.infn.it/herd/software/doxygen/master/namespaceHerd.html) | scdHitsCollMC | [ScdGeometricDigitizerAlgo](Algorithms.md#digitization-algorithms)
| <abbr title="SCD hits on strips reconstructed from particle hits on wafers with charge drift diffusion">scdDriftDiffHitsCollMC</abbr> | EVENT | [ScdHitsColl](https://wizard.fi.infn.it/herd/software/doxygen/master/namespaceHerd.html) | scdHitsCollMC | [ScdDriftDiffusionAlgo](Algorithms.md#digitization-algorithms)
| <abbr title="SCD hits on readout strips from from hits on implanted strips">scdCapNetHitsCollMC</abbr> | EVENT | [ScdHitsColl](https://wizard.fi.infn.it/herd/software/doxygen/master/namespaceHerd.html) | scdHitsCollMC | [ScdCapacitiveNetAlgo](Algorithms.md#digitization-algorithms)
| <abbr title="SCD hits on strips extracted from GGS files">scdStripHitsCollGGS</abbr> | EVENT |[ScdHitsColl](https://wizard.fi.infn.it/herd/software/doxygen/master/namespaceHerd.html) | scdHitsCollMC | -[GGSDataProvider](Data-providers)-or-[ScdGeometricDigitizerAlgo](Algorithms.md#digitization-algorithms) |
| <abbr title="SCD hits of the strips after the bonding of different wafers">scdBondedHitsCollMC</abbr> | EVENT |[ScdHitsColl](https://wizard.fi.infn.it/herd/software/doxygen/master/namespaceHerd.html) | scdHitsCollMC | [ScdBondingDigitizerAlgo](Algorithms.md#digitization-algorithms) |
| <abbr title="SCD clusters of strip hits">scdClustersCollMC</abbr> | EVENT | [ScdClustersColl](https://wizard.fi.infn.it/herd/software/doxygen/master/namespaceHerd.html) |  | [ScdClusteringAlgo](Algorithms.md#clustering-algorithms)|
| <abbr title="Information about the geometry of the SCD used in the GGS simulation when the strips are not simulated (default-configuration).">scdGeoParamsCollGGS</abbr> | GLOBAL |[ScdGeoParamsColl](https://wizard.fi.infn.it/herd/software/doxygen/master/namespaceHerd.html) | scdGeoParamsColl | [GGSDataProvider](Data-providers.md) |
| <abbr title="Information about the geometry of the SCD with strips; it describes geometry used in the GGS simulation when the strips are simulated, or the SCD obtained with the digitization algorithm">scdGeoParamsCollWaferStrip</abbr> | GLOBAL |[ScdGeoParamsColl](https://wizard.fi.infn.it/herd/software/doxygen/master/namespaceHerd.html) | scdGeoParamsColl | [GGSDataProvider](Data-providers)-or-[ScdGeometricDigitizerAlgo](Algorithms.md#digitization-algorithms.md) |
| <abbr title="Information about the geometry of the SCD with strips; it describes the geometry of the STK strips resulting from the application of the drift/diffusion algorithm">scdGeoParamsDriftDiffColl</abbr> | GLOBAL |[ScdGeoParamsColl](https://wizard.fi.infn.it/herd/software/doxygen/master/namespaceHerd.html) | scdGeoParamsColl | [ScdDriftDiffusionAlgo](Algorithms.md#digitization-algorithms) |
| <abbr title="Information about the geometry of the SCD after the bonding of different wafers">scdGeoParamsBondedStripColl</abbr> | GLOBAL | [ScdGeoParamsColl](https://wizard.fi.infn.it/herd/software/doxygen/master/namespaceHerd.html) | scdGeoParamsColl | [ScdBondingDigitizerAlgo](Algorithms.md#digitization-algorithms) |
| <abbr title="Information about the geometry of the SCD readout strips">scdChannelGeoInfoCapNetColl</abbr> | GLOBAL | [ScdChannelGeoInfoColl](https://wizard.fi.infn.it/herd/software/doxygen/master/namespaceHerd.html) | scdChannelGeoInfoColl | [ScdCapacitiveNetAlgo](Algorithms.md#digitization-algorithms) |

## **CSS**

| Object name | Category |Class | Alias | Producer |
|-------------|----------|------|-------|----------|
| <abbr title="Information about the geometry of the Chinese Space Station">cssGeoParamsGGS</abbr> | GLOBAL |[CssGeoParams](https://wizard.fi.infn.it/herd/software/doxygen/master/classHerd_1_1CssGeoParams.html) | cssGeoParams | [GGSDataProvider](Data-providers.md)|

## **Monte Carlo**

| Object name | Category |Class | Alias | Producer |
|----------|-------|-------|-------|----------|  
| <abbr title="Information about the generated primary particle extracted from MC files">mcTruth</abbr> | EVENT |[MCTruth](https://wizard.fi.infn.it/herd/software/doxygen/master/structHerd_1_1MCTruth.html) |  | [GGSDataProvider](Data-providers.md)|  
| <abbr title="Information about the parameters of the generation of primary particles">mcGenerationInfo</abbr> | GLOBAL | [MCGenerationInfo](https://wizard.fi.infn.it/herd/software/doxygen/master/classHerd_1_1MCGenerationInfo.html) |  | [GGSDataProvider](Data-providers.md)|  
| <abbr title="Information about the true MC track inside the Calo">trackInfoForCaloMC</abbr> | EVENT |[TrackInfoForCalo](https://wizard.fi.infn.it/herd/software/doxygen/master/classHerd_1_1TrackInfoForCalo.html) |  | [CaloTrackInfoAlgo](Algorithms.md#geometric-algorithms)|
| <abbr title="Information about the true MC track intersections with the STK">stkIntersectionsMC</abbr> | EVENT | [StkIntersections](https://wizard.fi.infn.it/herd/software/doxygen/master/classHerd_1_1StkIntersections.html)|  | [StkIntersectionsAlgo](Algorithms.md#geometric-algorithms)|

## **Reconstruction**

| Object name | Category |Class | Alias | Producer |
|----------|-------|-------|-------|----------|
| <abbr title="The 2D projections of a track found by the Hough transform tracking algorithm">HoughTracks{XZ,YZ,XY}</abbr> | EVENT | std::vector\<[Track2D](https://wizard.fi.infn.it/herd/software/doxygen/master/classHerd_1_1Track2D.html)\> | | [HoughFinder2DAlgo](Algorithms.md#tracking-algorithms)

## **Trigger**

| Object name | Category |Class | Alias | Producer |
|-------------|----------|------|-------|----------|
| <abbr title="Trigger inputs for the PMT trigger system of CALO">caloPMTTriggerInputs</abbr> | EVENT | [CaloPMTTriggerInputs](https://wizard.fi.infn.it/herd/software/doxygen/master/classHerd_1_1CaloPMTTriggerInputs.html) | | [CaloPMTTriggerComputerAlgo](Algorithms.md#trigger-algorithms)
| <abbr title="Trigger flags for the PMT trigger system of CALO">caloPMTTriggerFlags</abbr> | EVENT | [CaloPMTTriggerFlags](https://wizard.fi.infn.it/herd/software/doxygen/master/classHerd_1_1CaloPMTTriggerFlags.html) | | [CaloPMTTriggerComparatorAlgo](Algorithms.md#trigger-algorithms)
| <abbr title="Trigger inputs for the trigger system of PSD">psdTriggerInputs</abbr> | EVENT | [PsdTriggerInputs](https://wizard.fi.infn.it/herd/software/doxygen/master/classHerd_1_1PsdTriggerInputs.html) | | [PsdTriggerComputerAlgo](Algorithms.md#trigger-algorithms)
| <abbr title="Trigger flags for the trigger system of PSD">psdTriggerFlags</abbr> | EVENT | [PsdTriggerFlags](https://wizard.fi.infn.it/herd/software/doxygen/master/classHerd_1_1PsdTriggerFlags.html) | | [PsdTriggerComparatorAlgo](Algorithms.md#trigger-algorithms)
| <abbr title="Fired trigger patterns">triggerPattern</abbr> | EVENT | [TriggerPattern](https://wizard.fi.infn.it/herd/software/doxygen/master/classHerd_1_1TriggerPattern.html) | | [HighEnergyTriggerCut, LowEnergyGammaTriggerCut, UnbiasedTriggerCut](Algorithms.md#trigger-algorithms)
