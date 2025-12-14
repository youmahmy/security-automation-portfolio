#!/usr/bin/env python3
import json
import time
import subprocess
import threading

LOG_FILE = "/var/log/waf/modsec_audit.log"
INGRESS_NAME = "juice-shop-waf-ingress"
FALCO_TRIGGER = "Juice Shop pod"


def follow(path):
    # Tail the log file from the end.
    with open(path, "r", encoding="utf-8", errors="ignore") as f:
        f.seek(0, 2)
        while True:
            line = f.readline()
            if not line:
                time.sleep(0.2)
                continue
            yield line

def get_attacker_ip(tx):
    # Prefer real client IP.
    headers = tx.get("request", {}).get("headers", {})
    return headers.get("X-Real-IP") or tx.get("client_ip")
    
    

def is_attack(messages):
    # Return True if any message contains any attack signature.
    attacks = set()
    for m in messages:
        tags = m.get("details",{}).get("tags", [])
        for tag in tags:
            if tag.startswith("attack-") and tag.endswith("generic") or tag.startswith("attack-") and tag.endswith("protocol"):
                break
            elif tag.startswith("attack-"):
                attacks.add(tag.replace("attack-", ""))
                
                
    return attacks
    
    
    
    if not isattack(messages):
        return False
   


def block_ip(attacker_ip):
    BLOCKLIST_FILE = "blocked_ips.txt"

    try:
        with open(BLOCKLIST_FILE, "r") as f:
            blocked = set(line.strip() for line in f if line.strip())
    except FileNotFoundError:
        blocked = set()
        
        
    blocked.add(attacker_ip)
    with open(BLOCKLIST_FILE, "a") as f:
        f.write(attacker_ip + "\n")

    deny_rules = "".join(f"deny {b}/32;" for b in blocked)
    snippet_content = f"{deny_rules} allow all;"

    print(f"[FAW-R][*] Blocking IP: {attacker_ip}")

    subprocess.run([
        "kubectl", "annotate", "ingress", INGRESS_NAME,
        f"nginx.ingress.kubernetes.io/server-snippet={snippet_content}",
        "--overwrite"
    ])
    
    print(f"[FAW-R][+] {attacker_ip} blocked.")
    
    
    
    
    
### FOLLOW FALCO LOGS. Falco logs are in: tail -F /var/log/pods/falco_*/falco/*.log

def falco_watcher():
    global falco_quarantined

    print("[FAW-R][*] Watching Falco runtime events...")

    proc = subprocess.Popen(
        [
            "kubectl", "logs", "-f",
            "-l", "app.kubernetes.io/name=falco",
            "-n", "falco",
            "-c", "falco",
            "--since=1s"
        ],
        stdout=subprocess.PIPE,
        stderr=subprocess.DEVNULL,
        text=True,
        bufsize=1
    )

    for line in proc.stdout:

        if FALCO_TRIGGER in line:
            print("[FALCO][ALERT]", line.strip())
            kill_pod()
            
            
# Post network policies for ingress do not kick users out of pods. If a pod is compromised, deleting the existing pod and making a new one is safer and efficient.
# Ingress can prevent entry. It cannot prevent a compromised pod. 

def kill_pod():
    print("[FAW-R][*] Killing all compromised pods...")
    
    subprocess.run([
        "kubectl", "delete", "pod",
        "-l", "app=youcefs-juice-shop",
        "--grace-period=0",
        "--force"
    ], check=False)
    
    print("[FAW-R][+] Pod terminated. K8s will automatically create a new pod.")
    
def main():
    print('''
    
YouWatch
 _______ _______ ________        ______ 
|    ___|   _   |  |  |  |______|   __ \\
|    ___|       |  |  |  |______|      <
|___|   |___|___|________|      |___|__|
                                        
YouWatch FAW-R v1.0 by Youcef Mahmoudi

''')

    falco_thread = threading.Thread(target=falco_watcher, daemon=True)
    falco_thread.start()

    print("[FAW-R][*] Watching ModSecurity events...\n")

    for line in follow(LOG_FILE):
        try:
            data = json.loads(line)
        except json.JSONDecodeError:
            continue

        tx = data.get("transaction", {})
        messages = tx.get("messages", [])

        # Only process true attacks
        if not is_attack(messages):
            continue

        attacks = is_attack(messages)
        attacker_ip = get_attacker_ip(tx)
        
        for attack in attacks:
            print(f"[WAF] {attack.upper()} attempt from {attacker_ip}")
            block_ip(attacker_ip)
            
if __name__ == "__main__":
    main()