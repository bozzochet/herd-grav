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

The data objects produced by the analysis jobs are written to output files (in 
other words, they are made persistent) by the persistence service components.
Depending on the implementation, a persistence service can write a fixed set
of data objects or a configurable set, can use a specific output format etc.  

Below a brief description of the available persistence services is given,
together with the name of the plugin library that contains them. For a more
detailed description please see the
[doxygen documentation](https://wizard.fi.infn.it/herd/software/doxygen).

# **Library**: libHerdDataProviders

# **Persistence services**
* [**HerdRootPersistenceService**](https://wizard.fi.infn.it/herd/software/doxygen/master/classHerd_1_1HerdRootPersistenceService.html)  
This persistence service can save any number of event and global data objects 
to a Root file. The set of objects to be saved can be specified by booking the
objects in the analysis configuration file. The only requirement is that the
objects must have a Root dictionary. All the standard data objects in
HerdSoftware have dictionaries, so all of them can be saved in a Root file;
when creating new data objects that will have to be saved in a Root file with 
HerdRootPersistenceService please refer to
[Ex06](../Examples/Ex06:-generate-dictionaries.md) for guidance about how to
create a dictionary for them.
