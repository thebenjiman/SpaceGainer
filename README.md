SpaceGainer
===========

Analyse a folder for duplicates file. <br> <br>
Uses MD5 checksum in order to do so. Works fine with large files. Uses separate thread (with GCD) for scanning phase in order to avoid locking the interface as the user is given a feedback through a NSProgressIndicator.  <br> <br>
Results are then displayed in a NSTableView where the user can check and clean duplicates.
