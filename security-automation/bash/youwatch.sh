#!/bin/bash

NAMESPACE="falco"
POD_LABEL="app.kubernetes.io/name=falco"
CONTAINER="falco"

echo "

 __ __         _ _ _     _       _
|  |  |___ _ _| | | |___| |_ ___| |_
|_   _| . | | | | | | .'|  _|  _|   |
  |_| |___|___|_____|__,|_| |___|_|_|

YouWatch v1.1 by Youcef Mahmoudi

[+] Watching Falco logs for Juice Shop exploitation...

"

# Continuously watch Falco logs
kubectl logs -f -l $POD_LABEL -n $NAMESPACE -c $CONTAINER | while read -r line; do
  if echo "$line" | grep "Juice Shop pod"; then
    echo "[!] Detected exploitation: $line"
    echo "[+] Quarantining Juice Shop..."

    # Annotating the ingress to quarentine from any traffic:
    kubectl annotate ingress juice-shop-ingress \
      nginx.ingress.kubernetes.io/whitelist-source-range="0.0.0.0/32" --overwrite


    echo "[*] Quarantine applied"
  fi
done