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

**Guideline**: be familiar with the development tools.

---

The development of HerdSoftware leverages some tools that are used for hosting the code, configuring the build etc. Developers are required to be confident with these; a small introduction to each tool is given below, together with some references.

# Git
Git is a distributed version control system: it keeps track of code modifications and allows for merging the modifications introduced independently by each developer. All the code repository information is kept locally, in the same folder where code files are; it is possible, but not mandatory in general, to synchronize the local repository with one or more remote repositories in order to share the code with other people.

The main reference for git is the [git book](https://git-scm.com/book/). It is freely available and provides a smooth introduction to the basics of git. HerdSoftware developers should be familiar with the contents of the first three chapters at least. Specifically, the concepts that should be clear are:
* usage and means of commands like:  
  * git status  
  * git diff  
  * git add  
  * git commit  
  * git push  
* what are the index (staging area), the working tree and the repository tree
* how local and remote repositories relates
* what are tags and branches, and how the branch-merge process works

# GitLab
GitLab is a web interface for managing git repositories. It provides access to the code repository with fine-grained permissions, allows for basic operations on the repository and provides additional tools like continuous integration, an issue tracker etc. It is used for managing the main HerdSoftware remote repository hosted by the ReCaS data center.

The interface is quite self-describing, and the web provides many introductions and tutorials for beginners. The main features of interest for HerdSoftware developers are the issue tracker and the wiki.

## Issues
The GitLab issue tracker (accessible from the "Issues" link on the left toolbar) is used for tracking both developments and bugs. When a new development is planned or a software malfunctioning is found, an issue should be opened. This allows all the developers for keeping track of what's going on (and of what's happened in the past) and should be used extensively. Issues should be labeled in order to better categorize them. In particular, these labels are particularly useful:
* ~"To Do": for open issues which are still not actively pursued.  
Add this label to newly created issues.  
* ~Doing: for open issues that are currently worked on.  
Add this label when you start to work on an issue (and remove the ~"To Do" label).  
* ~Bug: for issues that are bug reports.  
Add this label when you open a bug report.

More than one label can be attached to an issue.

Using the Issue board a developer can have clear overview of the development status, and eventually pick up an issue and work on it.

## Wiki
The GitLab wiki (which hosts this page) is where the HerdSoftware documentation is mainly hosted. It consists of several pages covering topics like how to obtain the software, how to run it, how to add new features etc. It is intended to provide a smooth introduction to newcomers and to provide quick references for expert users and developers.

Wiki pages are written using the [Markdown](https://spec.commonmark.org/) language, with some additions that makes up the [GitLab Flavored Markdown](https://git.recas.ba.infn.it/help/user/markdown). It is a very intuitive format which allows for quickly editing wiki pages.

Developers adding features or modifying the code should promptly update the wiki. New pages can be added when necessary. Keeping an up-to-date documentation is as important as the code itself, so all the developers are encouraged to be actively engaged in editing the wiki.

# CMake
CMake is a build configuration system. It is used to automatically produce the Makefiles for building a project, based on some build configuration files written by the user. These build configuration files are usually called `CMakeLists.txt` and are written in a specific CMake language. The advantage of writing CMakeLists over directly writing Makefiles is that the CMakeLists syntax is generally simpler than the one of Makefiles, CMakeLists scales better for large projects, CMakeLists allows for easily configuring the usage of headers and libraries from external packages (e.g. ROOT), and finally Makefiles generated from CMakeLists are usually free from typical bugs  of hand-written Makefiles.

The CMake language is quite involved and powerful to cope with many different needs in build configuration. A quite complete introduction for beginners can be found [here](https://cgold.readthedocs.io/).-In-recent-times,-a-new-approach-to-writing-CMakeLists-known-as-[Modern-CMake](https://cliutils.gitlab.io/modern-cmake) has gained traction. The HerdSoftware CMakeLists are written as much as possible using this new approach.

The HerdSoftware developers should be confident enough with CMake to be able to read and modify the CMakeLists. An approximate list of items that one needs to know is:
* what are: a target, a variable, a list
* how to build an executable and a shared library
* how to define target properties (include folders, link libraries, compiler flags etc.)
* how to configure the usage of external packages

Additional items that are useful to understand how CMake works are:

* what is an out-of-source build
* how to define CMake variables on the command line
* what is the CMake cache and how it works

# Doxygen
[Doxygen](http://www.doxygen.nl) is a tool for writing code documentation directly in code files. It relies on specially crafted code comments that are read by a code parser (the `doxygen` executable) and converted to HTML pages or latex files. The main advantage of placing the code documentation inside the code files themselves is that the processes of developing code and documenting it naturally tends to merge in a single process, providing a more complete documentation and then mitigating the "I'll write the documentation later" syndrome (which is very widespread and often leads to the "No documentation, sorry" stable state...). Doxygen can also warn about undocumented code sections, so it is useful in spotting undocumented code.

The doxygen tags are many, and they allow for documenting many aspects of the C++ code; for a nice and concise introduction read the "Comment blocks for C-like languages" section of the [doxygen manual](http://www.doxygen.nl/manual/docblocks.html#cppblock).

In HerdSoftware, the classes should be provided with doxygen comments, which should be put in header files. Every public member (and possibly also the private ones) should have a comment with a description of its functionality, return value and input parameters. It is also desirable to have a general description of the class; for algorithms and data providers this general description should include a list of produced/consumed event objects. Existing header files provide a good example and guideline for writing doxygen comments.

The HerdSoftware doxygen documentation for the master branch is available [online](https://wizard.fi.infn.it/herd/software/doxygen/master). It can be built locally with the command 
```bash
make doxygen
```
from the build folder (requires doxygen to be installed at the moment of configuring the build with CMake). The produced HTL files are put in the `doc/doxygen/html/` subfolder inside the build folder. They can be removed with:
```bash
make clean-doxygen
```
