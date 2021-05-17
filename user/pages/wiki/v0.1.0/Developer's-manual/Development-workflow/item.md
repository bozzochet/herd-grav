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

**Guideline**: follow the development workflow
* Be familiar with the HerdSoftware workflow (ask if you are unsure) 

---

Concurrent software development needs for tools and rules. When many persons modify the same code base at the same time there is a vast set of problems that inevitably happen. A tool like [git](Developer's-manual/Tools.md#git) is of great help in mitigating some of these problems, but some other issues require that the members of the development team agree on adopting rules and a development workflow to minimize mutual disruptive interactions.

In the following, the code development workflow used for HerdSoftware is described.

# Development workflow
Developers are asked to adopt a consistent workflow, in order to ease the code
review and the integration in the mainline version. When starting to develop a
new feature in HerdSoftware, these are the steps that a developer is asked to
follow.

## Open an issue
As detailed [here](Developer's-manual/Tackling-issues.md), issues are used to keep track of
developments. When a new development starts, open a new issue with a proper
description and labels.

<img src="../objects/images/workflow/OpenIssue.png" width="800">

## Create a branch
New features sometimes break old code. This could be a big problem when many
developers modify the code at the same time, since they may end up breaking each
other's code continuously. To avoid this, git provides the notion of 
[branch](https://git-scm.com/book/en/v2/Git-Branching-Branches-in-a-Nutshell):
code modifications committed in a given branch do not affect those committed in
another branch. For this reason, each developer should commit his/her
new code related to an issue to the associated branch.

To open a new branch associate to an issue:
1. open the issue in the browser
2. in the issue page, click on the green arrow on the left of `Create merge request`
and then on `Create branch` in the dropdown panel  
<img src="../objects/images/workflow/OpenBranch1.png" width="800">  

3. Click on the `Create branch` green button that appeared after completing the
previous step. Eventually, if you don't want to start the new development from
the current master branch but rather from another branch or from a tagged commit,
write the name of the desired staring branch in the `Source (branch or tag)`
text box before creating the branch.  
<img src="../objects/images/workflow/OpenBranch2.png" width="800">

This procedure will create a branch whose name will be composed by the number of
the issue followed by its title; in the example, it is 
`209-add-a-new-fantastic-algorithm-doing-nice-computations-just-an-example-of-a-real-issue`
(yes, branch names can become very long if the issue title is very verbose, but
prefer descriptive titles and don't use short and meaningless titles just to 
obtain short branch names).

 
## Develop, commit and push
After the branch has been created on the remote repository it can be imported 
locally. From inside the HerdSoftware folder: 

```bash
$ git fetch
$ git checkout 209-add-a-new-fantastic-algorithm-doing-nice-computations-just-an-example-of-a-real-issue
```

After this the development can start with the usual code-and-commit cycle. About
the `when should I commit my code?` question: there are no well-defined notions
of a "good commit"; for HerdSoftware, it is desirable that each commit can be
compiled without errors (e.g. to help in finding bugs with
[git bisect](https://git-scm.com/docs/git-bisect)).Try to give the commit a 
meaningful title and a description in order to help in understanding what
modifications the commit introduces. Ideally, a commit should be as small as
possible: this helps in examining the modifications introduced by the commit.
Avoid big commits including any sort of unrelated modifications whenever it's
possible, and try to break the whole set of modifications into a series of small
commits, each one focusing on one aspect. A common commit mesage style is to put
a brief description on the first line, then leave a blank line and then add a
more detailed description when needed (take a look at the messages of existing
commits). 

Local commits should be pushed from time to time to the remote repository. Again,
there's no strict rule for defining when to push; usually it's not needed to
push each single commit, and it is sufficient to push when a certain amount of
commits have been created. Remember that pushing to the remote can serve also as
a backup. Keep also in mind that after pushing it is 
[strongly recommended](https://stackoverflow.com/questions/39098811/what-happens-if-i-rebase-after-pushing)
to avoid [rewriting the commit history](https://git-scm.com/book/en/v2/Git-Tools-Rewriting-History),
so in case you realize that something is screwed in your commits and you pushed
too frequently then you might have troubles in fixing the problem. 

It might also be useful to keep the issue updated as the development proceeds:  
<img src="../objects/images/workflow/UpdateIssue.png" width="800">

When implementing new features or modifying existing code, a developer is asked to
[write tests](Developer's-manual/Writing-tests.md). It is recommended to run tests
manually before committing new features (to avoid committing bugged code) or at
least before pushing. The tests will be automatically executed by the 
[continuous integration tool](Developer's-manual/Writing-tests.md#continuous-integration)
on each push, and the developer will be notified via email in case they fail.

Another task requested to the developer is to keep the wiki documentation up
to date with the new features and improvements. For example, when developing
a new algorithm pushing new data objects to the data store, the 
[Algorithms](User's-manual/Algorithms.md) and [Data-model](User's-manual/Data-model.md)
wiki pages should be updated accordingly, and so on. 

The wiki is hosted in [its own repository](https://git.recas.ba.infn.it/herd/HerdSoftwareWiki).
The developer should clone it on his/her machine, open a branch from command
line and add the documentation for the new features he/she is working on this
branch:

```bash
git clone git@git.recas.ba.infn.it:herd/HerdSoftwareWiki.git
cd HerdSoftware.wiki
git checkout -b 209-add-a-new-fantastic-algorithm-doing-nice-computations-just-an-example-of-a-real-issue
```
It is a good practice to call the documentation branch in the wiki repository
as the corresponding development branch in the code repository. After
committing the changes the developer can push the issue documentation branch to
the wiki repository. The issue documentation will be merged at the end of the
development, together with code (see below). 

## Create a merge request
The merge request (MR) is the Gitlab tool for asking the project maintainers to 
include the code produced by a developer in a development branch into the
mainline master version. The developer can in any moment create a merge request
for a given branch:  
<img src="../objects/images/workflow/OpenMR1.png" width="800">

A MR is the place where code is reviewed and discussed, so a developer
might want to open it before the development is finished to get early opinions
and advices. For this reason there are two kind of merge requests: for 
work-in-progress (WIP) developments and for finished developments (ready MR).
The kind can be chosen when opening the MR by using an appropriate first word in
the title: if it is `WIP` or `Draft` then it will be a work-in-progress merge
request (WIP MR), otherwise it will be a ready MR. After selecting the MR kind,
it is useful to check the `Delete source branch when merge request is accepted`
check box and then open the request:   
<img src="../objects/images/workflow/OpenMR2.png" width="800">

Being for ongoing, unfinished developments, a WIP MR cannot be merged before it
is marked as ready. When the developer finishes the planned developments,
commits all his work and then pushes it then the MR can be marked as ready:  
<img src="../objects/images/workflow/MarkMRAsReady.png" width="800">

A MR in ready state flags that the developer believes that no additional work is
needed to address the initial issue.

## Code review process
In any moment the developer can ask for code review (both for a WIP MR or a 
ready MR) by assigning it to a reviewer:  
<img src="../objects/images/workflow/AssignMR.png" width="800">

The reviewer will be automatically notified that a MR has been assigned to
him/her, and can attach review comments on signle code portions or lines from
the MR web page:  
<img src="../objects/images/workflow/CommentMR.png" width="800">

The reviewer might ask the developer for several improvements and changes, 
ranging from code style to documentation, bugs or more efficient constructs.
The developer will be notified of the reviewer's comments. When the review work
is finished, the reviewer will assign the MR to the developer: this signals the
fact that the review is complete and the developer can start to implement the
requests and suggestions of the reviewer. The developer can also reply to the
comments of the reviewer on the MR web page, should additional discussion on a
given comment be necessary before taking an action. When the developer has
committed and pushed all the fixes and improvement the MR can be re-assigned to
the reviewer for another round of checks, and so on until the code is deemed
ready for being merged.

## Merge
After the code review process is finished the reviewer will merge the development
branch to the master branch of HerdSoftware, and also the issue documentation
branch to  the master branch of the wiki. At this point the MR and the issue
wil be closed, the new features will be available on the master version and the
new documentation will be visible on the wiki pages. 

