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
curl -s "https://dns.google/resolve?name=root.zerotier.com&type=A" | jq -r .Answer | jq -r .[] | grep data | sed 's/^[ \t]*//g' | cut -d '"' -f4 | while read line; do echo $line >> zerotier.tmp; done
curl -s "https://dns.google/resolve?name=root.zerotier.com&type=AAAA" | jq -r .Answer | jq -r .[] | grep data | sed 's/^[ \t]*//g' | cut -d '"' -f4 | while read line; do echo $line >> zerotier.tmp; done
if [ "$(cat zerotier.tmp | wc -l)" != "0" ]; then mv zerotier.tmp data/zerotier; else echo "[zerotier] IP List Add Fail"; exit 2; fi