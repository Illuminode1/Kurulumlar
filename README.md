# README

100$ Free VPS for 2 Month\
[<img src="https://web-platforms.sfo2.cdn.digitaloceanspaces.com/WWW/Badge%201.svg" width="128" alt="DigitalOcean Referral Badge" data-size="line">](https://www.digitalocean.com/?refcode=410c988c8b3e\&utm\_campaign=Referral\_Invite\&utm\_medium=Referral\_Program\&utm\_source=badge) \
**This page contains tutorials on how to operate various crypto project servers.**\
[<img src="https://github.com/Nodeist/Testnet_Kurulumlar/blob/fee87fe32609c1704206721b9fb16e4c5de75a96/telegramlogo.png" width="64" alt="" data-size="line">](https://t.me/nodeistt)\
Join Telegram.\
\
[<img src="https://raw.githubusercontent.com/Nodeist/Testnet_Kurulumlar/main/logo.png" width="64" alt="" data-size="line">](https://nodeist.net/)\
Visit Our Website.\
\
[<img src="https://cdn.logojoy.com/wp-content/uploads/20210422095037/discord-mascot.png" width="64" alt="" data-size="line">](https://discord.gg/ypx7mJ6Zzb)\
Join Discord


Peer bul

```
curl -sS http://localhost:36657/net_info | jq -r '.result.peers[] | "\(.node_info.id)@\(.remote_ip):\(.node_info.listen_addr)"' | awk -F ':' '{print $1":"$(NF)}'
```

Aktif set

```
query staking validators --limit 2000 -o json | jq -r '.validators[] | select(.status=="BOND_STATUS_BONDED") | [.operator_address, .status, (.tokens|tonumber / pow(10; 6)), .description.moniker] | @csv' | column -t -s"," | sort -k3 -n -r
```

İnaktif set

```
query staking validators --limit 2000 -o json | jq -r '.validators[] | select(.status=="BOND_STATUS_UNBONDED") | [.operator_address, .status, (.tokens|tonumber / pow(10; 6)), .description.moniker] | @csv' | column -t -s"," | sort -k3 -n -r
```

#### Kullanılan portlar:

| Network      | Port |
| ------------ | ---- |
| Celestia     | 30   |
| Clan         | 31   |
| Defund       | 32   |
| Deweb        | 33   |
| Kujira       | 34   |
| Kyve         | 35   |
| Quicksilver  | 36   |
| Sei          | 37   |
| BOŞ          | 38   |
| BOŞ          | 39   |
| Uptick       | 40   |
| Paloma       | 41   |
| Another-1    | 42   |
| CrowdControl | 43   |
| Stride       | 44   |
| Teritori     | 45   |
