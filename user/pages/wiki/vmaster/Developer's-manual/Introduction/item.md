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

The development of HerdSoftware is guided by some principles with the aim of producing code that is:

* organized in a clean and neat structure
* contributed by different people
* easy to inspect for bugs and changes
* tested for correct behavior
* documented

To achieve these goals, some tools and practices are leveraged:

* The code is written in C++, using the C++14 dialect. This gives acess to language features like smart pointers, move semantics, lambdas etc. that make writing robust, fast and clear code easier than previous language revisions. These features should be preferred over traditional approach (e.g. don't use raw pointers whenever it's possible). 
* Foundation frameworks (GGS and EventAnalysis) provide the "basic building blocks", i.e. base classes, for developing the analysis/simulation entities as derived classes. The frameworks define also the interaction between these classes (e.g. algorithms make use of the data stores to retrieve the data objects) by defining proper interfaces. With this set of definitions the code developed within the frameworks is naturally broken down into an ordered set of classes with well-defined mutual interactions. This helps understanding what a given class does and setting the ground for a common way of developing code.
* The code is hosted in a git repository. Git makes it possible for different people to work on the same code basis at the same time, to merge the modifications and to inspect the changes made by each contributor, enhancing the productivity of the development group and providing a robust tool for inspecting the code history for regressions or bugs. In order to fully exploit these features a development workflow must be agreed.
* Code must be tested for correct behavior. Each class should have its own set of tests implemented in the unit test suite of HerdSoftware, which is based on the Catch2 framework. The tests should ideally be as fine-grained as possible, to ease the identification of the bugged code portion whenever one test fails. They should also cover the largest code portion and use cases. The aim of these tests is twofold: to assess the correct behaviour of new code and to make it easier to spot regressions introduced by code modifications.
* Code documentation is essential for newcomers and for maintainers. Every class should be documented inline with code comments and doxygen tags, and have a detailed description in the HerdSoftware wiki. This will ease the usage by other persons, facilitate code inspection and understand the behaviour.

# Summary of code development guidelines

Here is a list of the guidelines. The ways to comply with them (and typically also the reasons why) are described in the linked pages of the developer's guideline.


* Be familiar with the development tools ([go to page](Developer's-manual/Tools.md))  
* Use modern C++ features as much as possible ([go to page](Developer's-manual/Coding-guidelines.md))
  * do not use C arrays: go for std::array or std::vector
  * do not use raw pointers: go for EA::observer_ptr, std::unique_ptr, std::shared_ptr
  * prefer STL algorithms over self-written ones
  * define copy/move constructor and copy/move assignment operator for new classes
  * do not ignore error codes or exceptions
* Code files must be formatted with `clang-format` before committing them ([go to page](Developer's-manual/Code-formatting.md))  
* Know the framework before starting to develop ([go to page](Developer's-manual/Architecture.md))  
  * Know the architecture of GGS and EventAnalysis
  * Know how HerdSoftware is structured
  * Understand how the CMake configuration is implemented
  * Understand what the code build will produce
* Write tests for your software ([go to page](Developer's-manual/Writing-tests.md))
  * Write unit tests for your class at least for the most common use cases
  * Try to keep coverage high  
* Document the code  ([go to page](Developer's-manual/Writing-documentation.md))  
  * Use Doxygen comments for concise, fine-grained documentation
  * Use README.md files or the the wiki for descriptive, behavioral documentation
  * Update the documentation after making modifications to the code
* Use the issue board extensively ([go to page](Developer's-manual/Tackling-issues.md))
  * Open an issue for every development/bug
  * Open a milestone for large development goalsensively for planning development and bug fixing 
