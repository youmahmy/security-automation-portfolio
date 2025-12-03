01, 02 Installed falco using helm



03 Injected custom rules via Helm / ConfigMap (falco-juice-shop-rules.yaml)



04, 05 Deployed the rule in falco and restarted the daemonset, got new falco pods





06 Falco rule not working, but default ruleset is: syntax error with k8s container (ephemeral containers aren’t real workload containers, so Falco wouldn't detect them) because container.name = 'youcefs-juice-shop'.





07 updated Falco ruleset and reapplied: Correct syntax = k8s.pod.name contains "juice-shop" and evt.type=execve and proc.name in ("nc", "wget", "sh") Will look for debug pods and nc wget or sh run inside of them as the trigger rule. 





08 falco rule working



09 bash script initial



10 youwatch running, but not detecting falco logs, realised syntax was wrong because it couldn't pipe the logs as the grep command was wrong.



11 fixed Youwatch syntax, v1.1, new grep command, updated command to stream logs.



12 YouWatch in action



13 Ingress applied from YouWatch to web app



14 Ingress in action via iPhone that connected before via the Nginx project (same k3s cluster)



lessons learned:



falco is good but can't detect actual web application exploit attempts, only pod ones



next project: use a WAF and stream logs from that in YouWatch 2.0









