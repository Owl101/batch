batch
=====

batch scripts

This is pretty much a collection of various batch scripts that I have written over the years so this isn't
regarding a single or particular project, except maybe to replace some repetitive and/or mind numbing tasks
that I have had to do in the past.

Please note that some of these scripts may be broken in some ways, this would have happened while I was 
obfuscating the info in them, I'll fix this in time, but in the mean time I expect you to read through the 
scripts before blindly running them  :P

netdiag.bat
Basic network dignostic script which check basic network configurations, connectivity and file versions
relating to the default configurations of the My Company network.  I used to have the users run this whenever 
they had a problem with connectivity while they were out and about.  It just runs through various tests and 
checks proxy settings and file versions.

pxy_set.bat
Fairly useful script for remotely checking or modifying a system's proxy config.  It can swap around proxy 
settings between pac files, static settings and disabling of both if needed.

reg_op.bat
This script is pretty hectic in some ways and some functions never got completed, but effectively it can 
toggle various registry settings on both local and remote systems, eg. toggling of terminal services, system
restore functions, rebooting of systems, process handling without using task manager, remote cmd shells.
The speed test and the toggling of task manager(to get around some viruses) are incomplete.

ssh_pipe.bat
This script makes use of the command line version of PuTTY called plink to connect to and run a set of 
commands against multiple hosts then dump the results into a text file.

vpndiag.bat
This is the twin to the netdiag.bat file in that I would have the users run this while connected to the 
company VPN.
