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

The initial data objects for the analysis are provided by data providers. These classes read information form a persistence medium like a file on a disk or a database and create the data objects that will be manipulated by the algorithms.

Below a brief description of the available data providers is given, together with the name of the plugin library that contains them. For a more detailed description please see the [doxygen documentation](https://wizard.fi.infn.it/herd/software/doxygen).

# **Library**: libHerdDataProviders

# **Providers**
* [**GGSDataProvider**](https://wizard.fi.infn.it/herd/software/doxygen/master/classHerd_1_1GGSDataProvider.html)  
This data provider reads data from Monte Carlo simulated files created with GGS using the parametric Herd geometry. It provides hits and geometry parameters for all the subdetectors, and the Monte Carlo truth of each event. For the STK and SCD, it provides either Hits and PArticleHits for the Si wafers or Hits for the Si strips, depending on whether the Si strips have been activated or not in the MC geometry.

* [**HerdRootDataProvider**](https://wizard.fi.infn.it/herd/software/doxygen/master/classHerd_1_1HerdRootDataProvider.html)  
This data provider reads data from output files created by the [HerdRootPersistenceService](Persistence-services.md) used in analysis jobs. It is used for those jobs that take as input data the output of a previous job. It is a generic data provider, meaning that it can read files containing any number of data objects.   

* [**HerdRootDataProviderV0**](https://wizard.fi.infn.it/herd/software/doxygen/master/classHerd_1_1HerdRootDataProviderV0.html)  
This data provider reads old data files created by the HerdRootPersistenceService in legacy HerdSoftware versions which used EventAnalysis < 1.2.0. It provides backwards compatibility for reading old Root files with the current HerdSoftware version.
