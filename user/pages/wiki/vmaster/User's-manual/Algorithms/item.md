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

The HerdSoftware algorithms contain the code which processes the data objects; a sequence of algorithms defines an analysis. Algorithms can be combined and eventually appear multiple times in an analysis, depending on their implementation. Algorithms need data objects as input; since some data objects can be produced by algorithms, the algorithm sequence must account for these producer-consumer relationships. Detailed lists of the data objects consumed and produced by each algorithm can be obtained from the [doxygen documentation](https://wizard.fi.infn.it/herd/software/doxygen.md).

# Library: libHerdAlgorithms

# **Clustering algorithms**
These algorithms deal with the clustering of hits, i.e. creating cluster objects enclosing sets of neighbouring hits.
* [**SiliconDetectorClusteringAlgo**](https://wizard.fi.infn.it/herd/software/doxygen/master/classHerd_1_1SiliconDetectorClusteringAlgo.html)
This algorithm creates clusters of Si strips hits from a Silicon detector. The clustering criterion is based on the absolute energy release: all the neighboring strips with an energy release
greater than 0 are grouped in a cluster. This criterion will be replaced with one based on signal-to-noise ratio in future.

* [**StkClusteringAlgo**](https://wizard.fi.infn.it/herd/software/doxygen/master/classHerd_1_1StkClusteringAlgo.html)
This algorithm creates clusters of Si strips hits from the STK. It simply call SiliconDetectorGeometricDigitizerAlgo with the proper detector name.

* [**ScdClusteringAlgo**](https://wizard.fi.infn.it/herd/software/doxygen/master/classHerd_1_1ScdClusteringAlgo.html)
This algorithm creates clusters of Si strips hits from the SCD. It simply call SiliconDetectorGeometricDigitizerAlgo with the proper detector name.

* [**FitClusteringAlgo**](https://wizard.fi.infn.it/herd/software/doxygen/master/classHerd_1_1FitClusteringAlgo.html)
This algorithm creates clusters of SiPM channel hits from a FIT detector. The clustering criterion is based on the absolute energy release: all the neighboring strips with an energy release
greater than a given noise threshold (0 if no FitChannelInfo objects are found in the data store) are grouped in a cluster.

* [**CaloDBSCANClustering**](https://wizard.fi.infn.it/herd/software/doxygen/master/classHerd_1_1CaloDBSCANClustering.html)
This algorithm groups together all adjacent calorimeter hits into a single cluster. The actual clustering algorithm uses the DBSCAN method to group hits (https://en.wikipedia.org/wiki/DBSCAN).

# **Digitization algorithms**
These algorithms convolve Monte Carlo data with the detector's response in order to reproduce the instrument response corresponding to the simulated data.

* [**SiliconDetectorGeometricDigitizerAlgo**](https://wizard.fi.infn.it/herd/software/doxygen/master/classHerd_1_1SiliconDetectorGeometricDigitizerAlgo.html)
This algorithm digitizes the Silicon detector particle hits (i.e. hits of single particles on Si wafers) into hits on Si strips, applying a purely geometric criterion (i.e. it does not account for electronic noise, conversion to ADC, pedestals, charge drift in silicon etc.). Given a microstrip pitch value, it groups all the particle hits hitting the same strip and produces a hit for the strip. **NOTE**: this algorithm cannot be used directly in analysis jobs; use either StkGeometricDigitizerAlgo or ScdGeometricDigitizerAlgo (see below).

* [**StkGeometricDigitizerAlgo**](https://wizard.fi.infn.it/herd/software/doxygen/master/classHerd_1_1StkGeometricDigitizerAlgo.html)
This algorithm digitizes the STK particle hits, It simply call SiliconDetectorGeometricDigitizerAlgo with the proper detector name.

* [**ScdGeometricDigitizerAlgo**](https://wizard.fi.infn.it/herd/software/doxygen/master/classHerd_1_1ScdGeometricDigitizerAlgo.html)
This algorithm digitizes the SCD particle hits, It simply call SiliconDetectorGeometricDigitizerAlgo with the proper detector name.

* [**SiliconDetectorDriftDiffusionAlgo**](https://wizard.fi.infn.it/herd/software/doxygen/master/classHerd_1_1SiliconDetectorDriftDiffusionAlgo.html)
This algorithm digitizes the Silicon detector particle hits (i.e. hits of single particles on Si wafers) into hits on Si strips, simulating the charge diffusion due to drift in the electric field within the silicon wafer (similarly to `SiliconDetectorGeometricDigitizerAlgo` it does not account for electronic noise, conversion to ADC, and pedestals). Given a microstrip pitch value, it groups the collected charge hitting the same strip and produces a hit for each hit strip.
**NOTE**: this algorithm cannot be used directly in analysis jobs; use either StkDriftDiffusionAlgo or ScdDriftDiffusionAlgo (see below).

* [**StkDriftDiffusionAlgo**](https://wizard.fi.infn.it/herd/software/doxygen/master/classHerd_1_1StkDriftDiffusionAlgo.html)
This algorithm digitizes the STK particle hits, It simply call SiliconDetectorDriftDiffusionAlgo with the proper detector name.

* [**ScdDriftDiffusionAlgo**](https://wizard.fi.infn.it/herd/software/doxygen/master/classHerd_1_1ScdDriftDiffusionAlgo.html)
This algorithm digitizes the SCD particle hits, It simply call SiliconDetectorDriftDiffusionAlgo with the proper detector name.

* [**SiliconDetectorCapacitiveNeAlgo**](https://wizard.fi.infn.it/herd/software/doxygen/master/classHerd_1_1SiliconDetectorCapacitiveNeAlgo.html)
This algorithm propagate the MC hits, one for each implanted strip, derived from drift-diffusion, or from geometric digitization,
to the readout strips through a capacitive net specified by the user.
The algorithm produces a list of hits on readout strips, and the geometric information needed to relate implant and readout strips.
**NOTE**: this algorithm cannot be used directly in analysis jobs; use either StkCapacitiveNetAlgo or ScdCapacitiveNetAlgo (see below).

* [**StkCapacitiveNeAlgo**](https://wizard.fi.infn.it/herd/software/doxygen/master/classHerd_1_1StkCapacitiveNeAlgo.html)
This algorithm applies the capacitive net to the STK hits (after drift-diffusion, or geometric digitization).
It corresponds to a call to SiliconDetectorCapacitiveNetAlgo with the `stk` detector name.

* [**ScdCapacitiveNetAlgo**](https://wizard.fi.infn.it/herd/software/doxygen/master/classHerd_1_1ScdCapacitiveNeAlgo.html)
This algorithm applies the capacitive net to the SCD hits (after drift-diffusion, or geometric digitization).
It corresponds to a call to SiliconDetectorCapacitiveNetAlgo with the `scd` detector name.

* [**SiliconDetectorBondingDigitizerAlgo**](https://wizard.fi.infn.it/herd/software/doxygen/master/classHerd_1_1SiliconDetectorBondingDigitizerAlgo.html)
This algorithm creates ladders from the single Si wafers used in the Monte Carlo simulation by summing up the energy releases in those wafer strips that are bond
together to form a ladder. The ladder is defined in terms of an algorithm parameter specifying how many wafers along the wafer main segmentation direction are 
to be bonded together; see [the data model section](Data-model.md#geometry-parameters) for a description of segmentation directions for silicon detectors.

**NOTE**: this algorithm cannot be used directly in analysis jobs; use either StkBondingDigitizerAlgo or ScdBondingDigitizerAlgo (see below).

* [**StkBondingDigitizerAlgo**](https://wizard.fi.infn.it/herd/software/doxygen/master/classHerd_1_1StkBondingDigitizerAlgo.html)
This algorithm bonds the STK hits as explained for SiliconDetectorBondingDigitizerAlgo (see above).

* [**ScBondingDigitizerAlgo**](https://wizard.fi.infn.it/herd/software/doxygen/master/classHerd_1_1ScdBondingDigitizerAlgo.html)
This algorithm bonds the SCD hits as explained for SiliconDetectorBondingDigitizerAlgo (see above).

* [**PsdGeometricDigitizerAlgo**](https://wizard.fi.infn.it/herd/software/doxygen/master/classHerd_1_1PsdGeometricDigitizerAlgo.html)
The Monte Carlo geometry is built with very small PSD elements (bars or tiles), which are grouped together by this algorithm in order to produce hits on bigger (and more realistic) detector elements. Given the aggregation factors, the energy releases on neighbouring tiles/bars are added and assigned to a new hit corresponding to the set of grouped hits. The aggregated hits and the geometry parameters for the "aggregated PSD detector" are pushed to the data stores without modifying the original ones.

* [**FitDigitizerAlgo**](https://wizard.fi.infn.it/herd/software/doxygen/master/classHerd_1_1FitDigitizerAlgo.html)
This algorithm digitizes the FIT particle hits, as originally developed by Junjing Wang, it can simulate noise and channel crosstalk of SiPMs. Since the FIT in the simulation is just made of monolythical layers and that this digitization is deeply tied to the way SiPMs are applied to the mats, this algorithm is also the one that specifies how many mats are placed for each layer. The default parameters are the ones in the original Geneva implementation. This algorithm also provides the FitChannelInfo collection tied to the digitization parameters used.

* [**CaloPDDigitizerAlgo**](https://wizard.fi.infn.it/herd/software/doxygen/master/classHerd_1_1CaloPDDigitizerAlgo.html)
This algorithm digitizes the calo hit according to the photodiode (PD) read-out; it is based on the HIDRA2 front-end electronics. It use parameters stored inside CaloPDChannelInfo objects to simulated the signal obtained with the PD read-out. It simulates the noise of different gain range of the electronics, the saturation of the latter. It stores the ADC digitized signals inside two CaloHits object (one for large PDs and one for small PDs). It also stores additional information regarding the gain and saturation of each channel inside CaloPDEventChannelInfo objects.

* [**CaloPDChannelInfoAlgo**](https://wizard.fi.infn.it/herd/software/doxygen/master/classHerd_1_1CaloPDChannelInfoAlgo.html)
This algorithm creates several parameters regarding the calo read-out with PD. These parameters (e.g. noise, pedestal value, saturation level, MIP peak) are mainly used by the calo digitizer. Parameters are different channel by channel: for each channel a value is calculated starting from a normal distribution and a random number generator. Mean and standard deviation of each normal distribution is a parameter of the algorithm, those parameters should carefully selected to replicate a real calorimeter-PD system. The default values are now based on laboratory tests of the HIDR2 system with Excelitas PDs. The large PD is the new Excelitas prototype (no name so far); the small PD is VTP9412.

* [**CaloPDZeroSuppressionAlgo**](https://wizard.fi.infn.it/herd/software/doxygen/master/classHerd_1_1CaloPDZeroSuppressionAlgo.html)
This algorithm apllies a simple zero suppression algorithm on the calo hits according to the PD read-out. It rejects signals above give thresholds: the latter are computed by multiplying the algorithm parameter (the default is 3.) by the noise of the corresponding channel. Moreover all the signals in low gain are accepted.

* [**CaloPDCalibrationAlgo**](https://wizard.fi.infn.it/herd/software/doxygen/master/classHerd_1_1CaloPDCalibrationAlgo.html)
This algorithm converts the digitized the calo PD hits from ADC to GeV. It stores the information inside three objects, one for LPD and one for SPD, and one which contains the LPD hit if LPD is not saturated, SPD hit otherwise. The third option represents a preliminary stitching procedure. The algorithm option can switch on/off the creation of those three vectors.

# **Geometric algorithms**
These algorithms compute information regarding a given track, taking into account the detector geometry e.g. the intersections between a track and the STK. Only the MC true track is used so far.

* [**CaloTrackInfoAlgo**](https://wizard.fi.infn.it/herd/software/doxygen/master/classHerd_1_1CaloTrackInfoAlgo.html)
The algorithm computes the entrance point, the exit point and the track length in Calo. The track length in unit of radiation length is approximated considering the mean fraction of active material for each projections, passive material are not taken into account so far.

* [**StkIntersectionsAlgo**](https://wizard.fi.infn.it/herd/software/doxygen/master/classHerd_1_1StkIntersectionsAlgo.html)
The algorithm computes the intersections between a track and the STK layers. It also computes the track length in [cm] while the track length in [X0] is not filled so far.

* [**CaloAcceptanceCut**](https://wizard.fi.infn.it/herd/software/doxygen/master/classHerd_1_1CaloAcceptanceCut.html)
The algorithm selects particles which hit the Calo faces and have a track length greater than a given threshold. The default valid entrance surface of the Calo are all the faces excluding the bottom but both the valid entrance surfaces and the minimum track length can be configured. This algorithm need the object computed by CaloTrackInfoAlgo.

* [**StkIntersectionsCut**](https://wizard.fi.infn.it/herd/software/doxygen/master/classHerd_1_1StkIntersectionsCut.html)
This algorithm rejects events which have a number of intersections between a track and the STK minor of a given threshold. The latter can be configured.

* [**PolarAngleCut**](https://wizard.fi.infn.it/herd/software/doxygen/master/classHerd_1_1PolarAngleCut.html)
This algorithm rejects events which have the polar angle grater than a give threshold. The latter can be configured.

# **Tracking algorithms**
These algorithms reconstruct particle tracks from the hits in the detector.

* [**HoughFinder2DAlgo**](https://wizard.fi.infn.it/herd/software/doxygen/master/classHerd_1_1HoughFinder2DAlgo.html)
Standalone track finder algorithm based on the Hough transform algorithm. It operates on single 2D views and reconstructs the projections of the 3D track on the 2D views rather than the full 3D track. The algorithm takes advantage of all the STK and SCD layers, combining the clusters from different sides when a track crosses more than one layer. Currently it operates on all the STK and SCD clusters, so it is inefficient and slow for showering particles.

* [**PcaCaloAxisTrackingAlgo**](https://wizard.fi.infn.it/herd/software/doxygen/master/classHerd_1_1PcaCaloAxisTrackingAlgo.html)
Standalone Calo algorithm that reconstructs the main axis of the energy deposit and its geometrical properties. It operates on calorimeter clusters (hit collections) produced by clustering algorithms or on the full hit collection of the Calo, based on the user input. The algorithm first evaluates the energy deposit centroid (i.e. the energy barycentre) and  it uses the Principal Component Analysis technique that evaluates the three eigenvectors of the hit covariance matrix around the energy centroid. The three eigenvectors define the three main axes of the Calo shower, ranked by highest to lowest eigenvalue. The first axis (highest eigenvalue) is the best estimation of the shower axis. The remaining eigenvectors are the best estimates of the transversal axes. The result of the PcaCaloAxisTrackingAlgo is stored in the CaloAxes collection of CaloAxis objects.

# **Display algorithms**
These algorithms do not process data but rather they display it in graphical windows.

* [**HERDward**](https://wizard.fi.infn.it/herd/software/doxygen/master/classHerd_1_1HERDward.html)
The general-purpose display algorithm. Still in development, it currently shows the tracks reconstructed by HoughFinder2DAlgo (in yellow), the primary particle trajectory (in red, obtained from the `MCTruth`), the projections of the PSD, SCD, STK or FIT hits, and of the calorimeter shower.

# **Trigger algorithms**
These algorithms implement the different steps in the trigger logic, from the computation of the relevant quantities or variables (trigger inputs) for each subdetector, the comparison of these values with thresholds to produce flags (trigger flags) and, finally, the use of trigger flags to decide whether a trigger is fired or not according to its definition (trigger patterns)

* [**CaloPMTTriggerComputerAlgo**](https://wizard.fi.infn.it/herd/software/doxygen/master/classHerd_1_1CaloPMTTriggerComputerAlgo.html)
This algorithm computes the total energy deposited in Calo and the energy deposited in each trigger region from the information of caloHitsMC and caloGeoParams. This information is contained in the CaloPMTTriggerInputs dataobject, which is filled and stored for the subsequent steps in the trigger logic.

* [**CaloPMTTriggerComparatorAlgo**](https://wizard.fi.infn.it/herd/software/doxygen/master/classHerd_1_1CaloPMTTriggerComparatorAlgo.html)
This algorithm uses the total energy in Calo and the energy deposited in each trigger region and compares their value with the corresponding thresholds for the high energy, unbiased and low energy gamma triggers. In particular, it checks if the total energy is above the threshold for high energy, and if there is at least one trigger region with energies above the threshold for unbiased or low energy gamma. Thresholds are defined as tunable parameters, so they can be changed from a job configuration file. As a result of the comparisons, a CaloPMTTriggerFlags dataobject is filled and stored, with the corresponding bits set to true or false in each case.

* [**PsdTriggerComputerAlgo**](https://wizard.fi.infn.it/herd/software/doxygen/master/classHerd_1_1PsdTriggerComputerAlgo.html)
This algorithm computes the energy deposited in the top and lateral sides of the PSD, from the information of psdHitsMC and psdHitsCollMC. This information is contained in the PsdTriggerInputs dataobject, which is filled and stored for the subsequent steps in the trigger logic.

* [**PsdTriggerComparatorAlgo**](https://wizard.fi.infn.it/herd/software/doxygen/master/classHerd_1_1PsdTriggerComparatorAlgo.html)
This algorithm uses the energy deposited in the top and lateral sides of the PSD and compares their value with the corresponding thresholds for the low energy gamma trigger to check whether the veto condition is satisfied or not. As a result of the comparison, a PsdTriggerFlags dataobject is filled and stored, with the corresponding bit set to true or false.

* [**HighEnergyTriggerCut**](https://wizard.fi.infn.it/herd/software/doxygen/master/classHerd_1_1HighEnergyTriggerCut.html)
This algorithm gets the CaloPMT trigger flags and checks that the bit corresponding to the total energy deposition in Calo above the threshold is true or false and sets the boolean for the HE trigger pattern accordingly.

* [**UnbiasedTriggerCut**](https://wizard.fi.infn.it/herd/software/doxygen/master/classHerd_1_1UnbiasedTriggerCut.html)
This algorithm gets the CaloPMT trigger flags and checks that the bit corresponding to having at least one CaloPMT trigger region with energy deposition above the threshold is set to true or false, and sets the boolean for the UNB trigger pattern accordingly.

* [**LowEnergyGammaTriggerCut**](https://wizard.fi.infn.it/herd/software/doxygen/master/classHerd_1_1LowEnergyGammaTriggerCut.html)
This algorithm gets the CaloPMT and Psd trigger flags and checks whether there is at least one CaloPMT trigger region with energy above a threshold and Psd veto. Then, it sets the boolean for the LEG trigger pattern accordingly.
