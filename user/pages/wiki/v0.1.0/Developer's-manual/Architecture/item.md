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

**Guideline**: know the framework before starting to develop
* Know the architecture of GGS and EventAnalysis
* Know how HerdSoftware is structured
* Understand how the CMake configuration is implemented
* Understand what the code build will produce

---

HerdSoftware code is divided in two parts: one relative to the analysis and reconstruction procedures, and the other to the Monte Carlo simulation of the instrument. In order to reduce the development burden and to impose a clear structure to the code (to facilitate understanding it) the package is based on two "foundation" frameworks:
* EventAnalysis  ([code](https://baltig.infn.it/mori/EventAnalysis/)-[manual](https://wizard.fi.infn.it/eventanalysis/manual/)-[doxygen](https://wizard.fi.infn.it/eventanalysis/doxygen/))
* GGS ([code](https://baltig.infn.it/mori/GGSSoftware/)-[manual](https://wizard.fi.infn.it/ggs/manual/)-[doxygen](https://wizard.fi.infn.it/ggs/doxygen/))

The HerdSoftware developers are expected to be familiar with these frameworks, at least partially (i.e. read at least the introduction of the two manuals before going on...)

# General architectural overview
HerdSoftware is developed as an external project for GGS and EventAnalysis. It codes its entities (algorithms, geometries, particle generators etc.) as C++ classes derived from base classes defined in GGS and EventAnalysis. The code architecture, or in other words the class hierarchy and the mutual relationships between these classes, is then the one defined by the two frameworks. Check the frameworks documentation and the HerdSoftware [user's manual](User's-manual/Table-of-contents.md) for a detailed description.

# Code structure
The C++ code consists of headers and source files, placed in `include` and `src` subfolders of the HerdSoftware root folder, respectively:
```
  - include
  - src
```
Each folder contains subfolders for analysis and simulation code:
```
  - include
    - analysis
    - simulation
  - src
    - analysis
    - simulation
```
In turn, every class category has its own subfolder:
```
  - include
    - analysis
      - algorithms
      - common
      - dataobjects
      - dataproviders
    - simulation
      - generators
      - geometry
  - src
    - analysis
      - algorithms
      - common
      - dataobjects
      - dataproviders
    - simulation
      - generators
      - geometry
```
Other sub-folders might be present when a further code classification is useful:
```
  - include
    - analysis
      - algorithms
        - clustering
        - digitization
        - display
        - tracking
      - common
      - dataobjects
      - dataproviders
    - simulation
      - generators
      - geometry
        - parametric
  - src
    - analysis
      - algorithms
        - clustering
        - digitization
        - display
        - tracking
      - common
      - dataobjects
      - dataproviders
    - simulation
      - generators
      - geometry
        - parametric
```
When developing a new class, its header and source files should be placed in the appropriate folders; create a new one when the new class do not belong to any existing category.

## Include directives
The build system sets the `include/` subfolder of HerdSoftware as the include folder when invoking the compiler. This means that the relative path of included files must be specified in the preprocessor directive; for example:
```c++
#include "analysis/common/RefFrame.h"
```
In order for these relative paths to be still valid for external projects using the HerdSoftware headers from the install folder, the headers are installed replicating the structure of the `include/` folder in the install folder.

# CMake files
The build is configured with CMake. The `CMakeLists.txt` files are scattered through the code folders, with the principle that each file should configure the build only for the content of its own folder. This makes it easier to find where the compilation of a given source file is configured (i.e. in the `CMakeLists.txt` in the same folder) and keeps the size of the `CMakeLists.txt` to a manageable size. In some cases this is not feasible/convenient, so a slightly different approach is used. For example, the source files algorithm classes are in subfolders of `src/analysis/algorithms/`: in each subfolder there is a `CMakeLists.txt` which appends the name of the files to a list, and the files in the list are compiled according to the `CMakeLists.txt` in `src/analysis/algorithms/`. 

When adding new code, remember to modify the relative `CMakeLists.txt` accordingly. By design, the CMake files of HerdSoftware do NOT automatically discover and compile the new cpp files, since it's considered a [bad practice](https://stackoverflow.com/questions/1027247/is-it-better-to-specify-source-files-with-glob-or-each-file-individually-in-cmak); each new file has to be manually added to the list of source files in the appropriate `CMakeLists.txt`.


# Data objects
The data objects constitute the entities that are manipulated by the algorithm classes in an EventAnalysis job. They encode physical quantities related to the instrument measurements (e.g. energy deposits), reconstructed observables (i.e. tracks) and ancillary information (e.g. geometry parameters).

Each data object consists of a type and a name: for example, if two tracking algorithms are used then they could both produce an object of class (type) `Track`, but use different names (naively, "trackFromAlgo1" and "trackFromAlgo2") to identify each track object. The set of data objects constitute the data model of the experiment.

Data types are defined by headers in `analysis/dataobjects/`; the guideline is to use one header per class, with the same name as the class. Data object types can be of any kind, including basic built-in types like `int`, and it's not required for them to inherit from a common base class.

The names of the data objects are defined by the entities (algorithms and data providers) that push them to the data stores; to avoid having to go through the code to find the names of the data objects, developers are required to provide a description of the data objects in the doxygen documentation of the entities that produce them. See for example the [doxygen page for GGSDataProvider](https://wizard.fi.infn.it/herd/software/doxygen/master/classHerd_1_1GGSDataProvider.html).

## Root persistence
Currently, the output mechanism of HerdSoftware is based on the `RootPersistence` class provided by EventAnalysis. This persistence service can be configured at runtime to write on a Root file any set of data objects with a Root dictionary; each event object is written in its own branch of the event tree, while each global object is saved at the root of the output file.

Dictionaries for HerdSoftware data objects are automatically generated by CMake; however, the list of objects for which the dictionaries will be automatically generated is not. When adding a new data object type that is going to be saved in a Root file its header must be manually added to the `DATAOBJECTS_HEADERS` list in `src/dataobjects/CMakeLists.txt`, and the class name (including any eventual namespace) added to the list of classe in the invocation of `root_create_linkdef` in the same file.

# Plugins
HerdSoftware is based on GGS and EventAnalysis: the first is used for detector simulation, while the second for offline data processing. Both frameworks provide an executable implementing the sequence of operations needed by each case (simulation and analysis): these executables implement the workflow by referring to abstract interfaces, and allow the user to use its own implementation of these interfaces through the mechanism of polymorphism. In this way, the `EventAnalysis` executable calls to e.g. `Algorithm::Process()` are redirected to the user implementations of `Process()` defined in its own algorithms. To allow for user implementations to be defined in external projects, both GGS and EventAnalysis relies on a plugin system to load the libraries containing the user code at runtime.

For these reasons, HerdSoftware do not provide any executable; the code is instead compiled into libraries that are loaded as plugins at runtime by the `GGSPenny` and `EventAnalysis` executables. The simulation plugin libraries for GGS are divided in:

* geometries (one library per geometry)
* particle generators

while the data processing ones for EventAnalysis in:

* algorithms
* display algorithms
* data providers

All the plugin libraries are put inside the `plugin/` subfolder, both for the build folder and the install folder. The libraries that are not meant to be loaded as plugins (e.g. the data objects library) are not placed inside `plugin/` (in the install folder they will be under `lib/`).

The Root dictionaries for data objects are placed into their own library, and also this library is put inside `plugins/` since it can be considered as a plugin for Root (it can be loaded at runtime in the Root shell). The rationale is that `plugin/` should provide a unique location for all the plugin libraries.
