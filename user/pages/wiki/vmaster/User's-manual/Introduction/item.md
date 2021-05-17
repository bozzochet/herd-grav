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

HerdSoftware is the software suite of the HERD collaboration. It is a framework written in C++ containing the code for data analysis and Monte Carlo simulation. It is designed to facilitate the concurrent development by many developers and to impose a clean and simple structure to the code.

# Data analysis

Technically speaking, the data analysis portion of HerdSoftware is an EventAnalysis project. EventAnalysis is a framework for creating generic event data analysis programs; it defines a set of interfaces for developing classes which encode the basic entities of a typical data analysis program (data objects, data access, algorithms, data persistence) and their mutual relationships and interactions. It also implements the most common operations like looping on events, configuring an analysis job etc. An EventAnalysis project like HerdSoftware can then profit of the simple and flexible code architecture and of the generic facilities provided by EventAnalysis to significantly reduce the cost of the initial design phase, and focus right from the beginning on the implementation of the entities (algorithms etc.) which are project/experiment specific.

Since EventAnalysis constitutes the foundation layer upon which HerdSoftware analysis and reconstruction is built then it is important that its general principles and basic usage are well understood. The code and the documentation for EventAnalysis can be found at the following links:

*  [EventAnalysis project site](https://baltig.infn.it/mori/EventAnalysis)
*  [EventAnalysis documentation](https://wizard.fi.infn.it/eventanalysis)

# Monte Carlo simulation
For Monte Carlo simulation, HerdSoftware makes use of GGS (Generic Geant4 Simulation): a framework based on Geant4 written to speed up the development and deploy of simulations for any kind of detector. It features a generic implementation of the mandatory Geant4 user classes (particle generator, hits, sensitive detectors, user actions etc.) that usually have to be implemented more or less from scratch for every simulation scenario. Leveraging the generic implementations provided by GGS, which tipically fulfill most of the requirements of most simulation scenarios, the user has only to implement the detector geometry in order to be able to start simulating, thus reducing considerably the initial required effort. GGS also allows the user for overriding its generic implementations, should a more detailed one become necessary. All the user code (detector geometry and custom implementations of user classes) is handled via plugin libraries which allow for plugging different components at runtime and making it easy e.g. to switch from a geometry to another one. Thanks to these features GGS is effective in speeding-up the initial simulation development allowing for quickly obtaining preliminary results, while providing the customization potential to allow for future evolution and refinement into a more detailed product.

GGS constitutes the foundation of the simulation code in HerdSoftware, so involved people should be familiar with it. The code and the documentation can be found at:

*  [GGS project site](https://baltig.infn.it/mori/GGSSoftware)
*  [GGS documentation](https://wizard.fi.infn.it/ggs)


