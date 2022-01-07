import requests

# simple wrapper for sending a discord message using a webhook
def send_message(webhook, message):
    content = {
        "content":  message
    }

    r = requests.post(webhook, data=content)
    return r