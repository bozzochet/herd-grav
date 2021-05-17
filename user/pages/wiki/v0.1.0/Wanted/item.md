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

# <img src="https://images-na.ssl-images-amazon.com/images/I/61mvCqNQjwL._AC_.jpg" width="200">

A list of hot features seeking for an implementer. Pick one, open an issue and start coding.

## Tracking algorithm for gamma rays and showering particles
A dedicated tracking algorithm for gamma rays and more in general for particles that generate showers in the
tungsten layers of the tracking system. The high occupancy in the lower layers due to the shower needs to be
studied and treated properly, likely with an approach similar to those used for tracking with calorimeters.
Optimizations like the restriction of the tracking region using the calorimeter track would proably be
needed for optimal performance and computing efficiency.

# Done

## Implementation of the TRD in the simulation geometry (done by N. Mori)
Introduce the TRD in the parametric geometry. The TRD will be used for energy scale calibration, and will be placed 
on a lateral face, most likely in the outmost part of the instrument. It will have an impact on the charge ID 
performance (due to increased ion fragmentation before the ion hits the SCD) and on the trigger that must be studied in details.

## Digitization algorithm for the calorimeter (done by L. Pacini)
Add the effects of the electronic readout to the simulated calorimeter signals. These effects might be relevant
for stdying important performance figures, e.g. the trigger for penetrating particles used for calibration. A
double readout system consisting of (WLS fibers + IsCMOS camera) and of photodiodes is currently foreseen for
the calo, and digitization for both systems have to be implemented.
