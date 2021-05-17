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

# How to generate dictionaries for custom defined classes

Either when developing new classes for the HERD data format or when working on analysis code you might have the need to save on file data structures that are more complex than simple Plain-Old-Data (POD) types like `int` or `float` and that are not present in the current data format.

In this case the ROOT persistence service requires that the classes to be written on file have an accompanying dictionary, which is used by the service to know a priori the size and type of all the data members of those classes. This is also true if you want to write on file STL containers like `std::vector` or `std::array` where the contained class is a custom one, which could be a pretty common use case (think something along the lines of `std::vector<MyTrack>`).

Providing a dictionary for a custom class is a rather standard procedure and there are some helper functions for CMake provided by the ROOT team or included in HerdSoftware that can make it even easier. Suppose you have your custom class `MyClass` defined in a header file `MyClass.h` with its own implementation in `MyClass.cpp`. In order to generate a dictionary one of the prerequisites is to have a [Linkdef](https://root.cern/selecting-dictionary-entries-linkdefh) file that contains directives to rootcling/rootcint what to create a dictionary for. Normally you would have to write this file yourself, specifying which classes and type need a dictionary, but in HerdSoftware the RootUtils.cmake file defines a helper function that creates a linkdef file. To use it you simply write in your CMakeLists.txt

```
root_create_linkdef(MyClassLinkDef CLASS MyClass)
```

If you want to use this in an external project, just copy the `RootUtils.cmake` file from the HerdSoftware root directory and include it in your CMakeLists.txt. The first argument is the name of the LinkDef file that will be created and it is followed by the `CLASS` keyword that precedes the names of all the classes to be declared in that LinkDef file. The result should be something similar to

```cpp
// MyClassLinkDef.h

#ifdef __CINT__
#pragma link off all globals;
#pragma link off all classes;
#pragma link off all functions;
#pragma link C++ nestedclasses;
#pragma link C++ nestedtypedefs;
#pragma link C++ class MyClass;
#endif __CINT__
```

but you didn't have to write it yourself, and when you will need to add one more class you only need to update the CMakeList.txt.

If you are trying to generate a dictionary for STL containers the procedure is pretty similar, just name the class in the `root_create_linkdef` call

```
root_create_linkdef(MyClassLinkDef CLASS MyClass std::vector<MyClass>)
```

Note that to create a dictionary for `std::vector<MyClass>` you have to generate it also for `MyClass`, so you have to pass both these classes to `root_generate_linkdef`. In case `MyClass` is a ROOT class (e.g. `TH1F`) then it is sufficient to specify just the vector, e.g.:

```
root_create_linkdef(MyClassLinkDef CLASS std::vector<TH1F>)
```

Once you have a LinkDef you can [generate a dictionary for your class](https://root.cern/manual/interacting_with_shared_libraries/#generating dictionaries). Normally this would require you to call the `rootcling` or `rootcint` executables with the correct arguments but once again we can hide it behind a CMake helper function, this time [provided by the ROOT team](https://root.cern/manual/integrate_root_into_my_cmake_project/), but you need to include the appropriate file in your CMakeLists.txt.

```
include(${ROOT_USE_FILE})
root_generate_dictionary(MyClassDict MyClass.h
                         LINKDEF ${MyClassLinkDef}
                         OPTIONS -I${CMAKE_SOURCE_DIR}/path/to/your/header
                         MODULE libMyClassDict)
```

The first argument is the name of the dictionary file to be created (the `.cxx` extension will be automatically added. N.B: In HerdSoftware we use the `.cpp` extension for all C++ implementation files so beware of this difference), the keyword `LINKDEF` is followed by the variable holding the name of the LinkDef file (it should be the same as the one declared previously, filled by `root_create_linkdef`), the keyword `OPTIONS` is used to pass additional arguments to the `rootcling` call and lastly the keyword `MODULE` is used to specify the name of the `.pcm` file.

Take a look at `HerdSoftware/src/analysis/dataobjects/CMakeLists.txt` for an example of how the dictionaries are generated for all the classes in the Herd datamodel. You will find some additional CMake instructions such as

```
  # Put the automatically generated pcm, rootmap and dictionary library into the plugin folder
  set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/plugin/)
  set(CMAKE_ROOTTEST_DICT 1) # Avoid error when invoking root_generate_dictionary (see https://sft.its.cern.ch/jira/browse/ROOT-7924)
```

You can use the first one to provide a path where the `.pcm` and `.rootmap` files will be installed, while the second one is needed to prevent a bug when the resulting files are being installed.

Now you have generated both a `MyClassLinkDef.h` and a `MyClassDict.cxx` file. If you are compiling your class implementation `MyClass.cpp` in a shared library you have two options:

1. you can compile also the dictionary file into the same library
```
add_library(MyClass SHARED MyClass.cpp MyClassDict.cxx)
```
2. you can compile the dictionary file into a separate shared library and link it against the library with the class implementation
```
add_library(MyClass SHARED MyClass.cpp)
add_library(MyClassDict SHARED MyClassDict.cxx)
target_link_libraries(MyClassDict MyClass)
```

For the HerdSoftware data model the option 2. was chosen. This is because in some cases you don't actually need the dictionary information in your code, so you can just link `libMyClass` and be done with it. Viceversa if you want to load the dictionary (e.g: if you want to use your class in the ROOT interpreter) you can load `libMyClassDict` and that will be enough.
