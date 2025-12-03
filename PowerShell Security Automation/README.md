# PowerShell Security Automation & Data Protection Toolkit

This repository contains a suite of highly-focused PowerShell scripts developed to streamline repetitive security tasks, enhance data protection, and provide quick auditing visibility on Windows environments.

These tools are designed to bridge gaps in traditional security tooling by offering granular control over local system checks, file analysis, and data handling, making them valuable assets for SOC analysts and vulnerability management teams.

### Key Scripts and Functionality

| Script | Core Security Domain | Purpose |
| :--- | :--- | :--- |
| **`Redactor.ps1`** | Data Loss Prevention | Automates the masking and redaction of sensitive patterns *(IP addresses, domain names)* within files to minimise data exposure risk. |
| **`YouCheck.ps1`** | Integrity Monitoring | A lightweight integrity-monitoring solution. Checks the integrity of a directory's hash against a baseline. Shows which files were modified, and when. |
| **`YouFile.ps1`** | Data Discovery | Recursively searches directories for files containing specified keywords, enabling fast identification of sensitive or relevant content. |

