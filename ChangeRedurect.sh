#!/bin/bash

if [ "`whoami`" != "root" ]; then
  echo "Require root privilege"
  echo "Type sudo su"
  exit 1
fi

cat <<EOT
- * - * - * - * - * - * - * - * -
- *  HELLO, MY ROOT USER !!!  * -
- * - * - * - * - * - * - * - * -
EOT

# object=';push "redirect-gateway def1 bypass-dhcp"' 

if [ "$(cat  /etc/openvpn/server.conf | grep ';push "redirect-gateway def1 bypass-dhcp"' )" ] ;then
  echo "now your setting is redirect off"
  # read -n1 -p "change? (y/N): " yn
  read  -p "cahnge? (y/N): " yn
  if [  $yn = y  ] ;then
    sed -i s/';push "redirect-gateway def1 bypass-dhcp"'/'push "redirect-gateway def1 bypass-dhcp"'/ /etc/openvpn/server.conf
    systemctl restart openvpn@server.service
    echo "redirect on"
  else
    echo "no changed"
  fi
else
  echo "now your setting is redirect on"
  read  -p "change? (y/N): " yn
  #case "$yn" in [yY]*)read -n1 -p "change? (y/N): " yn
  if [ $yn = y ] ;then
   sed -i s/'push "redirect-gateway def1 bypass-dhcp"'/';push "redirect-gateway def1 bypass-dhcp"'/ /etc/openvpn/server.conf
   systemctl restart openvpn@server.service
   echo "redirect off"
  else
    echo "no changed"
  fi
fi

#systemctl status openvpn@server

