#!/bin/bash

sleep 1 && curl -s https://raw.githubusercontent.com/Vlad-Mytsai/nodes/main/logo.sh | bash && sleep 1
echo -e "\n\e[40m\e[92mSUI node updating... Please wait :)\e[0m\n"
systemctl stop suid
sleep 3
rm -rf /root/.sui/db/* /root/.sui/genesis.blob /root/sui
source $HOME/.cargo/env
cd $HOME
git clone https://github.com/MystenLabs/sui.git
cd sui
git remote add upstream https://github.com/MystenLabs/sui
git fetch upstream
git checkout -B devnet --track upstream/devnet
cargo build --release
mv ~/sui/target/release/sui-node /usr/local/bin/
mv ~/sui/target/release/sui /usr/local/bin/
wget -O /root/.sui/genesis.blob https://github.com/MystenLabs/sui-genesis/raw/main/devnet/genesis.blob
systemctl restart suid
sleep 3
wget -qO-  -t 1 -T 5 --header 'Content-Type: application/json' --post-data '{ "jsonrpc":"2.0", "id":1, "method":"sui_getRecentTransactions", "params":[5] }' "http://127.0.0.1:9000/" | jq
sui --version
echo -e "\n\e[40m\e[92mUpdate installed!!\e[0m\n"
