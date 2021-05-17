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

**Guideline**: use the issue board extensively for planning development and bug fixing
* Open an issue for every development/bug
* Open a milestone for large development goals

---

The [GitLab issue board](https://git.recas.ba.infn.it/herd/HerdSoftware/boards) is a convenient tool for planning and tracking the development and bug fixing efforts. It provides a concise way to visualize:
* the planned activities ~"To Do"
* the currently ongoing activities ~Doing
* the open bug reports ~Bug
* the urgent tasks ~Urgent

When used consistently and extensively by all the developers, it allows e.g. a new developer to quickly identify a topic where he/she could contribute or to keep track of modifications done during time. Opening an issue is also useful to book a future development that cannot be done at the moment, for example for lack of workforce, to avoid forgetting about it.

When used as a bug tracker, i.e. for issues labeled as ~Bug, it allows for keeping track of current bugs in the code and to search for fixed ones, should a fixed problem appear again.

Each issue has a page where comments can be left. Discussions about how to implement a new feature or how to reproduce a bug can conveniently happen in the same page where the issue is described. This way of discussing a development/bug is better than others (private e-mails, chat, direct speech): the discussion can be easily focused on the issue without interleaving off-topic diversions (as frequently happens e.g. in group chats), is open to everybody and will remain easily accessible in a known place also after the issue has been closed (no more digging into a full mailbox to recover that discussion about that feature that happened two or three years ago).

The aim of issues (and milestones) is to improve the sharing of information among the developers; everybody is thus encouraged to get familiar with this GitLab feature.

# Opening an issue
Opening an issue is almost the same than [opening a bug report](How-to/Report-a-bug.md). In fact, bugs are simply issues with a ~Bug label. For development issues it is useful to provide a description of what has to be implemented and eventually a small TODO list. It is also useful to add appropriate labels to the issue using the "Labels" dropdown menu in the "New issue" page. Add ~"To Do" if you don't plan to start working on the issue immediately, or ~Doing otherwise.

An issue should be opened for any development effort, regardless of the size, even for those that are carried by a single person in a couple of hours. With issues there will be a record of what has been done, and in the future those who will need to recover this information will be able to do so.

Open an issue when you have an idea about a development which you cannot do immediately. This will avoid that the idea gets lost as time passes by, let the others know what's to be done and possibly attract a developer who would step up to implement the feature.

# Working on an issue
A developer wishing to take charge of an open issue (be it an open bug to be fixed or a development which did not start yet) should assign the issue to him/herself, to notify other developers that the issue has now someone who takes care of it. To do so, go to the issue page and click on the "assign yourself" link in the "Assignee" section on top of the right bar. This section will show the current assignee if the issue has already been assigned to someone.

When the developer starts to work on an issue it should give it the ~Doing label, and remove ~"To Do". This can be done using the "Edit" link in the "Labels" section of the right bar of the issue page. Other developers will thus know that the assignee actually started tackling the issue.

# Closing an issue
When the work on the issue is completed (the bug is fixed or the development is complete) the developer should remove the ~Doing label and close the issue By means of the yellow "Close issue" button on the bottom of the issue page. The issue will be removed from the open ones and will appear in the board of "Closed" issues. It is often appropriate to leave a comment before closing the issue, briefly describing what has been done. If an issue is closed by a certain commit it is useful to report the commit hash in the issue comment as done [here](https://git.recas.ba.infn.it/herd/HerdSoftware/issues/16#note_1611). Alternatively, when committing the final code modifications one can mention the related issue in the commit comment by using the # followed by the issue number, as shown [here](https://git.recas.ba.infn.it/herd/HerdSoftware/commit/41a6305426c7a9de2ed8f46c4e7c5b8b2a021a64) (see the commit comment on top). Mentioning a commit in a related issue comment and vice versa allows GitLab to automatically create links that are very useful when reviewing the code modifications.

# Grouping issues in milestones
Issues are best suited for small, self-contained coding efforts. When planning a large development, which involves many, possibly weakly-related code modifications, a milestone is a better option. A milestone is, roughly speaking, a group of issues related to a certain development goal. Creating a milestone and then breaking the development it needs into small, possibly unrelated issues that can be separately tackled by different developers is a useful exercise that will help in understanding how to efficiently work in parallel to optimize the development speed.

Milestones can be opened similarly to issues, from the [milestones page](https://git.recas.ba.infn.it/herd/HerdSoftware/-/milestones). Existing or new issues can then be added to the milestone, and when all the issues are closed the milestone can be closed too.

An example of completed milestone is available [here](https://git.recas.ba.infn.it/herd/HerdSoftware/-/milestones/1).
