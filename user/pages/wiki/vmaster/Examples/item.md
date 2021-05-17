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

#  HerdSoftware examples

## Overview
The HerdSoftware examples are structured to provide a smooth introduction to the framework. They are located in the `examples` subfolder of the HerdSoftware code package. It is highly recommended to read the [HerdSoftware user's manual](../User's-manual/Table-of-contents.md) before reading the examples.
It is assumed that a complete software environment is present. Please refer to the [installation](../User's-manual/Download,-configure,-build-and-install.md) section of the HerdSoftware manual for setting up the environment.

This documentation is also available in the `examples` subfolder of HerdSoftware.

## Example 0: creation of Monte Carlo files
**Folder:** Ex00_produce-mc  
Configure and run a Monte Carlo simulation with GGS.  
See [Ex00: produce MC](Ex00--produce-MC.md)

## Example 1: digitization of Monte Carlo files
**Folder:** Ex01_digitize-mc  
This simple example shows how to define an analysis job by means of an EventAnalysys configuration file.  
See [Ex01: digitize MC](Ex01--digitize-MC.md)

## Example 2: analysis of digitized Monte Carlo files
**Folder:** Ex02_analyze-mc  
In this example an output file is read and new algorithms are created and used.  
See [Ex02: analyze MC](Ex02--analyze-MC.md)

## Example 3: native STK strips
**Folder:** Ex03_stk-strips  
Repeat Ex00 and Ex01 using native MC strips.
See [Ex03: STK native strips](Ex03--STK-strips.md)

## Example 4: display events from digitized Monte Carlo files
**Folder:** Ex04_display-events  
In this example events from an output file are displayed using HERDward.  
See [Ex04: display MC](Ex04--display-MC.md)

## Example 5: particle hits for the PSD
**Folder:** Ex05_psd-particle-hits  
Create and analyze MC files with particle hits for the PSD.  
See [Ex05: display MC](Ex05--PSD-particle-hits.md)

## Example 6: generate dictionaries for custom classes
**Folder:** Ex06_generate-dictionaries  
In this example an algorithm is used to fill a custom Hit class and write a collection of them on file.  
See [Ex06: generate dictionaries](Ex06--generate-dictionaries.md)

## Example 7: create a custom output
**Folder:** Ex07_custom-persistence  
Create a custom persistence service that writes output data in a custom format to a Root file.  
See [Ex07: custom persistence](Ex07--custom-persistence.md)

## Example 8: checking the consistency of the data model
**Folder:** Ex08_data-consistency-check  
In this example it is shown how to enable the data consistency check and what happens when inconsistencies are found.  
See [Ex08: data consistency check](Ex08--data-consistency-check.md)

## Example 9: simulation and digitization of the FIT
**Folder:** Ex09_using-the-FIT  
Repeat Ex00 and Ex01 using FIT instead of STK.  
See [Ex09: using the FIT](Ex09--fit.md)

## Example 10: simulation using CRMC hadronic physics engine
**Folder:** Ex10_crmc-hadronic-physics  
Configure and run a Monte Carlo simulation using the CRMC hadronic physics models.  
See [Ex10: CRMC hadronic physics](Ex10--CRMC-hadronic-physics.md)

## Example 11: simulation and analysis of the TRD
**Folder:** Ex11_trd  
Configure, run and analyze a Monte Carlo simulation of the TRD.  
See [Ex11: TRD](Ex11--TRD.md)

## Example 12: CSS
**Folder:** Ex12_css  
Run a MC simulation including the Chinese Space Station (CSS) structure in the simulation geometry.  
See [Ex12: CSS](Ex12--CSS.md)

## Example 13: Trigger
**Folder:** Ex13_trigger  
Use of trigger algorithms.  
See [Ex13: Trigger](Ex13--Trigger.md)
