Reporter
========

This collection of scripts is used in connection with the nein_db network inventory.
It consists out of collectors

In the beginning of the script it will determine the ID of the computer.
It will then send the a message to the inventory that an update was started.
After all the collectors are run and their information collect, the report is updated by relaying all collected information to the inventory.
The script will then turn of the computer.

Collectors
----------

The collectors are commands to be run which collect information.
They are all subclasses of the `Collector` class.


Parameters
----------

The dispatch script has a look at the kernel command line (available for instance in /proc/cmdline).
It will change its behaviour based on neindb specific parameters.
These parameters have the following form: `neindb.PARAMETER=VALUE`.

### Available paramters

```
neindb.asset_type=(computer)	  # Select which asset type you want to check for, right now only computers are supported.
neindb.interactive=true|false	  # Determines whether the reporter will be interactive or noninteractive. Noninteractive is the default.
neindb.poweroff=true|false	    # Should the computer be turned off after the reporter finished (successful or unseccessful). The default is to turn the computer off.

```
