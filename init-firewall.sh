#!/bin/bash
set -e

# Flush existing rules
iptables -F OUTPUT
iptables -F INPUT

# Allow loopback
iptables -A OUTPUT -o lo -j ACCEPT
iptables -A INPUT -i lo -j ACCEPT

# Allow established/related connections
iptables -A OUTPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT

# Allow DNS (UDP and TCP)
iptables -A OUTPUT -p udp --dport 53 -j ACCEPT
iptables -A OUTPUT -p tcp --dport 53 -j ACCEPT

# Resolve and allow required domains
ALLOWED_DOMAINS=(
    "api.anthropic.com"
    "registry.npmjs.org"
    "github.com"
    "api.github.com"
    "sentry.io"
    "statsig.anthropic.com"
)

# Create ipset for allowed IPs
ipset create allowed_hosts hash:ip -exist
ipset flush allowed_hosts

for domain in "${ALLOWED_DOMAINS[@]}"; do
    ips=$(dig +short A "$domain" 2>/dev/null || true)
    for ip in $ips; do
        if [[ "$ip" =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
            ipset add allowed_hosts "$ip" -exist
        fi
    done
done

# Allow HTTPS to resolved IPs
iptables -A OUTPUT -p tcp --dport 443 -m set --match-set allowed_hosts dst -j ACCEPT

# Drop everything else outbound
iptables -A OUTPUT -j DROP

# Verify: example.com should be unreachable
if curl -s --max-time 3 https://example.com > /dev/null 2>&1; then
    echo "WARNING: Firewall verification failed - example.com is reachable"
else
    echo "Firewall active: outbound traffic restricted to allowed domains."
fi
