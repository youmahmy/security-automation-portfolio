# security-automation-portfolio
A collection of scripts for enterprise security operations by Youcef Mahmoudi.

YouCheck
--------
Local PowerShell-run file integrity checker for critical system or configuration folders. It helps detect unauthorised modifications, which is a key indicator of potential intrusion, malware activity, or administrative error.
It does this by first taking a directory input from the user, and then getting the current hash (SHA256) of all the files in the directory.

First, the program creates a 'baseline.txt' file. This will be used to store all the baseline directories and their hashes.
Then, the program obtains the baseline hash in the 'baseline.txt' file and compares it with the current hash value. If a single file is changed even by a spacebar, the output hash will be entirely different.
If a change is detected, the program will tell the user exactly which specific files were modified, and the exact date and time the modification took place respectively.

-----
Currently monitoring - shows the directories currently being monitored. Separated by entry number, directory name, hash value, time created.

'check'     -  Checks directory 1's integrity and lists the files within it that were changed (e.g 'check 1'). You can find the directory number on the far left-hand side of the main menu section.

'monitor'   -  Adds the directory to the baseline file to be checked against (e.g 'monitor C:\MyFolder').

'unmonitor' -  Removes the directory from the baseline file to be checked against (e.g 'unmonitor C:\MyFolder').

'main'      -  Go back to the main menu.

-----
Usage) 

- PowerShell 5.1 or later. 
- The script should be run from a directory where you have write permissions, as it creates the 'baseline.txt' file in the same location.
- Open PowerShell and navigate to the script's directory, then run the script by typing '.\YouCheck.ps1'


Redactor
--------
Redactor is a menu-driven PowerShell utility designed to securely anonymise sensitive data within log files. 
It uses regular expressions and custom keyword lists to replace identifiable information (like IP addresses and hostnames) with generic placeholders, while optionally providing a secure method for recovery.
This script is ideal for situations where raw log files must be shared with external parties (e.g., security vendors, auditors, or developers) but must first have PII or internal network details removed to maintain confidentiality.

The script removes identified IP addresses, domains and specific host/server names as shown:

---
$global:IPregex	Regex	\d{1,3}(\.\d{1,3}){3}	    --  Replaced with {REMOVED_IPADDRESS}

$global:Domain	String	"domain.net"	          --  Replaced with {REMOVED_DOMAINNAME}

$global:ServerPrefix1, etc.	String	"III-SSS"   --  Replaced with {REMOVED_HOSTNAME}

$global:ServerPostfix1, etc.	String	"A1"	    --  Replaced with ***

$global:Keyword	String	"keying"	              --  Replaced with {REMOVED_KEYWORD}


It also has a non-destructive backup feature of the original found sensitive information in a separate secure location, which can be used to revert the redaction changes made.
Redactor also provides detailed reporting summaries of the types of data removed and the counts from each file in the directory respectively.
NOTE: 
The recover function (Option 2) relies entirely on a backup file being created during the redaction process (Option 1). These temporary files will be called '*84732647364.txt' and '*327638483346.txt' to manage the reporting and backup process. 
DO NOT delete these files while the script is running or if you intent to recover the data.

---
Usage) 

- PowerShell 5.1 or later.
- Run the script by typing '.\Redactor.ps1'


YouScan
-------
YouScan is a command-line utility built in PowerShell designed to automate the process of searching for specific keywords or phrases within multiple Word .docx files across a specified directory.
This project addresses the manual overhead of compliance checks, content auditing, or investigative tasks that require validating the presence (or absence) of critical terms within document repositories.
It allows the user to specify a precise number of terms to search for interactively, or reads a list of keywords from a separate text file (one keyword per line) for large-scale or repeated scans.

This also has use cases for legal teams who need to determine if any one of their agreement documents contain certain keywords. When you have multiple of these, it can be difficult to just CTRL + F and type.
Example output:

---
[-] Scan results below [-]

[-] Thank you for using YouScan [-]


Document_A.docx contains the term 'confidential'

Document_B.docx does not contain the term 'security'

Project_Report_Final.docx contains the term 'Q3 Earnings'


These results can also be in an Excel spreadsheet format depending on the use case.

---
Usage)

- To utlise the COM object features in this script, ensure you have Microsoft Word installed.

- Run the script from a PowerShell console: .\YouScan.ps1 or .\YouScan_ExcelEdition.ps1











