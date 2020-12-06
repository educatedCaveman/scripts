#!/usr/local/bin/python
import requests
import sys
import os
from tabulate import tabulate
import argparse
import json


#helper functions
def print_json(json_data):
    json_object = json.loads(json_data)
    print(json.dumps(json_object, indent = 2)) 

def response_ok(resp):
    if resp.ok: 
        print('response ok')
        return True
    else: 
        print('response not ok')
        # return False
        sys.exit(1)

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


#environment setting:
env, host, token, action = None, None, None, None
port = 9000
endpoint_id = 1

#required options: -e, 
parser = argparse.ArgumentParser(description='perform actions on portainer.')

#get the environment
parser.add_argument('-e', required=True, choices=['prd', 'PRD', 'dev', 'DEV'])

#create our action list
action_group = parser.add_mutually_exclusive_group(required=True)
action_group.add_argument('--list', choices=['json', 'table'])
action_group.add_argument('--remove', type=int)
action_group.add_argument('--create', nargs=3)

args = parser.parse_args()
print(args)

# print(args.e)

if args.e in ('prd', 'PRD'):
    host = 'sevastopol.vm'
    token = os.getenv('PORTAINER_PRD_TOKEN')
    #TODO: set repo ref (master)

if args.e in ('dev', 'DEV'):
    host = 'lv-426.lab'
    token = os.getenv('PORTAINER_DEV_TOKEN')
    #TODO: set repo ref (dev)

if token is None:
    print('unable to retrieve token')
    sys.exit(1)

#prepare to call the API; these are the same for everything
head = {'Authorization': 'Bearer {}'.format(token)}
headers = {'content-type': 'application/json'}

#determine action:
if args.list != None:
    request_url = 'http://{host}:{port}/api/stacks'.format(host=host, port=port)
    r = requests.get(url = request_url, headers=head)
    if (response_ok(r)):
        if args.list == 'json':
            print_json(r.text)
        else:
            format_stacks(r)

if args.create != None:
    # #TODO: query the API
    request_url = 'http://{host}:{port}/api/stacks?method=repository&type=1&endpointId={endpoint}'.format(
        host=host, 
        port=port, 
        endpoint=endpoint_id)
    
    # body = {
    #     "Name": args.name,
    #     "RepositoryURL": args.repo,
    #     "RepositoryReferenceName": "refs/heads/master",
    #     "ComposeFilePathInRepository": args.path,
    # }
    body = {
        "Name": "iperf",
        "RepositoryURL": "https://github.com/educatedCaveman/docker-lab",
        "RepositoryReferenceName": "refs/heads/master",
        "ComposeFilePathInRepository": "iperf/iperf-docker-compose.yml",
    }
    # body_json = json.dumps(body)
    print(request_url)
    print(body)

    r = requests.post(url=request_url, data=body, headers=head)
    print(r)
    print(r.text)


if args.remove != None:
    request_url = 'http://{host}:{port}/api/stacks/{stack_id}?endpointId={endpointId}'.format(
        host=host, 
        port=port,
        stack_id=args.remove,
        endpointId=endpoint_id)
    r = requests.delete(url=request_url, headers=head)
    print(r)
