#!/bin/bash
MYIP=$(wget -qO- icanhazip.com);
apt install jq curl -y

DOMAIN=slowdns1.my.id
sub=$(</dev/urandom tr -dc a-z0-9 | head -c5)
#subsl=$(</dev/urandom tr -dc a-z0-9 | head -c5)
dns=${sub}.slowdns1.my.id
#NS_dns=slowdns-${subsl}.casper.my.id
CF_ID=data.mtakbir@gmail.com
CF_KEY=a87d8da1122addfbc0dbb71ba4219875808c0
set -euo pipefail
IP=$(wget -qO- icanhazip.com);
echo "Updating DNS for ${dns}..."
ZONE=$(curl -sLX GET "https://api.cloudflare.com/client/v4/zones?name=${DOMAIN}&status=active" \
     -H "X-Auth-Email: ${CF_ID}" \
     -H "X-Auth-Key: ${CF_KEY}" \
     -H "Content-Type: application/json" | jq -r .result[0].id)

RECORD=$(curl -sLX GET "https://api.cloudflare.com/client/v4/zones/${ZONE}/dns_records?name=${dns}" \
     -H "X-Auth-Email: ${CF_ID}" \
     -H "X-Auth-Key: ${CF_KEY}" \
     -H "Content-Type: application/json" | jq -r .result[0].id)

if [[ "${#RECORD}" -le 10 ]]; then
     RECORD=$(curl -sLX POST "https://api.cloudflare.com/client/v4/zones/${ZONE}/dns_records" \
     -H "X-Auth-Email: ${CF_ID}" \
     -H "X-Auth-Key: ${CF_KEY}" \
     -H "Content-Type: application/json" \
     --data '{"type":"A","name":"'${dns}'","content":"'${IP}'","ttl":120,"proxied":false}' | jq -r .result.id)
fi

RESULT=$(curl -sLX PUT "https://api.cloudflare.com/client/v4/zones/${ZONE}/dns_records/${RECORD}" \
     -H "X-Auth-Email: ${CF_ID}" \
     -H "X-Auth-Key: ${CF_KEY}" \
     -H "Content-Type: application/json" \
     --data '{"type":"A","name":"'${dns}'","content":"'${IP}'","ttl":120,"proxied":false}')
#echo "$dns" > /root/scdomain
echo $dns > /root/domain
#echo "$dns" > /etc/xray/scdomain
echo "$dns" > /etc/xray/domain
echo "$dns" > /etc/v2ray/domain
#echo $dns > /root/domain
echo "IP=$dns" > /var/lib/ipvps.conf
#echo "Host NS : $NS_DOMAIN"
#echo $NS_dns > /root/nsdomain
cd
