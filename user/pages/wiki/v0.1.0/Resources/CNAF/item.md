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

# CNAF computing resources

The CNAF computing center is run by INFN and is located in Bologna (Italy). It
provides computing and storage resources for HERD. The access is mainly
intended for INFN people, but it is possible to obtain access also for
colleagues from other institutes.

## Get access

CNAF resources can be accessed via ssh. It is necessary to log in first on a 
gateway machine (`bastion.cnaf.infn.it`), and from there log in to the HERD
frontend machine (`ui-herd.cr.cnaf.infn.it`). To require an account for both the
machines, follow the instructions in the `How to get an account at CNAF`
section at [this page](https://www.cnaf.infn.it/en/users-faqs). When filling
the request form:

1. please indicate as the reason of the request:  

```
Access to the computing resources of the HERD experiment (including the ui-herd frontend machine)
```
2. as contact person, please indicate one of the following:

```
Valerio Formato (valerio.formato@roma2.infn.it)
Nicola Mori (mori@fi.infn.it)
```
3. remember to fill also the request for an account on the `bastion` host (2nd
page).

You will be notified via email when the acounts will be ready

## Connect to the HERD frontend machine

In order to connect to `ui-herd`, you first need to connect to bastion:

```bash
$ ssh yourusername@bastion.cnaf.infn.it
```

and then from bastion to ui-herd:

```bash
$ ssh yourusername@ui-herd
```

### Configuring a SSH tunnel with SSH key pair

Key based authentication gives the user the ability to login without a password and to set a `ssh tunnel` to directly login to the HERD frontend machine bypassing bastion. To authenticate using key based authentication, a key pair needs to be generated on the client (the user machine) and their public information need to be transmitted and stored on the server machines (`bastion` and `ui-herd`).

Following are the steps to allow a password-less login to `bastion` portal and `ui-herd` machines.

On the home folder in the client machine:
```bash
ssh-keygen
````
will generate a set of pair in the .ssh/ folder. The `id_rsa` is the local private copy of the key which must stay in the client machine and not be copied elsewhere. The `id_rsa.pub` is the public copy of the key, whose information must be copied in the server machines.

Copy the public key on the home folder of the `bastion` and `ui-herd` machines and issue the following command
```bash
cat id_rsa.pub >> .ssh/authorized_keys
```
which will copy the content of the public key inside the list of trusted client machines. After this command, the user will be able to login from the selected client machines without password request.

To achieve a direct ssh link to the `ui-herd` machine, a ssh-tunnel rule can now be set. Add the following lines in your .ssh/config file

```bash
Host bastion
     User <your-cnaf-username>
     HostName bastion.cnaf.infn.it

Host ui-herd
     Hostname ui-herd
     User <your-cnaf-username>
     ProxyCommand ssh -XY <your-cnaf-username>@bastion.cnaf.infn.it nc %h %p
```

If properly set, issuing the command
```bash
ssh ui-herd
```
from the client machine will allow password-less login to `ui-herd` bypassing the login to the `bastion` portal.
## Environment

The experiment software is installed in `/opt/exp_software/herd/install/`. The 
folder contains different `setenvHERD` files for different environments
installed on different dates (the newer the installation date, the more
up-to-date the environment). The user can choose which environment to use by
sourcing the relative `setenvHERD` file; the versions of each package are
written inside each `setenvHERD` file.

### HerdSoftware master environment

Among the environments installed in `/opt/exp_software/herd/install/` there is
also a `master` environment. This is kept up-to-date with the current master
version of HerdSoftware, and can then be used to test the latest available
features. It is automatically updated nightly, so keep in mind that it can
change from one day to another without notice.

### HerdSoftware development environment

The `setenvHERD` files set up a complete computing environmet including
HerdSoftware. The HerdSoftware installation folders are added to the relevant
environment variables (e.g. `LD_LIBRARY_PATH`) to be able to use the installed
version. This can create conflicts when the user wants to use a development
version of HerdSoftware containing his/her modification. In this case an
environment clean of any HerdSoftware setting should be used. This can be
achieved by either sourcing the `hs-dev` script after the `setenvHERD` file,
e.g.:

```bash
$ source /opt/exp_software/herd/install/setenvHERD_200901.sh
$ source /opt/exp_software/herd/scripts/hs-dev
```

or by directly sourcing both the files:

```bash
$ source /opt/exp_software/herd/scripts/hs-dev /opt/exp_software/herd/install/setenvHERD_200901.sh
```

A handy setting that can be put in the `.bashrc` file is:

```bash
alias source-hs-dev="source /opt/exp_software/herd/scripts/hs-dev"
```

so that one can then simply write:

```bash
$ source-hs-dev /opt/exp_software/herd/install/setenvHERD_200901.sh
```

for setting up a development environment for HerdSoftware.

### Automatic code formatting
Developers working at CNAF should enable the automatic code formatting reminder by adding the `clang-format` executable path to the environment as described [here](Developer's-manual/Code-formatting.md#automatic-reminder-for-code-formatting) for the CentOS 7 Linux distribution (the needed package is already installed, it is sufficient to modify the `.bashrc` as described).

## Submittings jobs

Job submission to the computing cluster is strictly required in case of large computing resource needs. Job submission is also strongly encouraged for data processing in order to keep the UI machine resources as highly available as possible to other users.

Job submission is managed via the HTCondor infrastructure. The user must instruct the service about the commands to be executed on the nodes and about the I/O information (input files, output directories, etc...). The service will schedule the job to be run based on the needed resources and the concurrent jobs pending on the cluster.

Managing job submission via HTCondor is very flexible and can reach high level of complexities. We report here only the basic instructions for simple job submission. Details about further customization are available, for example, [here](https://www.recas-bari.it/images/manuali/ITAManualeHTCondor.pdf)
To submit a job, HTCondor requires a `submit description` or `submit` file, a text file that specifies the properties of the job to be submitted and the location of the `jobfile`, a file that contains all the instructions to be run by the computing node.

A basic submit and job example files look as follows

```bash
#All comments start with hash
#filename: submit.sub
universe = vanilla
executable = /storage/gpfs_data/herd/username/path/to/jobfile.job
output = /storage/gpfs_data/herd/username/path/to/outfile.out
error = /storage/gpfs_data/herd/username/path/to/errorfile.err
log = /storage/gpfs_data/herd/username/path/to/logfile.err
ShouldTransferFiles = YES
WhenToTransferOutput = ON_EXIT
queue 1
```

```bash
#filename: jobfile.job
#!/bin/bash                                                                                                                                                                       
source /path/to/file/to/be/sourced.sh
/storage/gpfs_data/herd/username/path/to/executable [options]
```

To submit the job to the cluster, the user should run the following command
```bash
condor_submit -spool -name sn-01.cr.cnaf.infn.it /path/to/subfile.sub
```
Each job is assigned an unique `ID` that can be used to manage it during and after completion.

The `output` file will contain the result of the stdout produced during the job. The `error` file will contain the result of the stderr produced during the job. The `log` file will contain information and statistics about the job. These files are available in the specified only after a user request, that may be triggered by the following command after the job is finished

```bash
condor_transfer_data ID
```

### Monitoring jobs
A global graphical monitoring interface for the HTCondor cluster at CNAF is available at [this page](https://mon-tier1.cr.cnaf.infn.it/d/DPv3p6zGz/htc-monitoring?orgId=2). Specific status for the `herd` resources can be selected via the `queue` menu.

Several commands are also available to the users to monitor the global status of user jobs and to monitor the status of specific jobs, uniquely identified by their ID. A list of useful monitoring commands is available [here](https://www.recas-bari.it/images/manuali/ITAManualeHTCondor.pdf) 

### Useful tips for job submission

1. The UI user home folder `/home/HERD/username` is NOT available in the computing nodes. This means that all the input and output resources, as well as the software, should be located in folders that are available in the nodes like, for example, `/storage/gpfs_data/herd/username` which can be used as working directory for the data analysis.

## Support

### CNAF IT staff
Support from CNAF staff can be asked by writing to `user-support@lists.cnaf.infn.it`.

### Mailing list
The mailing list `herd_cnaf_users@lists.infn.it` is used for internal announcements related to CNAF. Subscription can be asked by writing to `mori@fi.infn.it` or `matteo.duranti@infn.it`.

### Discord channel
The `cnaf` channel on the HERD Discord server is used for internal discussion about issues related to CNAF. Subscribe to the channel to follow the discussion.
