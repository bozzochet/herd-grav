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

As explained in the [introduction](Introduction.md), HerdSoftware is conceived as an EventAnalysis project. The code in algorithms, data providers and persistence services is compiled and organized in different libraries. These can be viewed as "baskets" containing the basic building blocks of an analysis job; these building blocks however must be properly put together and configured in order to define what the analysis should do, and then be run on the data. To this end, we currently rely on the analysis configuration system and the analysis executable provided by EventAnalysis.

# Configure the analysis
The sequence of algorithms constituting an analysis job, as well as the data providers that provide initial data and persistence services which saves the analysis products, is defined by means of an EventAnalysis configuration file. Roughly speaking, this is a text file containing a list of the algorithms to be run plus their initialization parameters, the data sources (e.g. files) where to read initial data from, the output files and the list of objects to be saved on them etc. The syntax of this kind of file is described in the [EventAnalysis manual](https://wizard.fi.infn.it/eventanalysis/manual), so please refer to it for an introduction and a description of the syntax. Here we discuss briefly a small example of a configuration file referring to HerdSoftware components:
```
Plugin HerdDataProviders
Plugin HerdAlgorithms
Plugin HerdPersistenceServices
Plugin HerdDataObjectsDict

DataProvider GGSDataProvider ggsDataProvider /path/to/GGSOutputFile.root
  AttachToStore   evStore    event
  AttachToStore   globStore  global

Persistence HerdRootPersistenceService rootPersistence /path/to/outputFile.root
  Book stkHits      event  evStore
  Book stkGeoParams global globStore

EventLoop  0 1000
  Algo StkGeometricDigitizerAlgo stkGeomDig
    Set pitch 0.0150
  Algo StkClusteringAlgo stkClust
    Set snThreshold 4
    Set snSeed 7
```
Let's examine the above file step by step:
* The first four lines define which plugin libraries should be used. These are fundamental definitions since in order to run an algorithm (or use a data provider or a persistence service) its code must be first loaded. The user should load in this way all the libraries in which the analysis entities that are to be used are spread over. In the example we first load the two libraries containing the [Herd data providers](Data-providers.md) and the [Herd algorithms](Algorithms.md). Then we load the RootPersistence plugin, which contains a generic persistence service for writing objects in Root files provided by EventAnalysis; in order to write the data objects to the output Root file their dictionaries are also needed, so we load the library containing them in the fourth line.
* The following line creates a data provider of class [GGSDataProvider](Data-providers.md#providers), called ggsDataProvider. This is the provider reading Monte Carlo data from GGS output files; in this case the input file is `/path/to/GGSOutputFile.root`. The next two lines define the data stores where the provider puts the data objects it creates. These data stores are called "evStore" and "globStore"; these names match those of the stores to which Herd algorithms ask for data objects (see the C++ code of some algorithm), so attaching the provider to these store ensures that the provided objects are correctly retrieved by the algorithms.
* Then the persistence service which will write the output file is created. Here we use an object of class [HerdRootPersistenceService](https://wizard.fi.infn.it/herd/software/doxygen/master/classHerd_1_1HerdRootPersistenceService.html) and named rootPersistence, which will write its output data to `/path/to/outputFile.root`. HerdRootPersistenceService is a generic persistence provided by HerdSoftware which can write any data object with a dictionary on a Root file. Being generic it has to be instructed about which data objects must be saved; here we book for saving the event object called stkHits from evStore event data store and the global object called stkGeoParams from the globStore global data store. For more details about the format of the output file created by HerdRootPersistenceService please refer to the [EventAnalysis manual](https://wizard.fi.infn.it/eventanalysis/manual/), since HerdRootPersistenceService is a class derived from the [RootPersistenceService](https://wizard.fi.infn.it/eventanalysis/doxygen/master/classEA_1_1RootPersistenceService.html) class provided by eventAnalysis, and they use the same data format.
* Next, an event loop is created; in this case the loop runs over 1000 events starting from event 0, thus the processed events will range from 0 to 999 included. Two algorithms process the data inside the loop: the first one is a [StkGeometricDigitizerAlgo](Algorithms.md#digitization-algorithms) called stkGeomDig, while the second one is a [StkClusteringAlgo](Algorithms.md#clustering-algorithms) called stkClust. The digitization algorithm is configured to digitize the Monte Carlo hits on STK assuming a pitch of 150 micron, while the clustering algorithms will search for clusters assuming a signal-to-noise ratio equal to 7 for the seed strip and equal to 4 for the neighbouring strips. It is important to notice that the clustering is done after the digitization: indeed, the clustering needs the hits on silicon strips, while the GGS data provider provides hits and particle hits on the silicon wafer; the digitizer is the algorithm that starting from particle hits on wafers produces the hits on the strips, so it must run before the clustering.

The [doxygen documentation](https://wizard.fi.infn.it/herd/software/doxygen) of each algorithm, data provider and persistence service includes a list of the needed and produced objects; when adding an algorithm to the sequence make sure that a data provider or a preceding algorithm provides the data objects required by the algorithm.

# Run the analysis 
Once the configuration file has been created, it can be used to configure an analysis job run by the EventAnalysis executable. This executable is part of the EventAnalysis package; given a configuration file, it loads the plugin libraries, creates the event loop, algorithms etc. and then runs the analysis job. The only required operation before launching it is to specify in which folders the plugin libraries are stored. This is done by properly setting the `EA_PLUGIN_PATH` environment variable; the HerdSoftware plugin libraries are all created inside the `plugin` subfolder of the build folder so that the variable can be set e.g. in a bash shell with simply:
```bash
export EA_PLUGIN_PATH=/path/to/HerdSoftware/build/plugin:$EA_PLUGIN_PATH
```
Additional folders can be specified if necessary by separating them with semicolons `:`. This operation must be repeated every time a new shell is opened, or alternatively it has to be added to the .bashrc file.

Once the plugin folders have been set the analysis job can be launched with the command:
```bash
EventAnalysis -c /path/to/configFile.txt
```
More detailed usage instructions for the EventAnalysis executable can be found in the [EventAnalysis manual](https://wizard.fi.infn.it/eventanalysis/manual).
