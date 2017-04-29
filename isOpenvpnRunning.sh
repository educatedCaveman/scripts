if [ -z "$(ps -e | grep openvpn)" ]; then
	echo "openVPN is NOT running."
else
	echo "openVPN IS running."
fi
