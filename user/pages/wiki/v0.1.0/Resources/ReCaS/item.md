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

# ReCaS computing resources

The Bari ReCaS has been built by the University of Bari "Aldo Moro" and the National Institute of Nuclear Physics (INFN) in the framework of the ReCaS project (PON Research and Competitiveness 2007-2013 Notice 254/Ric). The access is mainly intended for University and INFN people, but it is possible to obtain access also for colleagues from other institutes.

## Get access

ReCaS resources can be accessed via ssh. It is necessary to log in on a frontend machine (`frontend.recas.ba.infn.it`). To require an account for the machine, follow the instructions in the `ReCas Bari - Access to Services` section at [this page](https://www.recas-bari.it/index.php/en/recas-bari-servizi-en). When filling the request form:

1. Research group or project name:

```
HERD
```
2. Reference person:

```
Fabio Gargano
```
3. E-mail of the reference person:

```
Fabio.Gargano@ba.infn.it
```
4. Service selection:

```
Account for access to ReCaS-Bari compute services (HTC/HPC)
```
5. SSH RSA PUBLIC KEY:

```
See the `configuring a SSH key pair` section
```
6. Activity description:

```
Simulation and data analysis for the HERD project
```

You will be notified via email when the accounts will be ready.

## Connect to the HERD frontend machine

In order to connect to ReCaS frontend machine you need to connect via ssh:

```bash
$ ssh yourusername@frontend.recas.ba.infn.it
```

### Configuring a SSH key pair

Key based authentication gives the user the ability to login without a password. To authenticate using key based authentication, a key pair needs to be generated on the client (the user machine) and their public information need to be transmitted and stored on the server machine (ReCaS).

Following are the steps to allow a password-less login to ReCaS machines.

On the home folder in the client machine:

```bash
ssh-keygen
```

will generate a set of pair in the .ssh/ folder. The `id_rsa` is the local private copy of the key which must stay in the client machine and not be copied elsewhere. The `id_rsa.pub` is the public copy of the key, whose information must be copied in the server machines.

Copy the public key on the home folder of the ReCaS frontend machine and issue the following command:

```bash
cat id_rsa.pub >> .ssh/authorized_keys
```

which will copy the content of the public key inside the list of trusted client machines. After this command, the user will be able to login from the selected client machines without password request.

ReCaS save the ssh key on a filesystem shared among the frontend machines, sometimes an error can occur on client machine during the log-in phase. This is due to the redirection to a specific frontend machine. A possible solution can be ssh with:

```bash
ssh -oStrictHostKeyChecking=no -oUserKnownHostsFile=/dev/null yourusername@frontend.recas.ba.infn.it
```

## Environment

The experiment software is installed in `/opt/exp_soft/herd_local/install/`. The folder contains different `setenvHERD` files for different environments installed on different dates (the newer the installation date, the more up-to-date the environment). The user can choose which environment to use by sourcing the relative `setenvHERD` file; the versions of each package are written inside each `setenvHERD` file.

### HerdSoftware master environment

Among the environments installed in `/opt/exp_soft/herd_local/install/` there is also a `master` environment. This is kept up-to-date with the current master version of HerdSoftware, and can then be used to test the latest available features. It is automatically update brightly, so keep in mind that it can change from one day to another without notice.

### HerdSoftware development environment

The `setenvHERD` files set up a complete computing environment including HerdSoftware. The HerdSoftware installation folders are added to the relevant environment variables (e.g. `LD_LIBRARY_PATH`) to be able to use the installed version. This can create conflicts when the user wants to use a development version of HerdSoftware containing his/her modification. In this case an environment clean of any HerdSofware setting should be used. This can be achieved by either sourcing the `hs-dev` script after the `setenvHERD` file, e.g.:

```bash
$ source  /opt/exp_soft/herd_local/install/setenvHERD.sh
$ source /opt/exp_soft/herd_local/scripts/hs-dev
```

or by directly sourcing both the files:

```bash
$ source /opt/exp_soft/herd_local/scripts/hs-dev /opt/exp_soft/herd_local/install/setenvHERD.sh
```

A handy setting that can be put in the `.bashrc` file is:

```bash
alias source-hs-dev = "source /opt/exp_soft/herd_local/scripts/hs-dev"
```

so that one can then simply write:

```bash
$ source-hs-dev /opt/exp_soft/herd_local/install/setenvHERD.sh
```

for setting up a development environment for HerdSoftware

### Automatic code formatting

Developers working at ReCaS should enable the automatic code formatting reminder by adding the `clang-format` executable path to the environment as describe [here](Developer's-manual/Code-formatting.md#automatic-reminder-for-code-formatting) for the CentOS7 Linux distribution (the need package is already installed, it is sufficient to modify the `.bashrc` as described)

## Submitting jobs

Job submission to the computing cluster is strictly required in case of large computing resource needs. Job submission is also strongly encouraged for data processing in order to keep the UI machine resources as highly available as possible to other users.

Job submission is managed via the HTCondor infrastructure. The user must instruct the service about the commands to be executed on the nodes and about the I/O information (input files, output directories, etc.). The services will schedule the job to be run based on the needed resources and the concurrent jobs pending on the cluster.

Managing job submission via HTCondor is very flexible and can reach high level of complexities. We report here only the basic instructions for simple job submission. Details about further customization are available, for example, [here](https://www.recas-bari.it/images/manuali/ITAManualeHTCondor.pdf) to submit a job, HTCondor requires a `submit description` or `submit` file, a text file that specifies the properties of the job to be submitted and the location of the `jobfile`, a file that contains all the instructions to be run by the computing node.

A basic submit job example file look as follows:

```bash
#All comments start with hash
#Filename: submit.sub
universe = vanilla
executable = /lustrehome/username/path/to/jobfile.sh
output = /lustrehome/username/path/to/outfile.out
error = /lustrehome/username/path/to/logfile.log
queue
```

and

```bash
#filename: jobfile.sh
#!/bin/sh
source /path/to/file/to/be/sourced.sh
/lustrehome/username/path/to/executable [option]
```

To submit the job to the cluster, the user should run the following command

```bash
condor_submit -name ettore /path/to/subfile.sub
```

The `output` file will contain the result of the stdout produced during the job. The `error` file will contain the result of the stderr produced during the job. The `log` file will contain information and statistics about the job. These files are available in the specified paths after the job starts. 

### Monitoring jobs

Several commands are available to the users to monitor the global status of the user jobs and to monitor the status of specific jobs, uniquely identified by their ID. A list of useful monitoring commands is available [here](https://www.recas-bari.it/images/manuali/ITAManualeHTCondor.pdf). e.g. to display all the jobs launched by a specific user issue the following command

```bash
condor_q -name ettore username
```

### Useful tips for job submission

1. All the input and output resources, as well as the software, should be located in folders that are available in the nodes like, for example, /lustrehome/username/to/useful/path which can be used as working directory for data analysis.

## Support

### ReCaS IT staff

Support from ReCaS staff can be asked by writing to `support@recas-bari.it`.

### Mailing list

The mailing list `herd_recas_users@lists.infn.it` is used for internal announcements related to ReCaS. Subscription can be asked by writing to `Fabio.Gargano@ba.infn.it`

### Discord channel

The `#recas` channel on the HERD Discord workspace is used for internal discussion about issues related to ReCaS. Subscribe to the channel to follow the discussion.
