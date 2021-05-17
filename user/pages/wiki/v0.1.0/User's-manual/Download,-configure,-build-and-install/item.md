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

This page contains the instructions about how to obtain the HerdSoftware code, configure and build it.

# Supported platforms
The code is currently tested on the following 64 bit platforms:
* CentOS 8
* CentOS 7
* Ubuntu 20.04
* Ubuntu 18.04
* Mac OSX 10.15 "Catalina"

Other Linux distribution will probably work with some adjustments. All the instructions below have been verified on the above architectures using the Bash shell; other shells might work but no official support is provided for them.

# Build prerequisites
The software is written in C++ using the C++14 dialect. A compiler that supports this dialect is thus required for building the package. The minimum compiler version that are allowed are:

* GCC >= 5
* Clang >= 3.4

Ubuntu 18.04 ships with GCC 7 and 16.04 with GCC 5 so no action is required. CentOS 7 does not ship with a C++14 compiler by default; the simplest way to fix this is to install the [devtoolset-7](https://www.softwarecollections.org/en/scls/rhscl/devtoolset-7) package.

# Configure the system
On CentOS, Ubuntu and OSX some packages have to be installed using the package manager.
* CentOS 8:
  ```bash
  dnf update -y
  dnf install -y gcc cpp gcc-gfortran which git boost boost-devel python3 curl libcurl-devel wget libX11-devel libXpm-devel libXft-devel libXext-devel mesa-libGL-devel mesa-libGLU-devel qt5-qtbase-devel expat-devel gettext-devel openssl-devel zlib-devel perl-CPAN perl-devel
  ```
* CentOS 7: 
  ```bash
  yum update -y
  yum install -y centos-release-scl-rh
  yum install -y devtoolset-7 git boost boost-devel curl libcurl libcurl-devel wget libX11-devel libXpm-devel libXft-devel libXext-devel mesa-libGL-devel mesa-libGLU-devel glew-devel qt qt-devel expat-devel gettext-devel openssl-devel zlib-devel perl-CPAN perl-devel
  scl enable devtoolset-7 bash
  ```
  The last command must be issued every time a new shell is opened. It can be avoided by adding this line to the   `.bashrc` file:  
   ```bash
   source scl_source enable devtoolset-7
   ```
* Ubuntu 20.04:
  ```bash
  apt-get --assume-yes update
  apt-get --assume-yes install apt-utils
  apt-get --assume-yes install gcc g++ gfortran binutils curl libcurl4 libcurl4-openssl-dev git wget libx11-dev libxpm-dev libxft-dev libxext-dev python3 qt5-default libglu1-mesa-dev libboost-regex-dev libboost-system-dev libboost-filesystem-dev libboost-iostreams-dev libboost-program-options-dev tcl-dev gettext libssl-dev
  ```
* Ubuntu 18.04:
  ```bash
  apt-get --assume-yes update
  apt-get --assume-yes install apt-utils
  apt-get --assume-yes install gcc g++ gfortran binutils curl libcurl4 libcurl4-openssl-dev git wget libx11-dev libxpm-dev libxft-dev libxext-dev python libqt4-dev xlibmesa-glu-dev libboost-regex-dev libboost-system-dev libboost-filesystem-dev libboost-iostreams-dev libboost-program-options-dev tcl-dev gettext libssl-dev
  ```

* OSX (all versions)

  Install XCode:
  ```bash
  xcode-select --install
  ```

  Install the Homebrew tool:
  ``` bash
  ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
  ```

* OSX 10.15 "Catalina"

  Fix the header include path by means of:
  ```bash
  export CPATH=`xcrun --show-sdk-path`/usr/include
  ```
  Put the above line in your `~/.bashrc` to avoid having to issue it every time you open a new console.

  After installing Homebrew as above, install the missing packages with:
  ```bash
  brew install wget
  brew install boost
  brew install argp-standalone
  brew install qt5
  brew link qt5 --force
  ```

  Tell CMake where to search for Qt5:
  ```bash
  export CMAKE_PREFIX_PATH=`ls -dr /usr/local/Cellar/qt/* | head -1`
  ```
  Put the above line in your `~/.bashrc` to avoid having to issue it every time you open a new console.


# Download the code
HerdSoftware can be downloaded from the Gitlab 
[Releases](https://git.recas.ba.infn.it/herd/HerdSoftware/-/releases)
page. For each release, links to the code and to the related documentation are
provided.

For code development purposes it is possible to clone the git repository.
Access control is enforced on code download by means of ssh keys. If you don't
have a key, then generate a pair following
[these instructions](https://help.github.com/en/github/authenticating-to-github/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent)
(just the first section is sufficient) and then [upload](https://git.recas.ba.infn.it/profile/keys)
your **PUBLIC** key to your Gitlab profile.

After uploading your key you should be able to clone the repository with the command:
  ```bash
  git clone git@git.recas.ba.infn.it:herd/HerdSoftware.git
  ```

# Build the code

## Automatic build
HerdSoftware can be built and installed with the `setupHERD.sh` script which
can be found in the `environment/` subfolder of the HerdSoftware main folder.
This will be useful for deploying a user or production environment, for which a
stable version of HerdSoftware is suitable. First of all, modify the value of
the SOURCE_DIR and INSTALL_PREFIX variables inside the
`environment/configHERD.sh`configuration file. These variables hold the names
of the folders that will be used used for downloading and building the source
and for installing the built packages, respectively. Set them to values which are
appropriate for your system. Any path will be fine, just don't set them as
subfolders of the HerdSoftware code folder since this will generate an error.
Set also the BUILD_PROCESSES variable to the number of processor cores to be
used to build the code. Then enter in the `environment`	subfolder of the
HerdSoftware code folder and give the command:
```bash
./setupHERD.sh hs
```
The script will perform a check of the environment packages, eventually asking
for reinstalling already installed packages (it is safe to answer No) and
installing missing packages (it can take up to several hours), then it will
build and install HerdSoftware. At the end of the installation process the
script will print the path of the environment settings file on the screen,
e.g.:
  > Environment settings dumped to:  
     /HERD/software/install//setenvHERD_<version>.sh
  
Source this file to use the full HerdSoftware environment (this operation has 
to be repeated every time a new  terminal is open).

## Manual build
The automatic build procedure might not be suitable for developers needing to
frequently modify and recompile the HerdSoftware code. For this purpose the
manual build procedure is decribed below.
 
### Build the environment
HerdSoftware is based on some software packages that have to be compiled and
installed in advance, and that will constitute the environment in which
HerdSoftware will be built and run. 

**IMPORTANT**: the procedure described below will install a new, self-contained environment with all the needed packages compiled from sources. Eventually existing installations of the same packages can cause conflicts and errors during the procedure, so the shell environment should be clear of any reference to them before starting the build. Check that the environment variables:
* PATH
* LD_LIBRARY_PATH
* ROOTSYS
* CMAKE_PREFIX_PATH

are either not defined or not containing any reference to previously installed packages (especially ROOT) before starting. If not, check for the presence of environment settings in your `.profile` or `.bashrc` files (either direct settings of the variables listed above or sourcing a config file, e.g. `source /path/to/MyOldRootInstallation/bin/thisroot.sh`), remove them, start a new shell and check again.

**EVEN MORE IMPORTANT**: no support is provided for errors stemming from not following the procedure described below or from a corrupted environment.

A convenient way to build the custom environment packages is to use the same
`setupHERD.sh` script that can be found in the `environment` subfolder of the
HerdSoftware code folder and that has been introduced in the previous section 
for the automatic build. First of all, modify the value of the SOURCE_DIR and
INSTALL_PREFIX variables inside the `environment/configHERD.sh`configuration
file. These variables hold the names of the folders that will be used used for
downloading and building the source and for installing the built packages,
respectively. Set them to values which are appropriate for your system. Set 
also the BUILD_PROCESSES variable to the number of processor cores to be used
to build the code.

Then, from a bash shell, simply cd to the `environment` subfolder and give the
command:
```bash
./setupHERD.sh env
```
This will setup and launch the download, configuration, build and installation
of all the needed custom environment packages (it can take up to several
hours). If some packages are already present the user will be asked for
reinstalling them (it is safe to answer No). At the end of the installation
process the script will print the path of the environment settings file on the
screen, e.g.:
  > Environment settings dumped to:  
     /HERD/software/install//setenvHERD.sh    
  
Source this file to use the freshly installed versions of the custom packages
(this operation has to be repeated every time a new  terminal is open).

#### GGS without Geant4
GGS can be built also without Geant4: this will produce only the readout
libraries to access data in GGS output files for offline analysis. This setup
might be useful for a data analysis workstation where Monte Carlo files will
be analyzed but not produced. Simply remove `xercesc geant4 vgm` from the list
 of packages specified in the `PACKAGES_LINUX` or `PACKAGES_MACOS` variables in
the `environment/setupHERD.sh` to build GGS without Geant4. 

Note that this setup will [disable the build of the simulation code in HerdSoftware](#modular-build).

### Build HerdSoftware
Before starting the HerdSoftware configuration and install procedure, source
the `setenvHERD.sh` file produced by the environment installation script.

The HerdSoftware build configuration system based on CMake automatically detects the packages installed in the build environment and configures the build to build only the desired components. For example, if GGS is not present then the simulation libraries will not be built. In the following, a procedure for installing a full environment is described.

To build HerdSoftware follow the usual procedure for building packages based on CMake:
* create a build folder
* configure the build with CMake
* build with make

For example, assuming the creation of a build folder named `build` inside the HerdSoftware folder the procedure is:
```bash
cd HerdSoftware
mkdir build
cd build
cmake -DCMAKE_INSTALL_PREFIX=/path/to/HerdSoftwareInstallDir ../
make
```

The `-DCMAKE_INSTALL_PREFIX` parameter is needed only if the HerdSoftware package will be [installed](#install-the-package).

### Out-of-source build
HerdSoftware must be built out-of-source. Loosely speaking this means that the `cmake` command must be issued from a folder (called `build` in the instructions above, but that can have any name and can be placed anywhere) dedicated to configuring and building the code, and not from the `HerdSoftware` folder. In the latter case an error is generated:

<img src="../uploads/5a661f3094dd2fe9da843ec61ac5ebdb/InTreeBuildError.png">

### Modular build
The HerdSoftware build system will compile all and only the code portions that depend on available installed packages. However in this first development phase all *optional* packages will be treated as *required*, thus a missing package will cause a configuration error. In order to restore the base behaviour you can use the following flag:
* **-DREQUIRE_ALL_PACKAGES=OFF**
Will not fail in case one of the *optional* packages is missing

It is possible to manually disable the build of some code parts by adding these flags to the command line invocation of cmake:
* **-DDISABLE_ROOT=1**  
Will not build the code that depends on Root (i.e. everything but the analysis data objects library).
* **-DDISABLE_EVENTANALYSIS=1**  
Will not build the analysis code.
* **-DDISABLE_GGS=1**  
Will not build the simulation code and the GGSDataProvider. Note that if GGS has been built [without Geant4 support](#ggs-without-geant4) then the simulation code will not be built anyway, even if this flag is not defined.

The disabled code can be re-enabled by invoking again cmake with the same flags passed with value 0.

### Install the package

The HerdSoftware binary libraries can be used directly from the build folder as explained above, but HerdSoftware can also be installed after the build. Installing HerdSoftware simply means copying the binary files produced by the compilation from the build folder to another folder called install folder, together with some headers and cmake files (see below). It is not required to install HerdSoftware since all the binaries and functionalities will be available also from the build folder; it is up to the user to decide whether to install HerdSoftware or not. For personal use, it is often more practical to use the build folder and to not install.

HerdSoftware installation is done with the usual command:
```bash
make install
```

The installation folder is the one specified by the `-DCMAKE_INSTALL_PREFIX` flag in the invocation of cmake before compilation: configuring the build [as explained above](Download,-configure,-build-and-install.md#build-the-code) the software will be installed in `/path/to/HerdSoftwareInstallDir`. The content of the installation folder will be:
* **cmake**  
  Folder containing the HerdSoftware CMake configuration files for external personal projects, whose configuration should refer to this folder as explained [here](Examples/Ex02:-analyze-MC.md#the-eventanalysis-job)
* **include**  
  Headers needed by external projects
* **lib**  
  Libraries that are dynamically linked to plugin libraries.
* **plugin**  
  Plugin libraries, i.e. libraries that are loaded at runtime.

### Set the environment
In order to use HerdSoftware the `setenvHERD.sh` file produced by the
environment installation script should be sourced. Additionally, as briefly
explained above, some environment variables have to be set to make use of 
HerdSoftware components in an EventAnalysis job:
* for using HerdSoftware from the **build** folder  
```bash
export EA_PLUGIN_PATH=/path/to/HerdSoftware/build/plugin/:$EA_PLUGIN_PATH
```

* for using HerdSoftware from the **install** folder  
```bash
export EA_PLUGIN_PATH=/path/to/HerdSoftwareInstallDir/plugin/:$EA_PLUGIN_PATH
export LD_LIBRARY_PATH=/path/to/HerdSoftwareInstallDir/lib/:$LD_LIBRARY_PATH
```

macOS users should use `DYLD_FALLBACK_LIBRARY_PATH` instead of `LD_LIBRARY_PATH` in the above command.

These settings must be set every time a new terminal is opened, or alternatively added to the `~/.bashrc` file.


# Update the installation
Instructions about how to update an existing environment can be found in [this how-to page](../How-to/Update-the-software.md).
