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

**Gudeline**: Document the code
* Use Doxygen comments for concise, fine-grained documentation
* Use README.md files or the the wiki for descriptive, behavioral documentation
* Update the documentation after making modifications to the code

---

Documentation is an essential part of the software. It serves as:
* introduction for newcomers
* reference for users and developers
* guidance for maintainers

It is common that the most active user and maintainer of a code portion is the one who wrote it; for this reason, writing documentation is often felt as a waste of time, since "I know how my code works". This might be true for some time after producing the initial version, but can become less evident when resuming a years-old code base for fixing a newly discovered bug, for example. In this situation, having a good documentation can save a fair amount of time; many times the person who benefits more from the documentation is the one that wrote it.

Even when a developer has good memory and never forgets a thing about his code, there is the need to provide guidance for other people who use the code; repeating the same instructions many times can easily require much more time than writing those instructions once and for all.

Writing code documentation is then a good practice that can also save time. Documentation is required for all the shared code parts in HerdSoftware. Developers are encouraged to write documentation together with the code, as much as possible, to avoid forgetting eventual relevant details and to make it available as soon as possible.

Below some ways to document the code are reported. Each applies to a different level of details, so they can be considered as complementary.

# Doxygen comments
The single components of each class (members-and-methods)-can-be-documented-by-means-of-[Doxygen-comments](Developer's-manual/Tools.md#doxygen). It is a very handy way to document the code while writing it. It also allows for a general description of the functionality of the class. Many HerdSoftware classes are already documented this way, so refer to the existing headers to get an overview about how to write Doxygen comments.

The Doxygen documentation automatically generated from comments in code is available [at this address](https://wizard.fi.infn.it/herd/software/doxygen).

# README.md files
Another way to document the code is the classic README file inside a code folder. In this way, a more coarse-grained documentation is usually produced, in the form of a description of what the code inside the folder does. eventually, per-file sections can be present to document the details of a single class.

When producing a README, please consider using the [Markdown syntax](https://spec.commonmark.org/) and use the .md extension for the file name. In this way, GitLab can render the README.md file in the Repository view, for a quick visualization of the documentation; see e.g. [the examples folder](https://git.recas.ba.infn.it/herd/HerdSoftware/tree/master/examples).

# Wiki pages
Another way to document the code is with wiki pages, hosted in the
[HerdSoftwareWiki](https://git.recas.ba.infn.it/herd/HerdSoftwareWiki) project.
The HerdSoftware wiki provides a common place to share information in general,
that can be used also for code documentation. It is usually best suited for
general descriptions like the one in the [data model page](User's-manual/Data-model.md),
but details can be added as well if needed/appropriate.

The wiki pages are written in [Markdown](https://spec.commonmark.org). The
pages can be modified directly from the Gitlab web editor / web IDE, or cloning
the wiki repository, editing it locally and then pushing the modifications.
