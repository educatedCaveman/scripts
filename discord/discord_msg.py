import requests

# simple wrapper for sending a discord message using a webhook
def send_message(webhook, message):
    content = {
        "content":  message,
        "embeds": [{
            "image": {
                "url":  "https://raw.githubusercontent.com/VoronDesign/Voron-Extras/022e6cefcae4892547eb3fbd222046f89f11ee76/Images/Logo/Heart_Logo.png"
            },
            "footer": {
                "text": "Woah! So cool! :smirk:",
                "icon_url": "https://i.imgur.com/fKL31aD.jpg"
            }
        }]
    }

    r = requests.post(webhook, data=content)
    return r


webhook = "https://discordapp.com/api/webhooks/973698699819647026/wIPNb7aw6lUXgqkNguGZn7aXTpbX0VpXKOzbEFJHIqRTfp6iIW3LnWzQSNhW1wUnAt3S/?image=yes"
send_message(webhook, "test_image_embed")




    