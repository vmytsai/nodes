#!/bin/bash

exists()
{
  command -v "$1" >/dev/null 2>&1
}
if exists curl; then
	echo ''
else
  sudo apt update && sudo apt install curl -y < "/dev/null"
fi
bash_profile=$HOME/.bash_profile
if [ -f "$bash_profile" ]; then
    . $HOME/.bash_profile
fi
sleep 1 && curl -s https://raw.githubusercontent.com/Vlad-Mytsai/nodes/main/logo.sh | bash && sleep 1

echo -e "\n\nUpdating... Please wait :)\n\n"

mkdir $HOME/subspace >/dev/null 2>&1 && \
cd $HOME/subspace && \
VER=$(wget -qO- https://api.github.com/repos/subspace/subspace/releases | jq '.[].html_url' | grep -vE "runtime|chain-spec" | grep -Eo "gemini-[0-9]*[a-zA-Z]-[0-9]*-[a-zA-Z]*-[0-9]*" | head -n 1) && \
wget https://github.com/subspace/subspace/releases/download/${VER}/subspace-farmer-ubuntu-x86_64-${VER} -qO subspace-farmer; \
wget https://github.com/subspace/subspace/releases/download/${VER}/subspace-node-ubuntu-x86_64-${VER} -qO subspace-node; \
sudo chmod +x * && \
if [[ $(./subspace-farmer --version) == "" || $(./subspace-node --version) == "" ]]; then
  echo -e "\n\nWTF?!? \e[31mSomething went wrong!!\e[39m\nWrite me on telegram: @vlad.mytsai\n\n"
else
  sudo mv * /usr/local/bin/ && \
  FARMER_V=$(echo $(subspace-farmer --version) | grep -ow '[0-9]*.[0-9]*.[0-9]*') && \
  SUBSPACE_V=$(echo $(subspace-node --version) | grep -ow '[0-9]*.[0-9]*.[0-9]*') && \
  echo -e "\n\nrelease >> ${VER}.\nsubspace-farmer >>> v${FARMER_V}.\nsubspace-node > v${SUBSPACE_V}.\n\n"
fi && \
cd $HOME && \
rm -Rvf $HOME/subspace >/dev/null 2>&1 && \
sudo systemctl daemon-reload && \
sudo systemctl restart subspaced && \
sleep 20
sudo systemctl restart subspaced-farmer

echo -e "\nCheck block height:\n\e[42msudo journalctl -fu subspaced -o cat | grep -Eo 'best: #[0-9]*'\e[0m\n"

echo -e "\n\nCheck log:\n\e[42msudo journalctl -fu farmerd -o cat\e[0m\n"