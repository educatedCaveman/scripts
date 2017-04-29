echo "attempting to kill openvpn..."
sudo kill -9 $(cat /etc/openvpn/vpn.pid)
#dont know why, but need to wait a few seconds between killing VPN and trying to start it again.
sleep 2
#check if open VPN running or not:
if [ -z "$(ps -e | grep openvpn)" ];
then
	echo "openVPN WAS killed successfully."
	echo "attempting to restart openVPN..."
	sudo /usr/sbin/openvpn --config /etc/openvpn/NYC.ovpn --writepid /etc/openvpn/vpn.pid &
else
	echo "openVPN was NOT killed successfully."
	echo "something went wrong and you need to kill and restart it manually."
fi
