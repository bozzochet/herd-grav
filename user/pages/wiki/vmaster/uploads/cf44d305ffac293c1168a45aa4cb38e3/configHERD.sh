# Configuration file for install.sh and submodules
#
# This file is a useful place for all user-defined flags, which
# will be visible in install.sh and in every submodule file.
#
# A description of the variables below can be found in install.sh

# --------------------- User-defined variables --------------------- #
INSTALL_PREFIX=/HERD/software/install/
SOURCE_DIR=/HERD/software/source/
LOGS_DIR=${SOURCE_DIR}/logs/
ENV_FILE=${INSTALL_PREFIX}/setenvHERD.sh

# Number of build processes (make -Jn)
BUILD_PROCESSES=4
# Architecture. Set it to 32 to force a 32 bit build on 64 bit systems
ARCH=64
# Build type. Set DEBUG=1 to build the binaries with debug symbols
DEBUG=0
RELEASE=1

# Minimum required compiler version for bootstrapping
# Linux
GCC_MIN_REQUIRED_VERSION=5.0.0
# OSX
CLANG_MIN_REQUIRED_VERSION=3.4.0

# Packages to be installed (ordering is important, respect dependiencies)
INSTALL_PACKAGES="cmake xercesc geant4 root vgm ggs eventanalysis"

# Packages versions and options
# Prefixes are relative to install prefix

CMAKE_VERSION=3.13.1
CMAKE_USE_SYSTEM_CURL=1
CMAKE_FORCE_SSL_ON_SYSTEM_CURL=1
CMAKE_PREFIX=CMAKE_${CMAKE_VERSION}

GIT_VERSION=2.24.0
GIT_PREFIX=GIT_${GIT_VERSION}

XERCESC_VERSION=3.2.2
XERCESC_PREFIX=XERCESC_${XERCESC_VERSION}

GEANT4_VERSION=10.04.p02
GEANT4_PREFIX=GEANT4_${GEANT4_VERSION}
GEANT4_BUILD_CXXSTD=14 # can be either a number (98, 11, 14...) or a flag value (c++98, c++11, c++14...)
GEANT4_INSTALL_DATA=ON
GEANT4_USE_GDML=ON
GEANT4_USE_QT=ON
GEANT4_FORCE_QT4=OFF
GEANT4_USE_PYTHON=OFF
GEANT4_USE_SYSTEM_EXPAT=ON
GEANT4_QT_QMAKE_EXECUTABLE=""

ROOT_VERSION=6.20.00
ROOT_PREFIX=ROOT_${ROOT_VERSION}
ROOT_ENABLE="cxx14 minuit2 xrootd"
ROOT_DISABLE="qtgsi qt gdml python"
ROOT_EXTRA_FLAGS="" # configure-style for Root < 6 and CMake-style for Root >= 6

VGM_VERSION=4.5
VGM_PREFIX=VGM_${VGM_VERSION}
VGM_BUILD_CXXSTD=14  # 11 or 14

GGS_VERSION=2.6.4
GGS_PREFIX=GGS_${GGS_VERSION}
GGS_DISABLE_VGM=0 # Set to 1 to disable VGM in GGS

EVENTANALYSIS_VERSION=cca3e06d
EVENTANALYSIS_PREFIX=EVENTANALYSIS_${EVENTANALYSIS_VERSION}
