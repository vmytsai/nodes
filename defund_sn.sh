#!/bin/bash
echo -e "\n\e[40m\e[92mChecking...\e[0m\n"
VER=http://repository.activenodes.io/snapshots/defund-private-1_2022-07-07.tar.gz
while true
do
    if curl --head --silent --fail $VER 2> /dev/null;
    then
        echo -e "\n\e[40m\e[92mSnapshot exists!! Start updating...\e[0m\n"
        break
    else
        sleep 60
    fi
done

systemctl stop defund

cd ~/.defund/
cp data/priv_validator_state.json .
mv data data_old
wget $VER
tar xzvf defund*.tar.gz
rm defund*.tar.gz
mv priv_validator_state.json data/

systemctl restart defund

echo -e "\n\e[40m\e[92mSnapshot updated!!\e[0m\n"

echo -e "\nChech status: \e[42mcurl localhost:26657/status\e[0m\n"
echo -e "Chech journal: \e[42mjournalctl -u defund -f -f -o cat\e[0m\n"

rm ~/defund_sn.sh 

cd ~/.defund/
rm -rf data_old
