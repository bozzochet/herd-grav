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

# Introduction
This page contains some proposals to dig deeper into HerdSoftware and
EventAnalysis. It is not necessary to understand deeply every aspect of the
framework to be productive, but after familiarizing with the basic aspects then
a little more effort in investigating some advanced features can shed light on
new and useful usages that might be of help in some cases. Take the following
as proposals to investigate some aspects that you might have not imagined while
learning the basics.

# Splitting jobs
Using the Root-based data provider and persistence service provided by
EventAnlaysis allows for splitting a data processing pipeline into several
pipelines. Suppose to have a pipeline made of four algorithms `A`, `B`, `C` and
`D`. A data provider `P` feeds the pipeline and a persistence service `S` saves
the products. Suppose now that for some reason you want to execute the first
part (algorithms `A` and `B`), save the data on file and then process the file
with the remaining algorithms (`C` and `D`). To do so, it is sufficient to
split the job configuration file in two configuration files:

1. the first one contains the data provider `P`, the algorithms `A` and `B`
   and a Root persistence with all the data objects needed by `C`, `D` and `S`
   booked for persistence. Running this job will produce a Root file 
   containing all the data objects that will be needed by the second stage;  
2. the second one containing a Root data provider connected to the output file
   of the first stage, the algorithms `C` and `D` and the persistence `P`.   

Running the two pipelines consecutively will produce the same output as running
the original pipeline, plus the intermediate file. 

The opposite is also true: two pipelines built to be run consecutively (i.e.
the second one using the output of the first one as input) can be merged into
a single pipeline. The pipelines of [example 01](Examples/Ex01:-digitize-MC.md)
and [example 02](Examples/Ex02:-analyze-MC.md) can be merged into a single
job reading a GGS output file, digitizing it and then running the analysis
algorithms directly on the data objects produced by the digitization 
algorithms rather than on the same objects read from a digitized file. Try it!

# Multiple I/O
Data providers provide objects requested by algorithms by reading them from
files. The underlying mechanism is:
* an algorithm asks the data store for a data object;
* if the store have the object (for example because a preceding algorithm 
  produced it) then it gives it to the requester algorithm;
* otherwise it asks the data provider for the object, and if the data provider
  provides this object then it is added to the store and then passed to the
  requester algorithm.
  
This mechanism is not limited to a single data provider. It is possible to add
more than one provider to the job by multiple `DataProvider` commands in the
configuration file, connecting them to different input files; when more than
one provider is present, the data store asks for a missing object sequentially
to all the configured providers, until one that provides it is found or all of
them have been queried with no success.

Similarly, more than one persistence service can be in use: with multiple
`PersistenceService` commands in the configuration file, multiple services can
be created and connected to different output files.

When using the Root-based data provider and persistence service provided by
EventAnalysis, this opens up for an intersting possibility, namely splitting
the output of data objects in multiple files and seamlessly reading them back.
Making reference to the example of the previous section, suppose that the first
split pipeline produces the objects `c` and `d`, which are to be processed by
the algorithms `C` and `D`, respectively, of the second split pipeline. One can
save `c` and `d` in a single file and then read it in the second pipeline; but
it is also possible to use two Root persistence services in the first split
pipeline to save `c` in one file and `d` in another (by booking each object in
just one persistence service) and then use two Root data providers in the
second split pipeline to read both files. When `C` will ask for `c`, the data
store will ask the first provider (suppose it is connected to the file
containing `c`), which will provide the object; when `D` will ask for `d`, the
data store will ask the first provider, which cannot provide `d`, so the second
provider will be queried and `d` will be provided and passed to `D`. This is a
very effective way of splitting big files into smaller ones. The effectiveness
is even more evident when you think that no modification to `A` or `B` is
needed to split the output, nor to `C` or `D` to read the split files: it is
sufficient to modify just the configuration files, and everything is handled 
automatically. Also, when writing an algorithm you don't have to worry about
where the data object you need comes from, either from an input file or several
split input files (or even produced by a preceding algorithm up in the 
pipeline): you simply ask for it, knowing that somehow the framework will
provide it.

Try to split the output of [example 01](Examples/Ex01:-digitize-MC.md) in several
files and use all of them in [example 02](Examples/Ex02:-analyze-MC.md)!
