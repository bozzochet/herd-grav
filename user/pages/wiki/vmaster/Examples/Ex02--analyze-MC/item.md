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

## Example 2: analysis of digitized Monte Carlo files
**Folder:** Ex02_analyze-mc  
In this example an output file is read and new algorithms are created and used.

Included files:

**Subfolder:** EventAnalysisJob
* **CaloEDepCut.{h,cpp}**
  Source files for the CALO analysis algorithms based on EventAnalysis.
* **StkNHitsCut.{h,cpp}**  
  Source files for the STK analysis algorithms based on EventAnalysis.
* **CaloEDepHisto.{h,cpp}**  
  Algorithm that plots the total energy deposit in the CALO
* **CaloPDDigitADCEDepHisto.{h,cpp}**
  Algorithm that creates histograms of the total energy deposit in the calorimeter using large and small photo-diode digitized and zero suppressed hits in ADC unit. It also counts the number of saturated and low gain channels.
* **CaloPDDigitGeVEDepHisto.{h,cpp}**
  Algorithm that creates histograms of the total energy deposit in the calorimeter using large and small photo-diode digitized and zero suppressed hits in GeV unit.
* **StkPrimaryHitsAlgo.{h,cpp}** 
  Algorithm that searches for STK hits around the MC truth initial trajectory
* **StkStripEDepHisto.{h,cpp}** 
  Algorithm that plots single strip energy deposits for top STK
* **CMakeLists.txt**  
  Build file for the EventAnalysis algorithms.
* **analyzeMC.eaconf**  
  Configuration file for the analysis job based on EventAnalysis.
  
**Subfolder:** RootScript
* **analysis.C**  
  Root macro for Root-style analysis.
  
### Description
In this example a very simple custom analysis is built and run. The output file produced in Ex01 is analyzed to produce histograms 
of the total energy deposit in the calorimeter and of the energy deposit in single strips of the top STK as well as the energy deposit of STK hits close to the MC truth trajectory; the CALO plot is produced 
also for a subset of selected events by means of a very simple selection cut. The analysis is implemented both as a Root script and
as an EventAnalysis job. The first approach is commonly understood, and has the main purpose of displaying how to directly read data
from an output file produced by an EventAnalysis job (the one in Ex01, in this case) that uses the HerdRootPersistenceService.

The second approach shows a more structured analysis implementation, which in this simple case turns out to be excessively involved
with respect to the simple Root script, but that should scale better for more complicated analysis cases. It also has the advantage
of encompassing the code in a common framework (thus facilitating the understanding from other people) and also to ease code reusage
(the algorithm classes could be easily used again in different analyses, notice infact how the finding of "primary" hits has to be reimplemented by hand in the root macro approach).

#### The Root script
The Root script is a very simple one and should be self-documenting. There are just a couple of details to be underlined:

1. The script reads the Herd data objects that are written in the Root file, so the corresponding dictionaries must be loaded. The
dictionaries are located in the Herdsoftware install or build folder, inside the `plugin` subfolder, in the `libHerdDataObjects.so`
(or `.dylib` on OSX systems) library. The user must load this dictionary library before loading the script file in the Root shell.


2. As implied by 1., the Herd data objects are streamed to the Root file by the HerdRootPersistenceService preserving the class layout,
and furthermore using the name of the object on the data store for writing the object on file. The hits of the calorimeter in the Herd
data model are encoded in an object of class `CaloHits`, which is put in the event data store with the name `caloHits`. This is
reflected in the Root file by a branch of the event tree named `caloHits` containing an object of class `CaloHits`. All the saved
event objects have their own branch in the event tree and can be retrieved in the same way. Saved global objects instead do not
reside in branches but directly in the root level of the Root file, as can be easily senn from a quick inspection of the Root file;
they can be retrieved in the usual way (i.e. `file->Get("objectName")`).

#### The EventAnalysis job 
The implementation of the analysis as an EventAnalysis job produces the same output of the Root script but is more complex. It consists
of the following algorithms:
* **StkPrimaryHitsAlgo**: an algorithm that looks for STK hits close to the MC truth trajectory, below a given distance threshold  
* **CaloEDepCut**: a filter algorithm that rejects those events whose energy deposit in the calorimeter is below a given threshold  
* **StkNHitsCut**: a filter algorithm that rejects those events whose have a total number of hits in the top silicon tracker above a given threshold 
* **CaloEDepHisto**: an algorithm that creates a histogram of the total energy deposit in the calorimeter
* **CaloPDDigitADCEDepHisto**: an algorithm that creates histograms of the total energy deposit in the calorimeter using large and small photo-diode digitized and zero suppressed hits in ADC unit. It also counts the number of saturated and low gain channels.
* **CaloPDDigitGeVEDepHisto**: an algorithm that creates histograms of the total energy deposit in the calorimeter using large and small photo-diode digitized and zero suppressed hits in GeV unit.
* **StkStripEDepHisto**: an algorithm that creates a histogram of the energy deposits in single strips of the top silicon tracker

The configuration file defines the algorithm sequence and the I/O of the job, similarly to Ex01 since this example and Ex01 are both EventAnalysis jobs. 

##### Saving data for selected events
By default, a persistence service saves the booked event objects at the end of event processing, no matter if the event does not pass a cut algorithm. To save
only those events surviving the selection done by cut algorithms, a `PersistenceAlgo` can be used. `PersistenceAlgo` is an algorithm (and as such it can be
placed inside the event loop and the sequences therein) that wraps a `PersistenceService` to save data objects as they are in the data stores at the moment the
`PersistenceAlgo` is processed. If the `PersistenceAlgo` is placed after a cut algorithm that rejects the event then it is not executed, so the event ojbects
are not saved for that event.

In the configuration file, a `PersistenceAlgo` for saving events selected by the `CaloEDepCut` is created at line 51. The following line sets the wrapped
persistence service to `eventPersistence` (which is defined at line 18; see below for more details), and the subsequent line sets the name of the output file to
`electrons_10GeV_sphere.analyzed.caloSelected.root`. Another `PersistenceAlgo` for saving data for events selected by `StkNHitsCut` is created and
configured at line 62 and subsequent. Notice the usage of the same persistence service and the different name of the output file: this means that the two
`PersistenceAlgo`s will save the same set of objects (i.e. the ones booked for `eventPersistence`) on different output files for the two different sets of
selected events.

The `eventPersistence` defined at line 18 is a usual `HerdRootPersistenceService`, for which some objects are booked; these are the objects that will be
saved by the two `PersistenceAlgo`s wrapping `eventPersistence`. Notice that the persistence is defined as a `PersistenceTemplate`, rather than a
`Persistence` like `rootPersistence` (line 10). A persistence template works only when wrapped inside a `PersistenceAlgo`: it will not save event data at the
end of event processing regardless of cuts as a standard persistence would do.

##### How to build the code 
The code  must be compiled and put in a plugin library that can then be loaded during an EventAnalysis job. The build is
configured by the `CMakeLists.txt` file as an external project making use of the HerdSoftware (and EventAnalysis and Root) libraries,
and is an example of how personal code can be developed outside HerdSoftware. Indeed, the Ex02 folder content can be viewed as a
prototype of what a personal analysis project could look like, and there is no necessity that such projects are located in some
subfolder of HerdSoftware (although in this case, being an example, it is convenient to ship it with HerdSoftware).

As a regular CMake-configured project it can be built by following the usual procedure:
1. create a build folder and enter it
2. run cmake, eventually specifying the location of the packages the project depends on
3. run make  

The example project depends on EventAnalysis, HerdSoftware and Root (see the `find_package` directives in `CMakeLists.txt`); the Root and EventAnalysis packages are automatically discovered in a properly configured environment, so just the location of HerdSoftware must be specified in the cmake invocation by passing he folder containing the `HerdSoftwareConfig.cmake` to cmake. This file can be found in the build tree and/or in the cmake/ subfolder of the install tree, so the former can be used to configure the build of Ex02 by menas of:
```bash
$ mkdir build; cd build
$ cmake -DHerdSoftware_DIR=/path/to/HerdSoftwareBuildDir/ ../
$ make -j
```
while for using the install tree:

```bash
$ mkdir build; cd build
$ cmake -DHerdSoftware_DIR=/path/to/HerdSoftwareInstallDir/cmake ../
$ make -j
```
Both cases should work the same, so it's just a matter of personal taste at this stage.

-**Additional info**: Currently EventAnalysis and HerdSoftware follow two different approaches. EventAnalysis is compiled and installed by the Installer script: this means that its cmake configuration file is inside the `cmake/` subfolder of the EventAnalysis installation folder. We also set the `PATH` environment variable to the folder containing the EventAnalysis executable; this makes CMake able to automatically find EventAnalysis when we configure the build of a project depending on it.
For HerdSoftware we either:
1. just compile it, and use it from the build folder, which is also the location of its cmake configuration file.
2. compile and install like EventAnalysis, but unlike EventAnalysis we don't set PATH for the HerdSoftware installation, so CMake is not able to automatically find it.  

The bottom line is: you should set `-DHerdSoftware_DIR=` to the folder containing the `HerdSoftwareConfig.cmake` file.


The compilation will produce a plugin library called `libEx02.so` (or `.dylib`) containing the algorithms. These can be used in an EventAnalysis
job by means of two steps:
1. Load the plugin library containing their compiled code
2. Create the algorithms at the proper stages of the analysis job.

These steps are specified in the job configuration file `analyzeMC.eaconf`. At line 3 the plugin library is loaded; note how only the
library name is specified and not the full path. To let EventAnalysis find the library file is therefore necessary to add the library
folder to the `EA_PLUGIN_PATH` environment variable:

```bash
$ export EA_PLUGIN_PATH=/path/to/HerdSoftware/examples/Ex02_analyze-mc/EventAnalysisJob/build:$EA_PLUGIN_PATH  
```

This kind of setting must be repeated for all the folders containing the custom plugin libraries that will be used in the analysis.

The custom algorithms are then used in the event loop in two different, independent algorithm sequences. The first one contains only the
histogram algorithms, and then it will produce histograms for all the events. The second sequence contains the cut algorithm before the
histogram one, so the histogram will be produced only for those events accepted by the cut.  

Apart from custom algorithms, here are some other noticeable points about the content of `analyzeMC.eaconf`:

1. Data is read from the input file with a HerdRootDataProvider named `rootProvider`. This is the provider that reads data files
created by HerdRootPersistenceService, and it basically brings back to the data stores the data objects that were put into the Root file by
the HerdRootPersistenceService. The net effect is that the algorithms of this job see the exact data store content that was present at the end
of the job of Ex01. In fact, the algorithms could be appended to the ones of Ex01 in the Ex01 job configuration file, to run both the
analyses in one shot without the need of an intermediate file (the digitized file).
2. The "primary" hits are collected by the `StkPrimaryHitsAlgo` algorithm and published on the event store for usage by subsequent algorithms.  
3. The input file is the output file of Ex01, and is specified in the configuration file as `electrons_10GeV_sphere.dig.root`. Since
no path is specified the file will be searched in the current working directory, so it will not be found since it is in the Ex01 folder.
The user can either specify the full path in the configuration file or modify the path on the fly with a command line parameter (see below).
4. Each histogram algorithms produce Root histograms.
5. The cut algorithms, `caloEDepCut` and `stkNHitsCut` are used to apply some selections before filling a secondo version of the histograms above, `caloHistoSel` and `stkStripHistoSel`.
6. The histograms must be booked for being written on the output file by the HerdRootPersistenceService;
wildcards are accepted in order to make it easier to book many objects, e.g. booking `caloHisto*` will save all the histograms produced by the `CaloEDepHisto` algorithm. 

The analysis job can be launched with:

```bash
$ EventAnalysis -c  analyzeMC.eaconf -d rootProvider,/path/to/HerdSoftware/examples/Ex01_digitize-mc/electrons_10GeV_sphere.dig.root
```

Notice how the data source string associated to the provider named `rootProvider` can be modified when launching the job using the `-d`
command line option; see 2. above. This will not modify the content of the configuration file. If more providers were present then their data
source strings could be modified in the same way by means of one `-d` parameter per provider, each time replacing `rootProvider` with the
name of the provider. A similar way of changing the name of output files for persistence services is given by the `-o` flag. See
`EventAnalysis -h` for more details.
   
