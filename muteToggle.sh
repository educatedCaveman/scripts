#check if a channel is muted.
#if yes, unmute channel 2
#else, mute channel 2
if [ -z "$(pacmd list-sinks | grep muted | grep yes)" ];
then
	#echo "no channel is muted..."
	#mute index/channel 2
	pacmd set-sink-mute 2 1
else
	#echo "a channel is muted..."
	#unmute channel 2
	pacmd set-sink-mute 2 0
fi

