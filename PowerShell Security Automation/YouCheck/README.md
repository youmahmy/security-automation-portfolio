YouCheck
--------
Local PowerShell-run file integrity checker for critical system or configuration folders. It helps detect unauthorised modifications, which is a key indicator of potential intrusion, malware activity, or administrative error.
It does this by first taking a directory input from the user, and then getting the current hash (SHA256) of all the files in the directory.

First, the program creates a *'baseline.txt'* file. This will be used to store all the baseline directories and their hashes.
Then, the program obtains the baseline hash in the 'baseline.txt' file and compares it with the current hash value. If a single file is changed even by a spacebar, the output hash will be entirely different.
If a change is detected, the program will tell the user exactly which specific files were modified, and the exact date and time the modification took place respectively.

-----
*Currently monitoring* - shows the directories currently being monitored. Separated by entry number, directory name, hash value, time created.

`check`     -  Checks directory 1's integrity and lists the files within it that were changed *(e.g 'check 1')*. You can find the directory number on the far left-hand side of the main menu section.

`monitor`   -  Adds the directory to the baseline file to be checked against *(e.g 'monitor C:\MyFolder')*.

`unmonitor` -  Removes the directory from the baseline file to be checked against *(e.g 'unmonitor C:\MyFolder')*.

`main`      -  Go back to the main menu.

-----
Usage) 

- PowerShell 5.1 or later. 
- The script should be run from a directory where you have write permissions, as it creates the *'baseline.txt'* file in the same location.
- Open PowerShell and navigate to the script's directory, then run the script by typing *'.\YouCheck.ps1'*


