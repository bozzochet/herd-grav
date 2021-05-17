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

# Introduction
An external project can be loosely defined as a software package that makes use
of another software package while being compiled separately. This is better
understood by an example involving common knowledge. Root and Geant4 are
well-known and widely-used software packages in HEP. Using them does not imply
that the user's code must be put inside their source folders and compiled
together with them: one simply compiles and installs Root/Geant4 first, then
creates new source code files using the Root/Geant4 classes and compiles them
separately. The user's code is called an external Root/Geant4 project, and
Root/Geant4 is said to be an upstream for the external project. Other 
terminology states that Root/Gent4 is a dependency of the external projects.

A project conceived for being of general use must allow for the creation of
external projects: any specific use of the generic upstream involves
non-generic code that is developed for that specific purpose, and as such it
is better kept separate from the generic code. HerdSoftware is designed as the
collaboration framework so it hosts code that is of common interest and usage,
and it must be usable for the vast majority of analysis and reconstruction
needs. For this reason it allows for being used through external projects.   

# Headers, libraries and configuration files
Before going on a small technical digression on how the external projects work
and are managed is useful. HerdSoftware consists of a set of C++ classes, whose
code is compiled and put in shared libraries. To use the HerdSoftware classes
in new C++ code one needs the HerdSoftware headers which contain the
declaration of these classes and the HerdSoftware libraries that contain the
compiled code. Headers and libraries reside in different folders, and these
folders might be different on each machine where HerdSoftware is deployed. Thus
when compiling the new code of the external project it is necessary to tell the
compiler where these headers and libraries are, since there's not a default
location. To ease the development of external projects, HerdSoftware istself
writes this information in a file called `HerdSoftwareConfig.cmake`. This file
is meant to be processed by the CMake configuration system to automatically
configure the usage of HerdSoftware in an external project, and for this reason
external projects must be configured using CMake. The latter is a tool for
managing the build process of software projects, from configuring the
dependencies from upstream packages (e.g. in which folder the HerdSoftware
headers are) to compilation and installation. The user have to write a text
file called `CMakeLists.txt` with configuration and build instructions
(including which upstreams are to be used) that is then processed by the
`cmake` executable to produce standard `Makefile`s. The usage of CMake for
external HerdSoftware projects is quite simple so you don't need to be familiar
with every aspect of it to start an external projects; starting from the
examples (see below) you will be able to adapt a `CMakeLists.txt` to your
external project. However, in the long run you will benefit from understanding
the basics of CMake; you can find some references in the
[tools page in the wiki](Developer's-manual/Tools.md).


# External HerdSoftware projects 
External HerdSoftware projects are the preferred way to develop new code for
analysis, reconstruction, tests etc. The "new code" typically consists of
algorithms and data objects, but also data providers and persistence services
can be implemented if needed. The intended way to use the code from an external
project in an analysis job is to compile the code into a library, load it as a
plugin in the job configuration file and then use its algorithms in the
pipeline like any other algorithm, or its data providers / persistence services
in the usual way.

A first example of an external project is given in the [example 02](Examples/Ex02:-analyze-MC.md).
In the `EventAnalysisJob` subfolder a simple processing of the digitized file
produced by [example 01](Examples/Ex01:-digitize-MC.md) is created by means of
new algorithms. Notice that, even if this code is distributed with HerdSotware
and it is in a subfolder of the main HerdSoftware folder, it is a true external
project: it makes use of HerdSoftware but it is compiled separately from it. In
fact, the code folder can even be moved outside HerdSoftware and the example
will build and run exactly the same. Its `CMakeLists.txt` shows quite clearly
how to configure the usage of upstream projects (see the `find_package`
directives), to compile a set of source files into a shared library
(`add_library`) and to link the needed upstream libraries to it
(`target_link_libraries`).

Many other examples are implemented as external projects, so when examining one
of them try to identify the features of an external project. Of particular
interest are [example 06](Examples/Ex06:-generate-dictionaries.md) and
[example 07](Examples/Ex07:-custom-persistence.md), both related to the
customization of the output. Example 06 explains how to create a Root
dictionary for new data objects defined in the external project: a dictionary
is needed to save them using the Root persistence service provided by
EventAnalysis (more-on-this-in-[this-how-to-page](How-to/generate-dictionaries-for-custom-defined-classes.md)).
Example 07 shows how to create a custom persistence service for saving
output data in a custom format (e.g. different from the one written by the Root
persistence service): this is useful e.g. to output data in a format that is
readable from some other program or for a different analysis workflow (e.g. a 
Root tree with single leaves for interactive analysis using the Root shell). 

# Template, tips and suggestions
Some additional suggestions about how to implement new features are available
in [this wiki page](User's-manual/Develop-new-analysis-elements.md).
In particular, in [this section](User's-manual/Develop-new-analysis-elements.md#external-project-template)
there are instructions for obtaining a blank external project template from
which you can start your own project.

Like for any other piece of software, version control is very useful for
external HerdSoftware projects. Using a version control system allows for
different people to work on code and put together the modifications each one
makes, but also to keep track of the development history and search for code
regressions. The most used version control system is Git, which is used also
for HerdSoftware, so when starting an external project (either personal or
shared) consider the possibility to use Git with it. Understanding how Git
works is quite important in the frame of collaborating with other people, so
you are warmly encouraged to take an introductory tour to Git as soon as you
can. Some references can be found in the
[tools page in the wiki](Developer's-manual/Tools.md).

When using Git there is the possibility to easily put your code in the Gitlab
instance used by the collaboration. In this way your code will be available to
others and your code will be automatically backed up. There is an 
area in Gitlab for [analysis groups' code projects](https://git.recas.ba.infn.it/herd/analysis/),
and others can be created for personal projects, so get familiar with Git (need
help? Then just ask!) and start using it with your next external project. 


