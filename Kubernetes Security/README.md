# Kubernetes Security Portfolio

This directory contains a collection of practical Kubernetes security projects designed to demonstrate modern cluster hardening, network isolation, detection engineering, and automated response techniques. Each project replicates realistic scenarios encountered in production environments and is structured to be fully reproducible on a standard workstation. Together, these projects highlight the full lifecycle of Kubernetes security: prevention, detection, and automated response.

## Overview
- **Nginx ZTNA Project:** Deployed a k3s cluster in Ubuntu Server to host a vulnerable web application *(OWASP Juice Shop)* alongside Nginx ingress whitelist rules, differentiating different devices on the LAN and their authorisation to accessing the service.

- **Calico ZTNA Project:** Used Kind *(Kubernetes in Docker)* to create a configured Calico cluster, deploy a web application and apply Zero-Trust Network Segmentation based on pod names and Automated Security Controls within a Kubernetes environment. 


## Upcoming Projects
- **Falco Auto-Quarantine Project:** This project will introduce a Falco-based automated quarantine system, with dynamic Nginx ingress quarantining which will focus on runtime threat detection and dynamic isolation of compromised pods.

---
This repository aims to provide a high level of technical depth while maintaining clear, accessible documentation. It is intended to showcase a strong understanding of cluster architecture, policy design, and practical DevSecOps workflows. Each project includes architecture diagrams, implementation steps, live log output, and troubleshooting notes to provide complete insight into the decision-making process behind each solution.

Across the portfolio, technologies such as Nginx Ingress, Calico, Falco, Kubernetes RBAC, and lightweight distributions like k3s are used to create realistic, controlled demonstrations of security concepts. These projects also emphasise operational concerns, including debugging ingress failures, validating network policies, analysing runtime events, and ensuring deterministic behaviour in multi-component systems.

This collection will continue to expand with additional modules, including admission controller policies, mTLS enforcement, RBAC hardening, and further runtime protections. 
It is an actively maintained repository built to evolve alongside modern Kubernetes security practices.



