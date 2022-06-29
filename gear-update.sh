#Logo
sleep 1 && curl -s https://raw.githubusercontent.com/Vlad-Mytsai/nodes/main/logo.sh | bash && sleep 1

#Updating
echo -e "\n\nUpdating... Please wait :)\n"

wget https://builds.gear.rs/gear-nightly-linux-x86_64.tar.xz
sudo tar -xvf gear-nightly-linux-x86_64.tar.xz -C /root
rm gear-nightly-linux-x86_64.tar.xz
sudo systemctl restart gear

echo -e "\n\e[40m\e[92mUpdate installed!!\e[0m\n"