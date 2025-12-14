# Threat Modelling

This directory contains structured threat modelling work focused on understanding, prioritising, and mitigating real-world attack paths across applications and infrastructure.

Rather than treating threat modelling as a theoretical exercise, the work in this folder applies established frameworks to live systems, aligning attacker behaviour with defensive controls and operational response.
The goal is to demonstrate how threat modelling directly informs security architecture decisions and automated response design with detection engineering, with emphasis on how effective those controls are.



## Methodologies Used

The threat models in this directory draw from industry recognised frameworks, including:

- **PASTA (Process for Attack Simulation and Threat Analysis):** Used to model business risk, attacker intent, and technical attack paths.

- **MITRE ATT&CK:** Applied to map adversary techniques to concrete exploitation paths and defensive controls.

- **Kill Chain–Driven Analysis:** Used to identify opportunities for detection, prevention, and automated containment at each attack stage.

These methodologies are applied pragmatically with emphasis on what can realistically be exploited and how it would be detected or stopped.


## Scope of Threat Models

Threat models in this directory typically include web application attack surfaces, Kubernetes and containerised workloads, network ingress and Zero Trust controls, 
runtime exploitation and post-exploitation behaviour and how automation can be applied to complement response mechanisms. Each model ties theoretical attack techniques directly to implemented security controls and observed telemetry.

---

## Focus Areas

- Mapping OWASP Top 10 vulnerabilities to MITRE ATT&CK techniques
- Identifying detection gaps in container runtime security
- Validating WAF, IDS, and policy enforcement effectiveness
- Assessing blast radius and lateral movement risk
- Informing automation logic for quarantine and response systems

### Relationship to Security Automation

I treat threat modelling as an input to engineering, not an afterthought. Threat modelling in this repository directly informs the design of automation projects such as the YouWatch family, in that attack paths identified during modelling influence the decision to correlate WAF and runtime signals. 
Separately, when and how automated isolation should occur after runtime exploitation scenarios are defined.


## Deliverables

Threat models may include:
- Attack flow diagrams
- MITRE ATT&CK mappings
- Risk prioritisation matrices
- Control-to-threat mapping
- Mitigation and detection strategy summaries

The emphasis is on clarity and security impact rather than documentation volume.

---

## Future Expansion

This directory is structured to support additional work such as:
- Continuous threat modelling for evolving systems
- Purple team inspired threat validation
- Detection gap analysis and tuning
- Threat informed defence planning
- Integration with incident response playbooks


