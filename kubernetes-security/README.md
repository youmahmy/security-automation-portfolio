# Kubernetes Security Portfolio

This directory contains a collection of practical Kubernetes security projects designed to demonstrate modern cluster hardening, network isolation, detection engineering, and automated response techniques. Each project replicates realistic scenarios encountered in production environments and is structured to be fully reproducible on a standard workstation. Together, these projects highlight the full lifecycle of Kubernetes security: prevention, detection, and automated response.

## Overview
- **YouWatch Falco Auto-Quarantine Project:** Developed a Falco-based automated quarantine system *(YouWatch)*, with dynamic Nginx ingress quarantining based on runtime threat detection and dynamic isolation of compromised pods.

- **Nginx ZTNA Project:** Deployed a k3s cluster in Ubuntu Server to host a vulnerable web application *(OWASP Juice Shop)* alongside Nginx ingress whitelist rules, differentiating different devices on the LAN and their authorisation to accessing the service.

- **Calico ZTNA Project:** Used Kind *(Kubernetes in Docker)* to create a configured Calico cluster, deploy a web application and apply Zero-Trust Network Segmentation based on pod names and Automated Security Controls within a Kubernetes environment. 


## Upcoming Projects
- **YouWatch FAW-R Project:** YouWatch FAW-R (Falco + WAF Reactor) builds upon my YouWatch Auto-Quarantine system. My existing YouWatch Bash script will now stream logs from a Web Application Firewall (WAF), such as ModSecurity or Nginx App Protect, and quarantine the web application by applying the same ingress rule (as used in the Falco Auto-Quarantine Project) to the Nginx ingress pod, or updating the WAF CRD policies for mitigation.

---
This repository aims to provide a high level of technical depth while maintaining clear, accessible documentation. It is intended to showcase a strong understanding of cluster architecture, policy design, and practical DevSecOps workflows. Each project includes architecture diagrams, implementation steps, live log output, and troubleshooting notes to provide complete insight into the decision-making process behind each solution.

Across the portfolio, technologies such as Nginx Ingress, Calico, Falco, Kubernetes RBAC, and lightweight distributions like k3s are used to create realistic, controlled demonstrations of security concepts. These projects also emphasise operational concerns, including debugging ingress failures, validating network policies, analysing runtime events, and ensuring deterministic behaviour in multi-component systems.

This collection will continue to expand with additional modules, including admission controller policies, mTLS enforcement, RBAC hardening, and further runtime protections. 
It is an actively maintained repository built to evolve alongside modern Kubernetes security practices.



