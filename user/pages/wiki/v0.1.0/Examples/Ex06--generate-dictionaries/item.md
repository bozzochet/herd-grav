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

## Example 6: dictionary generation for custom data classes
**Folder:** Ex06_generate-dictionaries  
In this example an output file is read and data is filled into a custom class and then written to disk.

Included files:
* **ScdPrimaryHitsAlgo.{h,cpp}** 
  Algorithm that searches for SCD hits around the MC truth initial trajectory
* **MyScdHit.{h,cpp}** 
  Custom class to hold EDep and position of SCD hits
* **CMakeLists.txt**  
  Build file for the EventAnalysis algorithms.
* **analyzeMC.eaconf**  
  Configuration file for the analysis job based on EventAnalysis.
  
  
### Description
In this example a very simple custom analysis is built and run, derived from Ex02. The output file produced in Ex01 is analyzed to save a reduced set of hits using a custom Hit class. This has the main purpose of displaying how to use custom classes in the analysis step and generate their own dictionary so that they can be stored on file using the HerdRootPersistenceService.

It consists of a single algorithm:
* **ScdPrimaryHitsAlgo**: an algorithm that looks for SCD hits close to the MC truth trajectory, below a given distance threshold  
and a custom class:
* **MyScdHit**: a class that stores the Edep and position of a single SCD hit.

These classes must be compiled and put in a plugin library and a shared library that can then be loaded during an EventAnalysis job. The build is
configured by the `CMakeLists.txt` file as an external project making use of the HerdSoftware (and EventAnalysis and Root) libraries,
and is an example of how personal code can be developed outside HerdSoftware. Indeed, this is very close to what you can see in the Ex02.

As a regular CMake-configured project it can be built by following the usual procedure:
1. create a build folder and enter it
2. run cmake, eventually specifying the location of the packages the project depends on
3. run make  

The example project depends on EventAnalysis, HerdSoftware and Root (see the `find_package` directives in `CMakeLists.txt`); the
Root package is automatically discovered in a properly configured environment, so the above described build procedure could look like:

```bash
$ mkdir build; cd build
$ cmake -DHerdSoftware_DIR=/path/to/HerdSoftwareInstallDir/cmake -DEventAnalysis_DIR=/path/to/EventAnalysisInstallDir/cmake/ ../
$ make -j
```

This will produce a plugin library called `libEx06.so` (or `.dylib`) containing the algorithm and a library called `libMyScdHit.so` (or `.dylib`) containing the definition and dictionary for the `MyScdHit` class. These can be used in an EventAnalysis
job by means of two steps:
1. Load the plugin library containing their compiled code
2. Create the algorithms at the proper stages of the analysis job.

These steps are specified in the job configuration file `analyzeMC.eaconf`. 
Please refer to the Ex02 documentation for further details. To let EventAnalysis find the library file is therefore necessary to add the library
folder to the `EA_PLUGIN_PATH` environment variable:

```bash
$ export EA_PLUGIN_PATH=/path/to/HerdSoftware/examples/Ex02_analyze-mc/EventAnalysisJob/build:$EA_PLUGIN_PATH  
```

This kind of setting must be repeated for all the folders containing the custom plugin libraries that will be used in the analysis.

The `analyzeMC.eaconf` file is just a stripped down version of the one in Ex02. It schedules the custom algorithm that will select the interesting SCD hits, fill a `std::vector<MyScdHit>` object and then publish it on the event data store.

The analysis job can be launched with:

```bash
$ EventAnalysis -c  analyzeMC.eaconf -d rootProvider,/path/to/HerdSoftware/examples/Ex01_digitize-mc/electrons_10GeV_sphere.dig.root
```

just as in the Ex02.   
