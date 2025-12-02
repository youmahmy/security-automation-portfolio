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