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
cd ~/openvpn-certs
echo "クライアントネームを入力してください"
read client_name

if [ ! -e /root/openvpn-certs/pki/private/$client_name.key ] &&  [ ! -e /root/openvpn-certs/pki/issued/$client_name.crt  ] ; then
  echo "create file";
else
  echo "file exist or something error"
  exit;
fi

# コメント作成
./easyrsa build-client-full $client_name nopass

mkdir /etc/openvpn/client/$client_name

cd /etc/openvpn/client/$client_name

# cp /root/openvpn-certs/pki/private/$client_name.key /etc/openvpn/client/$client_name
# cp /root/openvpn-certs/pki/issued/$client_name.crt /etc/openvpn/client/$client_name
cp /etc/openvpn/client/client.conf /etc/openvpn/client/$client_name/config.ovpn

echo "<cert>" >> /etc/openvpn/client//$client_name/config.ovpn 
cat /root/openvpn-certs/pki/issued/$client_name.crt | awk '/BEGIN/,/END/' >> /etc/openvpn/client//$client_name/config.ovpn
echo "</cert>" >> /etc/openvpn/client//$client_name/config.ovpn

echo "<key>" >> /etc/openvpn/client//$client_name/config.ovpn
cat /root/openvpn-certs/pki/private/$client_name.key | awk '/BEGIN/,/END/' >> /etc/openvpn/client//$client_name/config.ovpn
echo "</key>" >> /etc/openvpn/client//$client_name/config.ovpn

cat /etc/openvpn/client//$client_name/config.ovpn
echo -n "copy  above text -and- "
echo -n "create  config.ovpn  in your device -and- "
echo "paste"

# /root/openvpn-certs/pki/private/$client_name.key
# /root/openvpn-certs/pki/issued/$client_name.crt


