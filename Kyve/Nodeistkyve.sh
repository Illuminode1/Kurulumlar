#!/bin/bash
echo "=================================================="
echo "   _  ______  ___  __________________";
echo "  / |/ / __ \/ _ \/ __/  _/ __/_  __/";
echo " /    / /_/ / // / _/_/ /_\ \  / /   ";
echo "/_/|_/\____/____/___/___/___/ /_/    ";
echo -e "\e[0m"
echo "=================================================="                                     


sleep 2

# DEGISKENLER by Nodeist
KYVE_WALLET=wallet
KYVE=kyved
KYVE_ID=korellia
KYVE_PORT=35
KYVE_FOLDER=.kyve
KYVE_FOLDER2=
KYVE_VER=v0.0.1
KYVE_REPO=https://github.com/KYVENetwork/chain/releases/download/$KYVE_VER/chain_linux_amd64.tar.gz
KYVE_GENESIS=https://github.com/KYVENetwork/chain/releases/download/v0.0.1/genesis.json
KYVE_ADDRBOOK=https://api.testnet.run/addrbook-korellia.json
KYVE_MIN_GAS=0
KYVE_DENOM=utia
KYVE_SEEDS=e56574f922ff41c68b80700266dfc9e01ecae383@3.73.27.185:26656
KYVE_PEERS=

sleep 1

echo "export KYVE_WALLET=${KYVE_WALLET}" >> $HOME/.bash_profile
echo "export KYVE=${KYVE}" >> $HOME/.bash_profile
echo "export KYVE_ID=${KYVE_ID}" >> $HOME/.bash_profile
echo "export KYVE_PORT=${KYVE_PORT}" >> $HOME/.bash_profile
echo "export KYVE_FOLDER=${KYVE_FOLDER}" >> $HOME/.bash_profile
echo "export KYVE_FOLDER2=${KYVE_FOLDER2}" >> $HOME/.bash_profile
echo "export KYVE_VER=${KYVE_VER}" >> $HOME/.bash_profile
echo "export KYVE_REPO=${KYVE_REPO}" >> $HOME/.bash_profile
echo "export KYVE_GENESIS=${KYVE_GENESIS}" >> $HOME/.bash_profile
echo "export KYVE_PEERS=${KYVE_PEERS}" >> $HOME/.bash_profile
echo "export KYVE_SEED=${KYVE_SEED}" >> $HOME/.bash_profile
echo "export KYVE_MIN_GAS=${KYVE_MIN_GAS}" >> $HOME/.bash_profile
echo "export KYVE_MIN_GAS=${KYVE_DENOM}" >> $HOME/.bash_profile
source $HOME/.bash_profile

sleep 1

if [ ! $KYVE_NODENAME ]; then
	read -p "NODE ISMI YAZINIZ: " KYVE_NODENAME
	echo 'export KYVE_NODENAME='$KYVE_NODENAME >> $HOME/.bash_profile
fi

echo -e "NODE ISMINIZ: \e[1m\e[32m$KYVE_NODENAME\e[0m"
echo -e "CUZDAN ISMINIZ: \e[1m\e[32m$KYVE_WALLET\e[0m"
echo -e "CHAIN ISMI: \e[1m\e[32m$KYVE_ID\e[0m"
echo -e "PORT NUMARANIZ: \e[1m\e[32m$KYVE_PORT\e[0m"
echo '================================================='

sleep 2


# GUNCELLEMELER by Nodeist
echo -e "\e[1m\e[32m1. GUNCELLEMELER YUKLENIYOR... \e[0m" && sleep 1
sudo apt update && sudo apt upgrade -y


# GEREKLI PAKETLER by Nodeist
echo -e "\e[1m\e[32m2. GEREKLILIKLER YUKLENIYOR... \e[0m" && sleep 1
sudo apt install curl tar wget clang pkg-config libssl-dev jq build-essential bsdmainutils git make ncdu gcc git jq chrony liblz4-tool -y

# GO KURULUMU by Nodeist
echo -e "\e[1m\e[32m1. GO KURULUYOR... \e[0m" && sleep 1
ver="1.18.2"
cd $HOME
wget "https://golang.org/dl/go$ver.linux-amd64.tar.gz"
sudo rm -rf /usr/local/go
sudo tar -C /usr/local -xzf "go$ver.linux-amd64.tar.gz"
rm "go$ver.linux-amd64.tar.gz"
echo "export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin" >> ~/.bash_profile
source ~/.bash_profile
go version

sleep 1

# KUTUPHANE KURULUMU by Nodeist
wget $KYVE_REPO
tar -xvzf chain_linux_amd64.tar.gz
sudo mv chaind $KYVE
chmod +x $KYVE && mv ./chaind /usr/local/bin/$KYVE

# COSMOVISOR by Nodeist
wget https://github.com/KYVENetwork/chain/releases/download/v0.0.1/cosmovisor_linux_amd64
mv cosmovisor_linux_amd64 cosmovisor
chmod +x cosmovisor && mv ./cosmovisor /usr/local/bin/cosmovisor
mkdir -p $HOME/.kyve/cosmovisor/genesis/bin/
echo "{}" > $HOME/.kyve/cosmovisor/genesis/upgrade-info.json
cp /usr/local/bin/$KYVE $HOME/.kyve/cosmovisor/genesis/bin/$KYVE



sleep 1

# KONFIGURASYON by Nodeist
echo -e "\e[1m\e[32m1. KONFIGURASYONLAR AYARLANIYOR... \e[0m" && sleep 1
$KYVE config chain-id $KYVE_ID
$KYVE config keyring-backend file
$KYVE init $KYVE_NODENAME --chain-id $KYVE_ID

# ADDRBOOK ve GENESIS by Nodeist
wget $KYVE_GENESIS -O $HOME/$KYVE_FOLDER/config/genesis.json
wget $KYVE_ADDRBOOK -O $HOME/$KYVE_FOLDER/config/addrbook.json

# EŞLER VE TOHUMLAR by Nodeist
SEEDS="$KYVE_SEEDS"
PEERS="$KYVE_PEERS"
sed -i -e "s/^seeds *=.*/seeds = \"$SEEDS\"/; s/^persistent_peers *=.*/persistent_peers = \"$PEERS\"/" $HOME/$KYVE_FOLDER/config/config.toml

sleep 1


# config pruning
pruning="custom"
pruning_keep_recent="100"
pruning_keep_every="0"
pruning_interval="50"
sed -i -e "s/^pruning *=.*/pruning = \"$pruning\"/" $HOME/$KYVE_FOLDER/config/app.toml
sed -i -e "s/^pruning-keep-recent *=.*/pruning-keep-recent = \"$pruning_keep_recent\"/" $HOME/$KYVE_FOLDER/config/app.toml
sed -i -e "s/^pruning-keep-every *=.*/pruning-keep-every = \"$pruning_keep_every\"/" $HOME/$KYVE_FOLDER/config/app.toml
sed -i -e "s/^pruning-interval *=.*/pruning-interval = \"$pruning_interval\"/" $HOME/$KYVE_FOLDER/config/app.toml


# ÖZELLEŞTİRİLMİŞ PORTLAR by Nodeist
sed -i.bak -e "s%^proxy_app = \"tcp://127.0.0.1:26658\"%proxy_app = \"tcp://127.0.0.1:${KYVE_PORT}658\"%; s%^laddr = \"tcp://127.0.0.1:26657\"%laddr = \"tcp://127.0.0.1:${KYVE_PORT}657\"%; s%^pprof_laddr = \"localhost:6060\"%pprof_laddr = \"localhost:${KYVE_PORT}060\"%; s%^laddr = \"tcp://0.0.0.0:26656\"%laddr = \"tcp://0.0.0.0:${KYVE_PORT}656\"%; s%^prometheus_listen_addr = \":26660\"%prometheus_listen_addr = \":${KYVE_PORT}660\"%" $HOME/$KYVE_FOLDER/config/config.toml
sed -i.bak -e "s%^address = \"tcp://0.0.0.0:1317\"%address = \"tcp://0.0.0.0:${KYVE_PORT}317\"%; s%^address = \":8080\"%address = \":${KYVE_PORT}080\"%; s%^address = \"0.0.0.0:9090\"%address = \"0.0.0.0:${KYVE_PORT}090\"%; s%^address = \"0.0.0.0:9091\"%address = \"0.0.0.0:${KYVE_PORT}091\"%" $HOME/$KYVE_FOLDER/config/app.toml
sed -i.bak -e "s%^node = \"tcp://localhost:26657\"%node = \"tcp://localhost:${KYVE_PORT}657\"%" $HOME/$KYVE_FOLDER/config/client.toml

# PROMETHEUS AKTIVASYON by Nodeist
sed -i -e "s/prometheus = false/prometheus = true/" $HOME/$KYVE_FOLDER/config/config.toml

# MINIMUM GAS AYARI by Nodeist
sed -i -e "s/^minimum-gas-prices *=.*/minimum-gas-prices = \"0.00125$KYVE_DENOM\"/" $HOME/$KYVE_FOLDER/config/app.toml

# INDEXER AYARI by Nodeist
indexer="null" && \
sed -i -e "s/^indexer *=.*/indexer = \"$indexer\"/" $HOME/$KYVE_FOLDER/config/config.toml

# RESET by Nodeist
$KYVE tendermint unsafe-reset-all --home $HOME/$KYVE_FOLDER

echo -e "\e[1m\e[32m4. SERVIS BASLATILIYOR... \e[0m" && sleep 1
# create service
tee <<EOF > /dev/null /etc/systemd/system/$KYVE.service
[Unit]
Description=KYVE Chain-Node daemon
After=network-online.target

[Service]
User=$USER
ExecStart=$(which cosmovisor) start
Restart=on-failure
RestartSec=3
LimitNOFILE=infinity

Environment="DAEMON_HOME=$HOME/$KYVE_FOLDER"
Environment="DAEMON_NAME=$KYVE"
Environment="DAEMON_ALLOW_DOWNLOAD_BINARIES=true"

[Install]
WantedBy=multi-user.target
EOF


# SERVISLERI BASLAT by Nodeist
sudo systemctl daemon-reload
sudo systemctl enable $KYVE
sudo systemctl restart $KYVE

echo '=============== KURULUM TAMAM! by Nodeist ==================='
echo -e 'LOGLARI KONTROL ET: \e[1m\e[32mjournalctl -f $KYVE\e[0m'
echo -e "SENKRONIZASYONU KONTROL ET: \e[1m\e[32mcurl -s localhost:${KYVE_PORT}657/status | jq .result.sync_info\e[0m"

source $HOME/.bash_profile
