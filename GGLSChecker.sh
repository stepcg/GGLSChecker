#!/bin/bash
# Lane Messer: GoGuardian/LS Checker: Quickly check FQDNs for blocked or restricted. 

read -p "Enter primary GoGuardian/LS DNS server: " DNS1
read -p "Enter secondary GoGuardian/LS DNS server: " DNS2
read -p "Enter domain to check: " DOMAIN

# Use dig to resolve domain using the DNS that we have.
echo "Resolving $DOMAIN using $DNS1..."
IPS=$(dig @"$DNS1" "$DOMAIN" +short | grep -Eo '([0-9]{1,3}\.){3}[0-9]{1,3}')

if [ -z "$IPS" ]; then
    echo "Primary DNS failed, trying secondary $DNS2..."
    IPS=$(dig @"$DNS2" "$DOMAIN" +short | grep -Eo '([0-9]{1,3}\.){3}[0-9]{1,3}')
fi

if [ -z "$IPS" ]; then
    echo "❌ Failed to resolve $DOMAIN with either DNS."
    exit 1
fi

echo "Resolved IPs: $IPS"

for IP in $IPS; do
    echo "Checking IP: $IP"
    RESPONSE=$(curl -k -s --resolve "$DOMAIN:443:$IP" "https://$DOMAIN" | head -n 50)

    if echo "$RESPONSE" | grep -iqE "LightSpeed|LS|ls|redirected|blocked|restricted|this website has been blocked"; then
        echo "❌ $DOMAIN is BLOCKED by GoGuardian/LS."
    else
        echo "✅ $DOMAIN is ALLOWED."
    fi
done

