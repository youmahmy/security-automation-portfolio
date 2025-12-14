# security-automation-portfolio
A collection of projects and scripts for enterprise security operations by Youcef Mahmoudi.

---

# Introduction
This portfolio documents practical security engineering projects that focus on automated detection, response, and control enforcement across Kubernetes, cloud-native, and endpoint environments. Rather than isolated tool deployments, these projects are designed as end-to-end security systems, demonstrating how alerts, policies, and runtime signals can be translated into meaningful security outcomes such as containment, isolation, and recovery.

The work emphasises practical security engineering trade-offs, failure handling, and real-world operational constraints.

---

## Core Focus Areas

### Kubernetes Runtime Security & DevSecOps
Design and implementation of runtime detection and automated response pipelines using tools such as Falco IDS, Nginx Ingress and ModSecurity WAF.

### Automated Incident Response
Development of custom automation that reacts directly to security events rather than producing passive alerts. Examples include automated ingress isolation, dynamic policy enforcement, and pod deletion in response to runtime compromise.

### Zero Trust Architecture *(ZTNA)*
Implementation of access control and network segmentation using Calico Network Policies and NGINX ingress whitelisting, enforcing least-privilege communication within containerised environments.

### Security Automation & Endpoint Controls
Creation of PowerShell-based security automation tools addressing:

* File integrity monitoring (YouCheck)
* Data discovery and exposure identification (YouScan)
* Data loss prevention and redaction (Redactor)

These tools focus on reducing manual effort while improving visibility and control over sensitive data on endpoints.

### Threat Modelling and Control Mapping
Establishment of structured exploit mapping to realistic attacker techniques using MITRE ATT&CK, validating detection and response coverage.

---

All projects demonstrate a comprehensive understanding of the security lifecycle, from infrastructure deployment and policy enforcement, to continuous monitoring and troubleshooting complex networking challenges.











