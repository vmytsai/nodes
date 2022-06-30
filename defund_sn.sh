#!/bin/bash
echo -e "\n\e[40m\e[92mChecking...\e[0m\n"
while true
do
    if curl --head --silent --fail http://repository.activenodes.io/snapshots/defund-private-1_2022-06-30.tar.gz 2> /dev/null;
    then
        echo -e "\n\e[40m\e[92mSnapshot exists!! Start updating...\e[0m\n"
        break
    else
        sleep 60
    fi
done

systemctl stop defund

rm -rf /root/.defund/data/state.db

cd ~/.defund/
cp data/priv_validator_state.json .
mv data data_old
wget http://repository.activenodes.io/snapshots/defund-private-1_2022-06-30.tar.gz
tar xzvf defund*.tar.gz
rm defund*.tar.gz
mv priv_validator_state.json data/
systemctl restart defund


echo -e "\n\e[40m\e[92mSnapshot updated!!\e[0m\n"

echo -e "\nChech status: \e[42mcurl localhost:26657/status\e[0m\n"
echo -e "Chech info: \e[42mcurl localhost:26657/status\e[0m\n"


