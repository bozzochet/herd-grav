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

# Minimum required GCC version for bootstrapping
GCC_MIN_REQUIRED_VERSION=4.5.0

# Packages to be installed (ordering is important, respect dependiencies)
INSTALL_PACKAGES="root xercesc geant4 vgm ggs"

# Packages versions and options
# Prefixes are relative to install prefix

GCC_VERSION=4.7.1
# The versions of the following packages are those obtained by running ./contrib/download_prerequisites
# http://stackoverflow.com/questions/9297933/cannot-configure-gcc-mpfr-not-found
GMP_VERSION=4.3.2
MPFR_VERSION=2.4.2
MPC_VERSION=0.8.1
#BINUTILS_VERSION=2.22
GCC_PREFIX=GCC_${GCC_VERSION}

# CLING_VERSION=   # Not supported yet, git master version will be built.
CLING_PREFIX=CLING
CLING_CXX14=ON

CMAKE_VERSION=3.13.1
CMAKE_PREFIX=CMAKE_${CMAKE_VERSION}

GIT_VERSION=1.8.3
GIT_PREFIX=GIT_${GIT_VERSION}

QT_VERSION=4.8.5
QT_PREFIX=QT_${QT_VERSION}
QT_FLAGS="-confirm-license \
          -opensource \
          -release \
          -no-declarative \
          -no-multimedia \
          -no-nis \
          -no-openvg \
          -no-phonon \
          -no-phonon-backend \
          -no-qt3support \
          -no-script \
          -no-scripttools \
          -no-webkit \
          -no-xmlpatterns \
          -nomake demos \
          -nomake examples \
          -nomake docs"

BOOST_VERSION=1.55.0
BOOST_PREFIX=BOOST_${BOOST_VERSION}
BOOST_LIBRARIES="system,filesystem,python,regex" #comma-separated list, NO spaces

PYTHON_VERSION=2.7.6
PYTHON_PREFIX=PYTHON_${PYTHON_VERSION}

LIBXML2_VERSION=2.9.2
LIBXML2_PREFIX=LIBXML2_$LIBXML2_VERSION

IMAGEMAGICK_VERSION=6.9.2-0
IMAGEMAGICK_PREFIX=IMAGEMAGICK_${IMAGEMAGICK_VERSION}
IMAGEMAGICK_FLAGS="--enable-hdri"

PODOFO_VERSION=0.9.3
PODOFO_PREFIX=PODOFO_${PODOFO_VERSION}
PODOFO_FLAGS="-DPODOFO_BUILD_SHARED=1 -DPODOFO_HAVE_JPEG_LIB=1 -DPODOFO_HAVE_PNG_LIB=1 -DPODOFO_HAVE_TIFF_LIB=1" # CMake configure flags

XROOTD_VERSION=4.5.0
XROOTD_PREFIX=XROOTD_${XROOTD_VERSION}

ROOT_VERSION=6.14.04
ROOT_PREFIX=ROOT_${ROOT_VERSION}
ROOT_ENABLE="cxx14 minuit2 xrootd"
ROOT_DISABLE="qtgsi qt gdml python"
ROOT_EXTRA_FLAGS="" # configure-style for Root < 6 and CMake-style for Root >= 6

VGM_VERSION=4.4
VGM_PREFIX=VGM_${VGM_VERSION}
VGM_BUILD_CXXSTD=14  # 11 or 14

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

GGS_VERSION=2.4.4
GGS_PREFIX=GGS_${GGS_VERSION}
GGS_DISABLE_VGM=0 # Set to 1 to disable VGM in GGS

EVENTANALYSIS_VERSION=a2a27d4a
EVENTANALYSIS_PREFIX=EVENTANALYSIS_${EVENTANALYSIS_VERSION}

FLUKA_PACKAGE="/home/mori/software/FLUKA/fluka2011.2-linuxAA.tar.gz"
FLUKA_PREFIX=FLUKA_2011.2
FLUKA_FLUFOR=g77  #Compiler: set it either to gfortran or g77
