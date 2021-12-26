#!/bin/bash
#########
# Add Custom Rule #
#########
### Add GDUT Cernet IP
echo "222.200.96.0/19" >> data/gdut
echo "202.116.128.0/19" >> data/gdut
echo "2001:da8:2018::/48" >> data/gdut
### Download & Add CN Cernet GeoIP
curl -sL https://gaoyifan.github.io/china-operator-ip/cernet.txt >> data/cn-cernet
curl -sL https://gaoyifan.github.io/china-operator-ip/cernet6.txt >> data/cn-cernet
if [ ! -f "data/cn-cernet" ]; then echo "[cn-cernet] IP List Add Fail!!"; exit 2; fi
### Add Zerotier Root Server IP
curl -s "https://dns.google/resolve?name=root.zerotier.com&type=A" | jq -r .Answer | jq -r .[] | grep data | sed 's/^[ \t]*//g' | cut -d '"' -f4 | while read line; do echo $line >> zerotier4.tmp; done
curl -s "https://dns.google/resolve?name=root.zerotier.com&type=AAAA" | jq -r .Answer | jq -r .[] | grep data | sed 's/^[ \t]*//g' | cut -d '"' -f4 | while read line; do echo $line >> zerotier6.tmp; done
if [ "$(cat zerotier4.tmp | wc -l)" != "0" ]; then cat zerotier4.tmp >> data/zerotier; mv zerotier4.tmp data/zerotier4; else echo "[zerotier] IPv4 List Add Fail"; exit 2; fi
if [ "$(cat zerotier6.tmp | wc -l)" != "0" ]; then cat zerotier6.tmp >> data/zerotier; mv zerotier6.tmp data/zerotier6; else echo "[zerotier] IPv6 List Add Fail"; exit 2; fi