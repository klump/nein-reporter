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
