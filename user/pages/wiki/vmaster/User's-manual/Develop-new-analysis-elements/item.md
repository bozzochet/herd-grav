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

The analysis elements provided by HerdSoftware (data objects, algorithms etc.) obviously do not cover any necessity; most analyses or reconstruction procedures will necessitate for new elements to be developed and added to the existing ones. In this section the guidelines and suggestions for creating custom analysis elements and eventually integrating them in HerdSoftware are outlined.

# General guidelines
When developing code for personal use, everyone adopts the style that is more convenient and functional for his own needs. This can lead to a very efficient production of code, but often this code is hard to read for other developers. Furthermore, developing inside a framework like HerdSoftware inevitably imposes some constraints. Below are some suggestions to facilitate the production of code which is functional, of general understanding and more easy to being incorporated in mainline HerdSoftware:
* **Start from existing code**  
Existing code is organized in a well-defined architecture of classes; when you want to develop a new component, e.g. an algorithm, use the files of an existing one as templates. A copy-paste of headers and source files is a good starting point and is in many senses better than starting from scratch
* **Document your code**  
The time spent documenting the code is always a good investment. The person that will benefit the most from code documentation is likely the same person who wrote it, since he is the one that most likely will have to maintain the code or modify it long time after it has been originally written. It is very hard to remember exactly what a piece of code does after some time has passed since it was written; a comment can save much more time than what it takes to be written.
* **Document the behaviour of your code**  
Apart from putting comments in code, it is equally important to write general comments about how a given class behaves: which data objects it needs, which it produces, which are its parameters etc. The doxygen documentation system of HerdSoftware provides a very effective way to place this information directly inside header files; when you write the header of a new class take existing classes as examples and try to match the level of detail of their doxygen comments.
* **Keep it simple**  
Develop your workflow as a set of algorithms as simple as possible. Code complexity as a sequence of simple classes rather than a single complicated class. Think about the relationship with data objects (which does my algorithm need? Which it produces?) and avoid adding new classes to the data model if you can use some that already exist. 
* **Write tests**  
HerdSoftware provides a unit testing framework based on [Catch2](https://github.com/catchorg/Catch2), see in the `testsuite` folder. Writing a unit test for your new class provides a powerful way of spotting bugs and conceptual errors even before the code is ever run on real data. This also helps in finding regressions when the code is modified.
* **Adhere to the general scheme of HerdSoftware**  
The whole project is developed trying to adhere to some general conventions: use a clear and logical folder structure, try to put each class in its own header and source files, use enums instead of numerical arbitrary constants for non-numeric entities (e.g. the sides of the detector) etc. Using common conventions makes it easier for other developers to read the code, with obvious benefits in terms of code circulation and quality.

As said, all the above points are suggestions and not rules: as long as one writes software for personal use then nothing will be enforced. However, it is generally agreed by the members of the collaboration that common code should comply with some (still unspecified) "minimum coding quality standards", in order to ensure a minimum of code quality and code documentation. Trying to follow the above suggestions from the start of the development of new code will make integrating it in mainline HerdSoftware (and thus giving it the status of "official") easier.

# External projects
The cleanest way to develop personal code is to do it in a personal project. A personal project (or external project) is a project separated from HerdSoftware, where code making use of HerdSoftware headers and libraries is developed. In this way the custom code can make use of the standard HerdSoftware while being placed in a different folder, thus keeping official and personal code well separated.

## Example project
An example of a personal project is given in [example 02](Examples/Ex02:-analyze-MC.md); it provides a complete overview about a possible way to organize, develop, configure, build and run the code from an external project. It also shows how to analyze Herd data with a standard Root script. This latter approach might result being more convenient for quick and dirty analysis; however the first approach based on algorithms etc. is more suitable for code which may eventually be included in HerdSoftware.

## External project template
In order to start with an external project, a template is available. It
provides the skeleton of a full project including the `CMakeLists.txt` files,
an algorithm class and a README. Download with:

```bash
git clone git@git.recas.ba.infn.it:herd/ExternalProject.git
```
and follow the instructions in the README for build and usage. This project
is meant to be just a convenient starting point for an external project, so it
has no functionality. Feel free to dispose of it, but **do not push any**
**modification to the original repository!**

## Build tree or install tree
External projects can make use of the HerdSoftware headers and libraries in two ways: either by using the headers from the HerdSoftware source folders and the libraries from the [build folder](Download,-configure,-build-and-install.md#build-the-code), or by picking headers and libraries from the HerdSoftware [install folder](Download,-configure,-build-and-install.md#install-the-code). In the former case it is said that the external project refers to the HerdSoftware _build tree_, while in the latter that it refers to the HerdSoftware _install tree_. Both are supported; referring to the build tree is usual when developing an external project while modifying HerdSoftware (so that the external project will always see the latest modified HerdSoftware), while referring to the install tree is usually more stable since installed versions are tipically less likely to be modified.

The tree to which the external project refers to is specified by the `-DHerdSoftware_DIR` flag in the cmake invocation for the external project. The flag must be set to the subfolder of the build tree or install tree that contains the `HerdSoftwareConfig.cmake` file; this file is placed in the build folder itself and in the `cmake/` subfolder of the install folder.  In [example 02](Examples/Ex02:-analyze-MC.md#the-eventanalysis-job) it is shown how to specify the flag in an external project for referring to the HerdSoftware install tree. 

## Integrating the code into HerdSoftware
Code developed in personal projects can eventually be integrated in HerdSoftware if/when it is given the "official" status. To this purpose the code must be structured in data objects, algorithms etc., for a seamless integration with the standard HerdSoftware components, so developing the code from the start complying with this structure will surely ease the integration. The code transfer from personal projects to HerdSoftware is a matter of copy-pasting code into header and source files in HerdSoftware, thus resembling the creation of new elements directly inside HerdSoftware as described below.


# Custom elements in HerdSoftware
An alternative way to develop personal analysis code is to do it directly inside HerdSoftware. This approach has the advantage of using the existing folder structure and build files, and to produce code that can eventually be directly integrated into HerdSoftware mainline without much effort. However, it also has disadvantages like mixing official and personal code. It is generally recommended to develop personal code in personal projects as described in the previous paragraph rather than doing it inside HerdSoftware as described in the following.

## Creating new data objects
The HerdSoftware data objects are coded as C++ classes and structs. Headers and source files are placed in `include/analysis/dataobjects/` and `src/analysis/dataobjects`, respectively. If you need to define a new data object then you should simply create its header and its eventual source file in the above mentioned folders. If the new class has a source file (a .cpp file) then in order to compile it you should add it to the list of files encoded in the `HerdDataObjects_SOURCE` list in `src/analysis/dataobjects/CMakeLists.txt`. The file will be compiled by the invocation of make and added to the HerdDataObjects library.

To create a Root dictionary for the new data object simply modify the macro invocations in `/src/analysis/dataobjects/CMakeLists.txt` by adding the name of the new class to `root_create_linkdef` and its header file to `root_generate_dictionary`.

See [here](How-to/Generate-dictionaries-for-custom-defined-classes.md) for more details about dictionary generation.

## Creating new algorithms
Creating a new algorithm is very similar to creating a new data object. The headers and source files are inside subfolders of `include/analysis/algorithms/` and `src/analysis/algorithms`, respectively. The subfolder name indicates the category of contained algoritms, e.g. `tracking` or `digitization`. Place your algorithm files in the corresponding subfolders, and add the name of the source file to the list of files in `src/analysis/algorithms/subfolder/CMakeLists.txt` for compiling it. In case your algorithm do not belong to any category corresponding to a subfolder then create a new subfolder using an existing one as a template. If you create a new subfolder then add it to the `src/analysis/algorithms/CMakeLists.txt` file (see how e.g. the `digitization` folder is treated in that file).

## Committing custom elements
Should you want to commit your work to the HerdSoftware repository, remember to do so in a personal branch in order to avoid conflicts with modifications made by other developers. As long as you work in your own private branch then nobody will interfere with your work. Choose a suitable branch name that will uniquely identify your branch from those of other developers, e.g. "mybranch" or "test" are not good names while "nicolamori_newdigitizer" is.

## Integrating custom elements into HerdSoftware mainline
In order to include your code in the official version of HerdSoftware you should ask the maintainers of the repository to merge your branch into the master branch from which the official releases are cut. You might be asked to do some modifications like cleaning up the code, add some documentation etc. before your branch is ready for being merged.
