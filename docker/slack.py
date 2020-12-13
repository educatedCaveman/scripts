import requests
import sys
import os

# replicated from https://blog.ruanbekker.com/blog/2020/11/06/sending-slack-messages-with-python/

SLACK_WEBHOOK_URL = sys.argv[1]
SLACK_CHANNEL = "#dev_sec_ops"
ALERT_STATE = sys.argv[2]

alert_map = {
    "color": {
        "start": "#32a852",
        "end": "#32a852",
        "error": "#ad1721"
    }
}


def alert_to_slack(status):
    data = {
        "text": "Jenkins_Notifications",
        "username": "Jenkins",
        "channel": SLACK_CHANNEL,
        "attachments": [
        {
            "text": "test",
            "color": alert_map["color"][status],
            "attachment_type": "default",
            # "actions": [
            #     {
            #         "name": "Logs",
            #         "text": "Logs",
            #         "type": "button",
            #         "style": "primary",
            #         "url": log_url
            #     },
            #     {
            #         "name": "Metrics",
            #         "text": "Metrics",
            #         "type": "button",
            #         "style": "primary",
            #         "url": metric_url
            #     }
            # ]
        }]
    }
    r = requests.post(SLACK_WEBHOOK_URL, json=data)
    return r.status_code

alert_to_slack(ALERT_STATE)