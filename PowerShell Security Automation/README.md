# PowerShell Security Automation & Data Protection Toolkit

This repository contains a suite of highly-focused PowerShell scripts developed to streamline repetitive security tasks, enhance data protection, and provide quick auditing visibility on Windows environments.

These tools are designed to bridge gaps in traditional security tooling by offering granular control over local system checks, file analysis, and data handling, making them valuable assets for SOC analysts and vulnerability management teams.

### Key Scripts and Functionality

| Script | Core Security Domain | Purpose |
| :--- | :--- | :--- |
| **`Redactor.ps1`** | Data Loss Prevention | Automates the masking and redaction of sensitive patterns *(credit card numbers, PII)* within text files to minimize data exposure risk. |
| **`YouFile.ps1`** | Security Auditing | Provides rapid file system traversal and detailed metadata reporting, allowing security teams to audit file permissions, last access times, and track potential data leakage indicators. |
| **`YouCheck.ps1`** | System & Vulnerability Management | Executes a series of configurable local security checks against system settings, registry keys, and configurations to quickly identify common vulnerabilities or compliance deviations. |
