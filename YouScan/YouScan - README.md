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
