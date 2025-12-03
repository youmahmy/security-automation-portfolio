# Kubernetes Security Automation: Zero-Trust & Network Policy Enforcement

## Project Overview
This project demonstrates the implementation of Zero-Trust Network Segmentation and Automated Security Controls within a Kubernetes environment. Using Kind (Kubernetes in Docker) and Calico, I deployed a Vulnerable Web Application (OWASP Juice Shop) to test and enforce strict ingress traffic policies.

### Key Technologies Used
- Kubernetes *(Kind)*
- Calico CNI
- Calico Whisker *(Observability)*
- Trivy *(Vulnerability Scanning)*

---

## Part 1: Basic Ingress Traffic Blocking

### 1. Cluster Setup & Calico Deployment
I began by installing Kind and configuring the cluster to use Calico as the Container Network Interface *(CNI)*. The configuration ensures the Calico control plane and worker nodes are correctly deployed with the necessary Custom Resource Definitions *(CRDs)* for policy enforcement.

![Calico CRD Configuration](assets/01-calico-crd-config.png)

Verifying the Calico components using the Tigera operator:

![Tigera Status](assets/02-tigera-status.png)

### 2. Monitoring with Calico Whisker
To visualise network traffic flows in real-time, I utilised Calico Whisker. I set up port forwarding to access the Whisker UI via the browser, allowing me to monitor allowed and denied traffic decisions.

![Calico Whisker UI](assets/03-whisker-ui-setup.png)

### 3. Deploying the Vulnerable Web App
I deployed the OWASP Juice Shop as a target application.

![Juice Shop Deployment YAML](assets/04-juice-shop-yaml.png)

After deployment, I verified connectivity using a `busybox` container. As expected, the connection was initially successful.

![Successful Connection](assets/05-initial-connection.png)

### 4. Enforcing a Default-Deny Policy
To secure the application, I created a Calico NetworkPolicy to log and block all ingress traffic to the web application by default.

![Block Ingress Policy YAML](assets/06-policy-deny-all.png)

Applying the policy to the cluster:

![Applying Policy](assets/07-apply-deny-policy.png)

---

## Part 2: Zero-Trust Policies & Vulnerability Scanning

### 1. Implementing Zero-Trust Segmentation
Next, I demonstrated a Zero-Trust model by creating an exception. I configured a specific policy to allow traffic only from a trusted pod named `youcef`, while keeping all other traffic blocked.

I achieved this by assigning a higher priority (lower order number) to the allow rule:

![Allow Policy YAML](assets/08-traffic-blocked.png)

Applying the Zero-Trust exception rule:

![Applying Exception](assets/09-policy-allow-youcef.png)

### 2. Policy Enforcement in Action
**Unauthorised Access Attempt:**
Traffic from any standard pod *(not matching the `youcef` label)* is denied and logged by Whisker.

![Whisker Denied Traffic](assets/10-whisker-denied-flow.png)

**Authorised Access:**
When connecting from the trusted `youcef` pod, the traffic is allowed, successfully demonstrating precise microsegmentation.

![Whisker Allowed Traffic](assets/11-whisker-allowed-flow.png)

### 3. Vulnerability Scanning with Trivy
Finally, I performed a container security scan on the `juice-shop` image using Trivy.

![Trivy Scan Command](assets/12-trivy-scan-cmd.png)

**Scan Results:**
The scan revealed significant vulnerabilities in the outdated image:
* **Total:** 68 Vulnerabilities *(including 8 CRITICAL)*
* **Debian Image:** 12 Low
* **Node.js Packages:** 55 Vulnerabilities

![Trivy Scan Output](assets/13-trivy-results.png)


#### Critical Vulnerabilities Identified

| CVE ID | Package | Issue | Fix Version |
| :--- | :--- | :--- | :--- |
| **CVE-2023-46233** | `crypto-js` | BKDF2 is 1,000x weaker than standard | `4.2.0` |
| **CVE-2015-9235** | `jsonwebtoken` | Verification bypass with altered token | `4.2.2` |
| **CVE-2019-10744** | `lodash` | Prototype pollution in defaultsDeep | `4.17.12` |
| **GHSA-5mrr-rgp6** | `marsdb` | Command Injection | *No Fix* |
| **CVE-2023-32314** | `vm2` | Sandbox Escape | `3.9.18` |

**Remediation Strategy:** The immediate next step is to update the base image and dependencies to their patched versions, or replace packages like `marsdb` that have no available fix.

---

## Lessons Learned
**1. Zero-Trust Requires Precise, Explicit Rules**

Implementing Zero-Trust network segmentation highlighted how Kubernetes policies must be written with absolute explicitness. Calico does not assume intent—if traffic should be allowed, it must be precisely defined. The process of moving from a “default-allow” environment to “default-deny” required careful ordering of policies, correct label selection, and priority management. Even a small mismatch in selectors would cause a complete lockout or unintended access.

**2. Observability Is Critical for Debugging Policies**

Calico Whisker proved essential for validating policy behaviour. Without real-time visibility into allowed vs. denied traffic, it would have been extremely difficult to identify whether misconfigurations were caused by the network policy, incorrect selectors, or pod-level issues. Whisker’s flow logs provided immediate feedback, allowing me to verify that blocks, exceptions, and Zero-Trust allow rules were being triggered correctly.

**3. Limitation Encountered: Unable to Block Local PC Acces**

During testing, my PC accessing the Juice Shop service via port forwarding was not being blocked, even when a strict implicit NetworkPolicy was active. Although pods inside the cluster were correctly denied, traffic from outside the cluster (my Windows host) was still able to load the service in a browser. This highlighted an important architectural behaviour:

- Kubernetes NetworkPolicies only control traffic between pods inside the cluster.

- Traffic entering through NodePorts, LoadBalancers, or port-forwarding bypasses pod-level policies unless additional host-level controls (Calico HostEndpoints, firewall rules, or eBPF-based host protections) are configured.

Because I relied solely on pod-level NetworkPolicies, host-level traffic (including my PC) remained unaffected. This is expected Kubernetes behaviour, but worth noting when designing Zero-Trust architectures that must include the cluster edge.

**4. WSL2 Limitations Prevent Host-Level Enforcement**

Much of the difficulty above stemmed from WSL2’s networking model, which imposes limitations on CNI enforcement:

**Why WSL2 Causes Problems**

WSL2 runs inside a lightweight VM with its own virtualised network stack, separated from Windows. CNIs like Calico expect direct control of Linux networking primitives *(iptables, eBPF, routing tables)* but inside WSL2 these are partially virtualised and do not fully represent the host network. This means consequentially that host traffic doesn’t pass through the Kubernetes CNI chain, meaning pod to pod traffic is enforced, while Windows / Kubernetes traffic completely bypasses Calico. Port forwarding with `kubectl port-forward` further tunnels traffic directly to pods over an internal connection, bypassing NetworkPolicies entirely.

**Impact**

This made it impossible to achieve full Zero-Trust behaviour from external sources, even though pod-level enforcement was correct and observable via Whisker.

**5. A Proper Linux Environment Makes Zero-Trust Enforcement Accurate**

To accurately test real-world enforcement—including blocking the host, external clients and ingress traffic, you need a full Linux networking stack. A suitable alternative includes Linux VM on VMware/VirtualBox/Hyper-V running Ubuntu, Debian, or Fedora, Bare-metal Linux orCloud Kubernetes clusters (EKS, AKS, GKE, Civo, DigitalOcean), etc. This is because in these environments, Calico’s eBPF and iptables hook into the actual host networking layer. HostEndpoints can be created to enforce ingress/egress rules on the nodes themselves. Traffic entering the cluster does not bypass CNI policies and Zero-Trust becomes fully enforceable all the way from the edge to the pod.

**6. Vulnerability Scanning Reveals the Value of Shift-Left Security**

Running Trivy on the Juice Shop image gave a clear view of how outdated dependencies create attack surfaces. Many vulnerabilities were critical, including token verification bypasses and prototype pollution. Integrating Trivy into the development pipeline would allow images to be scanned and remediated before deployment reinforcing a shift left security approach.
