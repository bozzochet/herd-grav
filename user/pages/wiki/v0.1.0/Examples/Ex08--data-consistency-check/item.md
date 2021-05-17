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

## Example 8: checking the consistency of the data model

In this example it is shown how to enable the data consistency check and what happens when inconsistencies are found.

Included files:
* **stkTracking.eaconf**  
  Configuration file for the tracking job
  
### Description
This example shows how the data consistency check works. This feature allows for a check of the available objects before the job is actually started, in order to help
understanding if there are missing objects and thus missing providers or algorithms in the processing pipeline. To showcase this feature, the track reconstruction
starting from STK Monte Carlo data is assumed as the working case. The `tracking.eaconf` configuration file sets up a track reconstruction pipeline using the Hough
finder algorithm. This algorithm operates on clusters, which are built of single strips; the latters are not present in the MC simulation, but are reconstructed in
offline analysis by the geometric digitizer algorithm. So the pipeline looks like:

1. Geometric digitizer
2. Clusterization
3. Hough finder

1 creates strip hits from MC data, 2 creates clusters from strips and 3 find tracks looking for aligned clusters. If 1 or 2 is missing due to e.g. an error in writing
the configuration file, some data object will be missing and thus an error will be generated during the execution of the pipeline. Also, if 3 is missing then the track
objects booked to be saved by the persistence will not be present, so another error will be raised.
 
It is possible to check in advance for missing data objects along the pipeline, by setting the `checkDataAvailability` property of the event loop; when set to `true`
(line 18 of the configuration file), the event loop will perfom a data availability check before starting the pipeline, aborting the run with an error message if some
needed object is missing.

In the configuration file, algorithms 1 and 2 are commented out, so that only 3 is executed. Thus an error about missing clusters will be printed out:

```
[SequenceDataChecker::Check]     ERROR     Event data object "stkClustersCollMC" from store "evStore" needed by algorithm "houghTracking" in sequence "Main sequence" is not available.

```

Furtehrmore, a non-existing global object called `nonExistingObject` is booked for persistence; this results in:

```
[SequenceDataChecker::Check]     ERROR     Global data object "nonExistingObject" from store "globStore" needed by persistence "rootPersistence" is not available at the end of sequence "Main sequence".
```

By commenting out the booking of the non-existing global object and uncommenting the creation of the algorithms that produce the needed objects the tracking job can be
run without errors.


 

