\### YouWatch FAW-R (Falco + WAF Reactor)



YouWatch FAW-R is a real-time security response engine that correlates web-layer attacks detected by a Web Application Firewall (WAF) with runtime exploitation signals detected by Falco.



Rather than relying on alerting alone, FAW-R enforces immediate mitigation actions at the Kubernetes ingress and workload levels.



\#### Core Capabilities



\- Continuously monitors ModSecurity audit logs for confirmed web attacks

\- Dynamically extracts attacker IP addresses and applies ingress-level blocking

\- Simultaneously watches Falco runtime security events for in-pod exploitation attempts

\- Automatically responds to confirmed runtime compromise by enforcing isolation actions

\- Designed to operate continuously without disrupting legitimate traffic flows



\#### Security Objectives



\- Reduce time-to-containment for web and runtime attacks

\- Prevent lateral movement following exploitation

\- Enforce decisive mitigation without human intervention

\- Demonstrate defence-in-depth across application, network, and runtime layers



\#### Expandability



FAW-R is designed to support future enhancements such as:

\- Additional detection sources (SIEM, cloud logs)

\- Policy-driven response logic and severity-based / infraction frequency decision making

