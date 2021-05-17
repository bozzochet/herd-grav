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

HerdSoftware bugs are tracked as [GitLab issues](https://git.recas.ba.infn.it/herd/HerdSoftware/issues). The best way to report a bug is to open an issue: in this way all the developers will be notified, there will be the possibility to publicly discuss the issue, progresses in fixing the issue will be tracked, and after the fix a log of the process will remain for future reference. **It is therefore strongly suggested to use the issue tracker to report bugs**.

**To open a bug issue**: go to the [Issues](https://git.recas.ba.infn.it/herd/HerdSoftware/issues) section on GitLab, click on the "New issue" green button on the top-right corner of the page and fill the forms.

[Open bugs](https://git.recas.ba.infn.it/herd/HerdSoftware/issues?scope=all&utf8=%E2%9C%93&state=opened&label_name[]=Bug)  
[Closed bugs](https://git.recas.ba.infn.it/herd/HerdSoftware/issues?scope=all&utf8=%E2%9C%93&state=closed&label_name[]=Bug)

# Best practices
When opening a bug issue, there are some best practices that helps in fixing the bug:

* **Check if a similar bug has already been reported**  
Before opening a bug report, check if someone else already did it. You can have an overview of open bug reports from the "Bug" board in the [issue board](https://git.recas.ba.infn.it/herd/HerdSoftware/boards). Try to avoid duplicate bug reports; but if you find an open bug which looks similar to yours, and you are unsure whether it is really the same or not, then open your own report: a duplicate report is better than no report at all.

* **Select the `Bug-report` template**
There is a template for bug reporting issues to guide you in the description, make sure to select it in the "Description" dropdown menu.

* **Choose a meaningful title**  
The title of the issue is useful to quickly understand the topic when reading it among the others in the issue board. Use a descriptive title and avoid ones like "Bug in HerdSoftware" or "HerdSoftware crashes" which provide no insight. A meaningful title will also help other people affected by the same bug to find the bug report.

* **Describe the bug in details**  
To fix a bug, a developer must understand what's going on. A detailed description of the wrong behavior of the system, what it looks like (a segmentation fault, a wrong output etc.), any guess about what could probably cause the bug are all useful information.

* **Provide information to reproduce the bug**  
To fix a bug, a developer must be able to understand the context where it manifests itself. Ideally, the developer should be able to reproduce the bug on his system from the information reported in the issue. The reporter should then describe in details what to do to reproduce the bug (e.g. which program to launch, which parameters or configuration files to use, which version of the software, which operating system etc.) and provide any log that can contain information about the bug (stack traces, error messages etc.).

* **Label the issue as ~Bug**  
The issue tracker is used not only for bugs but also for planning regular development, so it is important to flag the bug report issues in order to put them in evidence. Before submitting the issue, assign the ~Bug label (and possibly also the ~"To Do" label) using the "Labels" drop-down menu on the bottom of the issue opening page, just above the "Submit issue" button.

* **Eventually, assign the issue to a developer**
If prior to opening the issue you discussed about the bug with a developer, and this developer is willing to fix the bug, then assign the issue to that developer by selecting him in the `Assignee` menu box above the `submit issue` button. This allows for other developers to know that there is already one of them in charge of the issue, and that no action is needed from them.

* **Follow the issue**  
Opening a bug issue is not a fire-and-forget process. Developers might need to interact with the reporter in order to be able to fix the issue, and will post comments and requests for information on the issue page. Visit the issue regularly after opening it; GitLab will also notify you via email about any event related to the issue.

# Do not be afraid to open a bug issue
Don't be scared about the above list: if you miss something that is important then the developer in charge of fixing the bug will notify you, and you can provide the missing details later.  

Do not worry if you open an issue when a similar one has already been opened: duplicate issues are easily handled, and are far better than no issue at all.

The issue tracker is a useful tool, and developers make an effort to exploit its functionalities since the benefits are worth the effort; opening a bug issue instead of dropping an email is the best (and most appreciated) way to start tackling a bug.
