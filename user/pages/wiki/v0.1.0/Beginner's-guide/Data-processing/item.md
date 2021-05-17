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

# Overview
From the point of view of a collaboration working on a physics experiment, the data 
processing procedures and infrastructure should have several desirable feature. A 
few examples:

- people should be able to run on their own computer a reconstruction/analysis produced 
  by others
- any portion of the reconstruction/analysis should be easily replaceable with an 
  equivalent one, to e.g. compare the performance of two different implementations 
  of the same task
- it should be easy to add new data processing procedures without breaking existing 
  code
- it should be easy to play with the code and experiment new solutions without interfering 
  with each other's work

The computer code must be carefully designed and implemented in order to achieve 
these features. The EventAnalysis package has been designed to comply with these 
requirements. It allows for defining data processing algorithms that can be combined 
in a pipeline (i.e. a set of algorithms that are executed sequentially) to define 
a data processing job; each algorithm processes some data objects and produces other 
data objects that will be eventually processed by other algorithms down in the pipeline. 
All the data processing in HerdSoftware is implemented as EventAnalysis processing 
pipelines, and the processing procedures as EventAnalysis algorithms

The HerdSoftware pipelines can read Monte Carlo output files produced by running 
the Herd detector simulation with GGS. Data objects are built from the information 
in the Monte Carlo files, and used to feed the algorithms in the processing pipelines. 
The objects produced by the algorithms (but in general also those produced by reading 
the Monte Carlo files) can be written to an output file at the end of the pipeline. 
the user can choose which data objects are to be saved. The saved file can in turn 
be used as input file for another pipeline whose algorithms processes the objects 
saved in the file, and a new output file can be produced, and so on. The file I/O 
is managed in a completely automated way, and thus the user implementing a new algorithm 
doesn't have to care about opening a file, reading information from it or save the 
produced output.

Should you need more information about how the EventAnalysis (and thus the HerdSoftware)
data processing works, please refer to the
[EventAnalysis user's guide](https://wizard.fi.infn.it/eventanalysis/manual/EAUsersGuide-master.pdf.md),
especially to sect. 2.1 where an overview of the framework is given.

# Modularity
All the HerdSoftware data processing components (algorithms, data objects etc.)
described below are modular: they are mostly independent of each other, and new
components can be added and used together with the existing ones without 
modifying the latter. These new components can also be defined in C++ code
files that are not placed inside HerdSoftware: the libraries obtained by
compiling these "external projects" can then be used together with HerdSoftware
ones to allow for using both the "official" components (i.e. those defined in
HerdSoftware) and the custom ones (those defined in the external library) in
the same analysis project.

Later we will see in details how this works in practice.

# The HerdSoftware data model
Algorithms operate on data. HerdSoftware algorithms are C++ classes, and they
operate on data encoded as C++ objects. An algorithm can ask the framework
(i.e. EventAnalysis) for a data object by specifying its name and class,
process it, produce a new data object and pass it to the framework in order
to make it available for other algorithms. The set of data objects, each one
identified by name and class, constitute the so-called HerdSoftware data model.
In order to write a data processing algorithm it is usually necessary to
understand on which of the data objects it should operate. The standard
HerdSoftware data model is described in [this wiki page](User's-manual/Data-model.md).
A noticeable feature of the data model is that, contrary to other frameworks
that you might be familiar with, there's no `Event` object. The data describing
an event (hits, tracks etc.) is split among various data objects, and the
user must retrieve and use each object separately. This has some advantages
from a technical point of view (e.g. it is very easy to add new event data
since there's no `Event` C++ class to be modified).
For each data object there is a concise description and the indication of which
algorithm produces it. It is a good idea to familiarize a bit with the data
model before going on. Later we'll see how to use the data objects inside an
algorithm.

The HerdSoftware data model provides a set of common, foundation data objects
for reconstruction and data analysis. When creating new algorithms it is common
to create also new data objects to describe the output (and possibly also the
input) of these new algorithms. To be used, these new data objects does not
necessarily need to be incorporated in HerdSoftware if they are not general
enough or not intended to be used by everybody.

# Data stores
Up to now, we simply stated that "algorithms ask the framework for the data
objects they need, and then pass the objects they produce to the framework".
To be more precise, the entities of the EventAnalysis framework that deals with
giving and receiving objects to and from algorithms are called data stores.
Data stores are of two kinds: those storing event objects (i.e. those data
objects that describe the event properties like the hits in a detector, the
track etc.) and those storing global objects (i.e. objects that are not
strictly related to a single event like histograms, the details of the detector
geometry etc.). Each data store is identified by a name; HerdSoftare currently
uses an event data store called `evStore` and a global data store called
`globStore` for storing the two categories of objects (event and global) needed
or produced by its algorithms.

Algorithms have access to data stores through an entity called the data store
manager. To see in practice how it works, refer to one of the HerdSoftware
algorithms, e.g. `src/analysis/clustering/CaloDBSCANClustering.cpp`. In the
implementation of the `CaloDBSCANClustering::Initialize()` method you can see
at line 37 how to retrieve a pointer to the event store: first, a pointer to
the data store manager is retrieved, and then it is asked for an event data
store called `evStore`. Below, you can see at line 57 hot to get the
calorimeter hits from the store, and further down at line 67 how to add to the
store the newly created object with the found showers. 

# Algorithms and pipelines
Once algorithms have been defined, they have to be combined to form a full
analysis processing, or pipeline. This concept is better understood with an
example.

Suppose that you have to implement and characterize a tracking procedure: you
need to find the track, compute the chi2, select those tracks with good chi2
and on this sample compute the resolution. You can do this in one single
HerdSoftware algorithm which is quite handy; however, if your tracking is good
then you have to prune all the other functionalities (track selection etc.)
from your algorithm before eventually integrating it in the mainline 
HerdSoftware code. Also, the chi2 selection might be useful for other purposes
than this simple study, e.g. to select events with a good track for flux
computation. One way to maximize the profit of writing this code is to break it
into different, independent algorithms:
  
1. a tracking algorithm which creates a `Track` object;  
2. a selection algorithm that operates on the `Track` objects, computes the chi2 and flags the
   event as discarded if the chi2 is too high;  
3. an algorithm which computes the angle between the reconstructed and the
   Monte Carlo track and fills a histogram, and that at the end of processing
   computes and prints the angular resolution;  
   
which perform the above operations for each event.
   
For the tracking resolution studies, the three algorithms can be pipelined 
(i.e. sequentially executed) in the obvious way: 1, then 2 and then 3 (which
will be executed only if 2 does not flag the event as discarded; the framework
will take care of ensuring this conditional execution), so it's not better than
doing everything with one single algorithm. But now the tracking algorithm can
also be re-used in another study that requires a track (for example, in the
study of the electron/proton rejection power), and also the chi2 selection can
be re-used where needed, without re-executing the resolution evaluation
algorithm. It is sufficient to create a pipeline by specifying only the desired
algorithms.

Pipelines are specified in a job configuration file. This is shown e.g. in 
[example 01](Examples/Ex01:-digitize-MC.md), where a job for digitizing a Monte
Carlo file is configured in the `digitizeMC.eaconf` configuration file. In the
`EventLoop` section a pipeline of three algorithms is specified:
`StkGeometricDigitizerAlgo`, `ScdGeometricDigitizerAlgo` and then
`PsdGeometricDigitizerAlgo`. These are algorithms provided by HerdSoftware;
their C++ code is compiled inside a library called `HerdAlgorithms` which is
loaded by the `Plugin` instruction on line 2. If one wants to run also the
clustering of the STK strip hits then it is sufficient to add an 
`StkClusteringAlgo` to the algorithm sequence. Notice that this has to be
placed in the sequence after `StkGeometricDigitizerAlgo`: as it can be seen
from [its doxygen documentation](https://wizard.fi.infn.it/herd/software/doxygen/master/classHerd_1_1StkClusteringAlgo.html)
it needs a data object called `stkHitsColl` (i.e. the container of the hits in
the STK strips), which is produced by the `StkGeometricDigitizerAlgo` as stated
in the [list of data model objects](User's-manual/Data-model.md#list-of-objects).

It is then clear that for assembling a pipeline it is necessary to understand
which objects are needed and produced by the algorithms. This is documented in
the doxygen documentation of each algorithm; the [algorithms wiki page](User's-manual/Algorithms.md)
provides for each algorithm in HerdSoftware a concise description and the link
to the doxygen documentation.

This mechanism of configuring the data processing by first loading the library
which contains the algorithms' code and then creating a pipeline with the
desired algorithms works also when algorithms are scattered through different
libraries: it is sufficient to load all the needed ones by using `Plugin`
multiple time, and after this all the algorithms in these libraries can be used
to assemble the pipeline. This mechanism works also for libraries created in
external projects, making it possible to mix HerdSoftware algorithms and
external algorithms in the same processing pipeline, if needed. 
  

# Input and output
HerdSoftware algorithms process data objects to produce new ones that can
possibly be processed by other algorithms at a later stage in the pipeline. The
initial data objects to be processed are provided by entities called data 
providers. A data provider produces objects not by processing other objects
(like an algorithm does) but rather creating them from information stored in
a file, a database, and so on. As a trivial example, assume you have an
algorithm that fits a histogram: this algorithm requires the histogram object 
to operate on. Now suppose that this histogram is stored in a Root file: you
can create a data provider which opens the file, reads out the histogram from
the file and pass it to the framework (or more precisely, it puts the histogram
on a data store), to make it available to the algorithm.
The latter can completely ignore where the histogram comes from (it simply asks
for it to the framework, no matter how the framework got it), so that all the
logic related to the input from file (set file name, see if it exists, open
file, close it at the end of input etc.) is delegated to the data provider.
In this way, separate tasks (i.e. reading a file and processing the information
it contains) are assigned to different and independent entities (i.e. the data
provider and the algorithm), with benefits in term of code clearness (you
exactly know where to look at if you get an error related to opening the file)
and reusability (the data provider can be reused in every pipeline whose
algorithms need the histogram).

In this trivial example the data object is put on the data store exactly as it
is, but typically the data in the file can be stored in a different format than
that needed from the algorithms. In this case the data provider should perform
some kind of format conversion. For example, the algorithm operates on a Root
histogram, so this is the kind of object that needs to be placed in the data
store. Suppose that the content of the bins is not stored in a Root file as a
Root histogram, but rather on a text file: in this case another data provider
might be created, that reads the content of the bins from the text file, builds
a Root histogram and pass it to the data store. Notice that this mechanism
allows the algorithm to operate on histogram data stored in Root files or text
files seamlessly, by using the appropriate provider for each kind of data file.

Like algorithms, also data providers are created using the configuration file.
Still referring to the `digitizeMC.eaconf` file of the [example 01](Examples/Ex01:-digitize-MC.md),
you can see that a data provider of class `GGSDataProvider` and named
`ggsDataProvider` is created for reading the simulation output file named
`electrons_10GeV_sphere.root`. This provider is then attached to the `evStore`
and the `globStore`, so that it will put the objects it provides on those
stores, from which the algorithms will get them. You can get a full list of
data providers implemented in HerdSoftware in the [data providers wiki page](User's-manual/Data-providers.md#list-of-objects). 

The dual entity of a data provider is a persistence service, which takes care
of output. A persistence service retrieves objects from data stores and saves
them in files or databases or any other persistence medium. Like data
providers, persistence services might need to perform some transformation on
the data objects to transform them in the output format. Pursuing the text-file
histogram example, a persistence service could retrieve a Root histogram from
a data store and save the contents of its bins to a text file. Also persistence
services are created using the configuration file.

## The Root data provider and persistence service
Writing data providers and persistence services might be tedious, and possibly
require a considerable fraction of time especially when dealing with small
analyses. For this reason, HerdSoftware provides general-purpose data provider
and persistence service based on Root. The Root persistence service can write
on file every data object (both event and global) that has a Root dictionary.
The Root data provider can read any object from a file written by the Root
persistence service. They can handle any number of objects of any class.

These two entities are used extensively in HerdSoftware for managing the I/O. 
All the processing jobs write output files using the Root persistence service,
and all the other processing jobs that needs these files as input files read
them with the Root data provider. The only jobs that need a special data
provider are those processing the Root files produced by the Monte Carlo
simulation, since even if they are Root files they are not written in a format
that is understood by the Root data provider. These jobs should use the 
`GGSDataProvider`; look at the configuration file of [example 01](Examples/Ex01:-digitize-MC.md):
this job digitizes the hits of a Monte Carlo file, and you can see that it uses
a `GGSDataProvider` for reading the input file and a `HerdRootPersistenceService`
for writing the output file. Notice also how the objects to be saved are
specified by the `Book` instructions. Now, look at the [example 02](Examples/Ex02:-analyze-MC.md):
this is a simple processing of the digitized file produced by example 01. The
output file of example 01 is read by the job `analyzeMC.eaconf` using a
`HerdRootDataProvider`, and the output (some histograms) is written using the
`HerdRootPersistenceService`. The objects in this output file could in turn be used
as input for another job by reading them again with `HerdRootDataProvider`, and so
on. In this way it is possible to create different data processing stages,
each one taking as input the output of the previous stage, without having to
deal with file formats, I/O routines etc.  
 
# Additional information
Further information about how to configure and launch a data processing job are
available in [this wiki page](User's-manual/Run-an-analysis.md).

The concepts and mechanisms described above are intrinsic of the EventAnalysis
framework. You don't need to understand every EventAnalysis detail to be able 
to work with HerdSoftware, but should you need any further information then
please refer to the [EventAnalysis documentation](https://wizard.fi.infn.it/eventanalysis.md).

