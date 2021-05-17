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

[[_TOC_]]

# Introduction  
HerdSoftware is a framework for Monte Carlo simulation, event reconstruction and 
data analysis for the HERD experiment. It is conceived to provide a full solution 
for (almost) all the computation needs of the experiment. Being developed as a common 
framework it adopts some technologies that helps in sharing the code, adding new features 
while reducing the possibility to break something, and accommodate the code for all 
the possible reconstruction/analysis needs that might come out in the future. Some 
people might not be familiar with many of these; this guide will try to introduce 
them gently as they become necessary to understand the current topic.

Below some basic concepts useful to understand the philosophy and the intended way of
usage of HerdSoftware are introduced.

# General architecture and usage  
HerdSoftware is written in C++, and provides a set of classes for dealing with the most
common computing necessities of the HERD experiment. The code is developed in a modular
way, so that the user can make use of the existing code and eventually add new code for
new functionalities without having to modify the existing one, typically. The typical
usage consists of producing some data files using the Monte Carlo simulation and then
processing them with data processing algorithms. These can be the ones provided by
HerdSoftware as well as custom ones written by the user, which can combine them in
different ways to perform different analyses or data reductions. The same algorithm
combination and execution procedure is used for all the reconstruction and analysis jobs,
while the configuration and run of a Monte Carlo simulation is handled separately.

# External packages  
Not all the software used by HerdSoftware is inside HerdSoftware. External software 
packages are used to profit from already available code; as trivial examples, Geant4 
is used for the Monte Carlo simulation, and Root for common data analysis tools. 
Other than these known packages, some other packages are used as well for other purposes:

- the GGS package is used as an interface with Geant4, i.e. HerdSoftware does not 
  use Geant4 directly but just through the usage of GGS
- the EventAnalysis package provides the possibility to create a set of data processing 
  algorithms, and to choose which one to use for running a reconstruction/analysis 
  pipeline

These and other packages needs to be installed before downloading and compiling HerdSoftware, 
as explained in [this page](../../User's-manual/Download,-configure,-build-and-install.md).

# Simulations  
The simulation in HerdSoftware is based on the GGS package, which allows for simplifying 
the creation of a Monte Carlo simulation based on Geant4. Almost all of the simulation 
components (particle generator, hits, output, main executable) are implemented in 
GGS, and in HerdSoftware only the detector geometry is implemented as C++ code using 
the geometry classes of Geant4 (solids, logical volumes etc.). By using the already 
available GGS components the amount of work needed for building the simulation is 
reduced.

# Data processing  
The data processing in HerdSoftware is based on the EventAnalysis package. Using 
EventAnalysis it is possible to define the building blocks, called algorithms, in 
which a data processing can be decomposed. Each algorithm take care of a specific 
aspect of data processing: for example, the tracking procedure with a silicon microstrip 
detector can be decomposed in an algorithm which creates clusters starting from strip 
signals, another algorithm that starting from clusters evaluates the impact point 
of the particle and another algorithm that fits a track to the impact points. An 
algorithm can be used in different data processing procedures (e.g. an event selection 
algorithm might be used in different analysis), and easily switched off (e.g. to process 
unselected data) or replaced (e.g. to perform a different selection). New algorithms 
can be defined without having to modify old ones. The processing jobs are defined in 
a configuration text file by specifying the sequence of algorithms to be executed.
All the HerdSoftware reconstruction and analysis procedures are implemented in terms 
of EventAnalysis algorithms.    

# Examples  
HerdSoftware comes with a rich set of examples, covering the usage of the framework 
ranging from basic aspects like how to launch a simulation and process the output data, 
to more advanced ones like how to create a personal data analysis project or define 
a custom output format.

# Personal and external projects  
When developing new code (e.g. new algorithms for some tests or even a full analysis)
HerdSoftware is not the best place to work in. Being conceived as a common framework
for the whole collaboration, it should contain only code that is relevant to many people
and that has been somehow validated to a certain extent; in this way the code is kept
organized and can be used with some confidence. Personal code (like e.g. new algorithms
developed for a new analysis or simply for testing) are better developed in a personal
project. A personal project is a software project whose source files are not inside the
HerdSoftware folder, but which can make use of the HerdSoftware components (e.g. algorithms,
data objects etc.). It is conceptually equivalent to a simulation program making use of
Geant4 or an analysis program making use of Root: they use Geant4 or Root but do not
live inside the Geant4 or Root folders. Personal projects allow for developing new
components (e.g. algorithms), making tests etc. without touching the common code placed
in HerdSoftware. They can be conveniently placed in separate git repositories, and 
eventually be integrated in HerdSoftware after validation for being available to the 
whole collaboration.

Similarly, a group working on an analysis or reconstruction might prefer to not
place the code inside HerdSoftware. The group should create an external project
much like the personal projects described above, where all the team members can
put the code they develop. The new elements that can be of general use can then
from time to time be integrated in HerdSoftware, while the 
analysis/reconstruction-specific ones will remain in the external project.  

# Getting help
The HerdSoftware wiki provides basic support with the most common issues.
Should you need more help, then [join the Discord server](../../How-to/Join-the-Discord-server.md)
(preferred), or in alternative send an email to the developers.
 
