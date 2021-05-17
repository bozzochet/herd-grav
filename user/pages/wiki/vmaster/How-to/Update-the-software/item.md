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

**IMPORTANT**: in case both custom packages and HerdSoftware have to be updated, remember to always update the custom packages first.

## Update HerdSoftware
HerdSoftware is currently distributed via its git repository. Once installed it can be updated by checking out the updated version from the repository, and then
recompiling (and eventually installing) it. 

The first operation to do is to update the code:  

```bash
$ cd /path/to/HerdSoftware
$ git pull
```

This will update your copy of the code with the most recent updates from the repository. However, this version of the code might be not the one you need, or it might have unwanted features or bugs. In this case it is possible to update to a given version by knowing its git checksum; to this end, substitute the commands above with:

```bash
$ cd /path/to/HerdSoftware
$ git fetch
$ git checkout <checksum>
```

Git checksums for select code versions are routinely provided in the `HerdSoftware update` presentations at the [analysis meetings](https://agenda.infn.it/category/1325).

After updating the code it must be compiled again:

```bash
$ cd build
$ make -j
```

and then eventually install it again if needed:

```bash
$ make install
```

## Update the custom packages

Custom packages installed with the Installer script can be updated with Installer as well. 
It is sufficient to edit the `configHERD.sh` configuration file by
setting the `VERSION` variable of the package to be updated to the new package version. For example, set `ROOT_VERSION=6.20.00` if you want to update Root to
version 6.20.00. This works also for those packages that does not have a version number, and for which the version to be installed is given in terms of a git commit
hash; for example, set `EVENTANALYSIS_VERSION=866224fb` if you want to update EventAnalysis to the version in commit 866224fb.

**IMPORTANT**: The update must be launched from a clean shell, so open a new one and don't source `setenvHERD.sh`.

After updating the packages as described below, open a new terminal, source the new setenv file and rebuild HerdSoftware as described above.

### Up-to-date configuration file
A `configHERD.sh` configuration file up-to-date with the HerdSoftware version that is going to be installed is shipped with HerdSoftware itself, inside the `environment/` subfolder. This file is updated with the main code to reflect the environment needed for each specific HerdSoftware version. After checking out the new version of HerdSoftware as described above, the config file in `environment/` will contain the needed versions of the external packages. These versions can be used to replace the ones in the `configHERD.sh` inside the Installer folder; alternatively, `environment/configHERD.sh` can be copied in the Installer folder overwriting the old one (in this case remember to re-set the `SOURCE_DIR` and `INSTALL_PREFIX` variables in it).

### Batch update
After setting the desired new package versions, an update of the whole environment can be launched by re-issuing the original command used for the first installation. From inside the Installer folder:
* for LINUX:

  ```shell
  ./install.sh -c configHERD.sh git cmake xercesc geant4 root vgm hepmc crmcg4 ggs eventanalysis
  ```
* for OSX:

  ```shell
  ./install.sh -c configHERD.sh git cmake xercesc geant4 root vgm ggs eventanalysis
  ```

If an already installed package has the same version as the one specified in the config file then in principle there's no need to reinstall it. The Installer will ask for confirmation in these cases, and in general it is safe to not reinstall these packages. The only case where a reinstall without a change of version is needed is when a dependency of the package has been updated (see below).

### Package-by-package update
It is possible to launch an update only for a given set of packages, by limiting the list of packages passed to the invocation of `install.sh`. After setting the desired new package versions in the config file, install them by launching the Installer script specifying the packages and the related dependencies to be updated (see below). 

### Package dependencies
Installer dos not keep track of dependencies, so the user has to do this manually. Every time a package is manually updated, all the other packages that depend on it must
be reinstalled, even if their versions did not change. Currently the dependencies are:

- EventAnalysis: depends on Root
- GGS: depends on Root, VGM, CRMC-G4 and Geant4
- CRMC-G4: depends on HepMC
- VGM: depends on Geant4 and Root
- Geant4: depends on Xerces-C

When updating   |  rebuild also
----------------|---------------
xercesc         | geant4 vgm ggs
root            | vgm ggs eventanalysis
hepmc           | crmcg4 ggs
crmcg4          | ggs
geant4          | vgm ggs
vgm             | ggs



For example, when updating Root to a new version the correct command is:

```bash
$ ./install.sh -c configHERD.sh root vgm ggs eventanalysis
```

while to update Geant:

```bash
$ ./install.sh -c configHERD.sh geant4 vgm ggs

```

When updating Xerces-C also Geant4 must be recompiled, and then also GGS since it depends on Geant4, so:

```bash
$ ./install.sh -c configHERD.sh xercesc geant4 vgm ggs

```

When updating multiple packages the commands can be merged, so to update Root and Geant4:

```bash
$ ./install.sh -c configHERD.sh root geant4 vgm ggs eventanalysis

```

The Installer script will ask for confirmation for those packages that needs to be rebuilt without changing version; be sure to confirm, e.g.:

```bash
Begin installation of EVENTANALYSIS 866224fb
A version of EVENTANALYSIS is already installed. Do you wish to reinstall it? [y/N] y
```

## Cleanup of the installation folder
Unneeded versions of the installed custom packages can be automatically removed by the Installer script:

```bash
$ cd /path/to/Installer
$ ./checkusage.sh /path/to/installFolder
```

In this example:

```bash
$ ./checkusage.sh ../install/
CMAKE_3.13.3 is used by: setenvHERD.sh 
EVENTANALYSIS_7d98e157 is not used by any setenv file
EVENTANALYSIS_866224fb is used by: setenvHERD.sh 
GGS_2.6.4 is used by: setenvHERD.sh 
ROOT_6.20.00 is used by: setenvHERD.sh 
VGM_4.5 is used by: setenvHERD.sh 
XERCESC_3.2.2 is used by: setenvHERD.sh  
Remove unused folders? [y/N/all] 
```

you can see that `EVENTANALYSIS_7d98e157` is not used by the `setenvHERD.sh` environment settig file, so it can be removed. Answering `y` the script will ask 
for confirmation for each unneeded package, `n` will do nothing (default), and `a` will remove all the unneeded packages without asking for confirmation.
