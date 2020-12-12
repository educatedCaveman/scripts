#!/usr/local/bin/python
import requests
import os
import json
import sys


host_dev = 'lv-426.lab'
host_prd = 'sevastopol.vm'
port = 9000
token = None

#testing getting API token for portainer
def get_api_token(env):
    user, passwd, host = None, None, None
    if env == 'dev':
        user = os.getenv('PORTAINER_DEV_USER')
        passwd = os.getenv('PORTAINER_DEV_PASS')
        host = 'lv-426.lab'
    elif env == 'prd':
        user = os.getenv('PORTAINER_DEV_USER')
        passwd = os.getenv('PORTAINER_DEV_PASS')
        host = 'sevastopol.vm'
    else:
        print('unknown environment. exiting...')
        sys.exit(1)

    request_url = 'http://{host}:{port}/api/auth'.format(host=host, port=port)
    body = {
        "Username": "{}".format(user),
        "Password": "{}".format(passwd)
    }
    body_json = json.dumps(body)
    r = requests.post(url=request_url, data=body_json)
    if r.ok:
        data = json.loads(r.content)
        token = data["jwt"]
        print(token)
    else:
        print(r)
        sys.exit(1)


get_api_token('dev')




