#!/usr/local/bin/python
import requests
import sys
import os
from tabulate import tabulate
import argparse
import json


#global variable:
env, host, action, branch = None, None, None, None
port = 9000
endpoint_id = 1
dev_host = 'lv-426.lab'
prd_host = 'sevastopol.vm'
repo = "https://github.com/educatedCaveman/docker-lab"
prd_branch = "refs/heads/master"
dev_branch = "refs/heads/dev_test"

#helper functions
def print_json(json_data):
    try:
        json_object = json.loads(json_data)
        print(json.dumps(json_object, indent = 2)) 
    except:
        pass


def format_stacks(resp):
    #TODO: determine which columns are the most useful
    stack_table = []
    stack_headers = ['ID', 'Name', 'Type', 'EndpointId', 'EntryPoint', 'Status']
    for stack in resp.json():
        stack_ID = stack['Id']
        stack_name = stack['Name']
        stack_type = stack['Type']
        stack_endpoint = stack['EndpointId']
        stack_file = stack['EntryPoint']
        stack_stus = stack['Status']
        tmp = [stack_ID, stack_name, stack_type, stack_endpoint, stack_file, stack_stus]
        stack_table.append(tmp)
    
    print(tabulate(stack_table, stack_headers))


def get_api_token(env):
    #TODO: check for existing token, and use it. if invalid, get and store new token
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
        return None
        
    global token
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
        return token
        # print(token)
    else:
        print(r)
        print(r.text)
        print(r.content)
        return None


#required options: -e, 
parser = argparse.ArgumentParser(description='perform actions on portainer.')

#get the environment
parser.add_argument('-e', required=True, choices=['prd', 'PRD', 'dev', 'DEV'])

#create our action list
action_group = parser.add_mutually_exclusive_group(required=True)
action_group.add_argument('--list', choices=['json', 'table'])
action_group.add_argument('--remove', type=int)
action_group.add_argument('--create', nargs=1)

args = parser.parse_args()
# print(args)

if args.e in ('prd', 'PRD'):
    host = prd_host
    token = get_api_token('prd')
    branch = prd_branch

if args.e in ('dev', 'DEV'):
    host = dev_host
    token = get_api_token('dev')
    branch = dev_branch

if token is None:
    print('unable to retrieve token')
    sys.exit(1)

if host is None:
    print('unable to set host')
    sys.exit(1)

if branch is None:
    print('unable to set branch')
    sys.exit(1)

#prepare to call the API; these are the same for everything
head = {'Authorization': 'Bearer {}'.format(token)}
# headers = {'content-type': 'application/json'}    #TODO: this isn't needed?

#determine action:
#list stacks
if args.list != None:
    request_url = 'http://{host}:{port}/api/stacks'.format(host=host, port=port)
    r = requests.get(url = request_url, headers=head)
    if (r.ok):
        if args.list == 'json':
            print_json(r.text)
        else:
            format_stacks(r)

#create stack
if args.create != None:
    request_url = 'http://{host}:{port}/api/stacks?method=repository&type=2&endpointId={endpoint}'.format(
        host=host, 
        port=port, 
        endpoint=endpoint_id)
    
    # print(type(args.create[0]))
    path = str(args.create[0] + '/' + args.create[0] + '-docker-compose.yml')
    body = {
        "Name": args.create[0],
        "RepositoryURL": repo,
        "RepositoryReferenceName": branch,
        "ComposeFilePathInRepository": path,
    }
    body_json = json.dumps(body)
    r = requests.post(url=request_url, data=body_json, headers=head)
    print(r)
    print(r.text)

#remove stack
#TODO: add ability to remove based on name, not just id
if args.remove != None:
    request_url = 'http://{host}:{port}/api/stacks/{stack_id}?endpointId={endpointId}'.format(
        host=host, 
        port=port,
        stack_id=args.remove,
        endpointId=endpoint_id)
    r = requests.delete(url=request_url, headers=head)
    print(r)
    print_json(r.text)
