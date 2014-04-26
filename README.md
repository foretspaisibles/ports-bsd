# FreeBSD ports that I maintain

This repository holds the FreeBSD ports that I maintain.


# How to integrate these ports to the ports tree

To integrate these ports to the ports tree, we go through the
following steps:

- Create a directory `${PORTSDIR}/michipili` owned by the user working
  with these ports.
- Clone this repository under `${PORTSDIR}/michipili`.
- Create a file `${PORTSDIR}/Makefile.local` containing the line
  `SUBDIR+= michipili`.


# Workflow

The `master` branch represents a stable state which provides
functional ports, which may not yet be found in the ports tree.  The
only commits made to the `master` branch are merges from the
`integration` branch.

The `vendor` branch represents the state of the ports tree.  It is be
updated with the `Ancillary/port_vendordrop.sh` script and receive no
other commits.

Each port has its own branch, which holds development required by
updates.  When a port update is merged in the ports tree, the
corresponding branch is deleted and will be cut out from master the
next time an update will be required.

The `integration` branch is used to merge ports and prepare symbolic
commits to `master`.


Michael Grünewald in Bonn, on February 28, 2014
