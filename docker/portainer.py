#!/usr/local/bin/python
import requests
import sys
import os
from tabulate import tabulate
import argparse
import json


#global variable:
host, port, user, passwd, repo, branch = None, None, None, None, None, None
endpoint_id = 1

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


def get_api_token(host, port, user, passwd):
    #TODO: check for existing token, and use it. if invalid, get and store new token
    print('{host}, {port}, {user}, {passwd}, {repo}, {branch}'.format(
            host=host, port=port, user=user, passwd=passwd, repo=repo, branch=branch))
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
    else:
        print(r)
        print(r.text)
        print(r.content)
        return None


def list_stacks(host, port, head):
    request_url = 'http://{host}:{port}/api/stacks'.format(host=host, port=port)
    r = requests.get(url = request_url, headers=head)
    if (r.ok):
        if args.list == 'json':
            print_json(r.text)
        else:
            format_stacks(r)


def create_stack(host, port, head, endpoint_id, repo, branch, name):
    request_url = 'http://{host}:{port}/api/stacks?method=repository&type=2&endpointId={endpoint}'.format(
        host=host, 
        port=port, 
        endpoint=endpoint_id)
    
    path = str(name + '/' + name + '-docker-compose.yml')
    body = {
        "Name": name,
        "RepositoryURL": repo,
        "RepositoryReferenceName": branch,
        "ComposeFilePathInRepository": path,
    }
    body_json = json.dumps(body)
    r = requests.post(url=request_url, data=body_json, headers=head)
    print(r)
    print(r.text)


def remove_stack_by_id(host, port, head, stack_id, endpoint_id):
    request_url = 'http://{host}:{port}/api/stacks/{stack_id}?endpointId={endpointId}'.format(
        host=host, 
        port=port,
        stack_id=stack_id,
        endpointId=endpoint_id)
    r = requests.delete(url=request_url, headers=head)
    if (r.ok):
        print(r)
        print('stack removed.\n')
    else:
        print(r)
        print('stack not removed.\n')


def remove_stack_by_name(host, port, head, name, endpoint_id):
    # pass
    #need to get stack_id by parsing the list, and passing it to remove_stack_by_id()

    #get stacks:
    request_url = 'http://{host}:{port}/api/stacks'.format(host=host, port=port)
    r = requests.get(url = request_url, headers=head)

    #search response
    stack_id = None
    if (r.ok):
        json_response = json.loads(r.text)
        for stack in json_response:
            if stack["Name"] == name:
                print('found stack! its id is {id}.\n'.format(id=stack["Id"]))
                stack_id = stack["Id"]
    else:
        print(r)
        print_json(r.text)
    
    #remove stack, if its found
    if stack_id == None:
        print('stack not found!\n')
    else:
        print('removing stack...\n')
        remove_stack_by_id(host, port, head, stack_id, endpoint_id)


def restart_stack(host, port, head, name, endpoint_id):
    request_url = 'http://{host}:{port}/api/endpoints/{endpoint_id}/docker/containers/json'.format(
            host=host, port=port, endpoint_id=endpoint_id)
    r = requests.get(url=request_url, headers=head)
    if (r.ok):
        json_object = json.loads(r.text)
        to_restart = []
        for i in range(0, len(json_object)):
            #we only want the results having some labels, and whose name matches the stack
            if len(json_object[i]["Labels"]) > 0:
                compose_proj = json_object[i]["Labels"]["com.docker.compose.project"]
                if compose_proj == name:
                    container_name = json_object[i]["Names"][0][1:]     #simplify the name
                    container_id = json_object[i]["Id"]
                    to_restart.append(container_id)
                    print('{name} ({proj}): {id}'.format(name=container_name, proj=compose_proj, id=container_id))

        #restart the containers, if any found
        for container_id in to_restart:
            request_url = 'http://{host}:{port}/api/endpoints/{endpoint_id}/docker/containers/{id}/restart'.format(
                    host=host, port=port, endpoint_id=endpoint_id, id=container_id)
            print('attempting to restart {id}'.format(id=container_id))
            r = requests.post(url=request_url, headers=head)
            print(r)

    else:
        print(r)
        print(r.text)

#required options: -e, 
parser = argparse.ArgumentParser(description='perform actions on portainer.')

#get the environment
parser.add_argument('-e', required=True, choices=['prd', 'PRD', 'dev', 'DEV'])

#create our action list
action_group = parser.add_mutually_exclusive_group(required=True)
action_group.add_argument('--list', choices=['json', 'table'])
action_group.add_argument('--remove', nargs=1)
action_group.add_argument('--create', nargs=1, type=str)
action_group.add_argument('--recreate', nargs=1, type=str)
action_group.add_argument('--restart', nargs=1, type=str)

args = parser.parse_args()
# print(args)

#set repo and port
repo = os.getenv('PORTAINER_REPO')
port = os.getenv('PORTAINER_PORT')

if args.e in ('prd', 'PRD'):
    host = os.getenv('PORTAINER_PRD_HOST')
    user = os.getenv('PORTAINER_PRD_USER')
    passwd = os.getenv('PORTAINER_PRD_PASS')
    branch = os.getenv('PORTAINER_PRD_BRANCH')
    token = get_api_token(host, port, user, passwd)

if args.e in ('dev', 'DEV'):
    host = os.getenv('PORTAINER_DEV_HOST')
    user = os.getenv('PORTAINER_DEV_USER')
    passwd = os.getenv('PORTAINER_DEV_PASS')
    branch = os.getenv('PORTAINER_DEV_BRANCH')
    token = get_api_token(host, port, user, passwd)

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

#determine action:
#list stacks
if args.list != None:
    list_stacks(host, port, head)

#create stack
if args.create != None:
    create_stack(host, port, head, endpoint_id, repo, branch, args.create[0])

#remove stack
if args.remove != None:
    try:
        stack_id = int(args.remove[0])
        remove_stack_by_id(host, port, head, stack_id, endpoint_id)
    except:
        remove_stack_by_name(host, port, head, args.remove, endpoint_id)

#update stack
if args.restart != None:
    name = args.restart[0]
    restart_stack(host, port, head, name, endpoint_id)

#re-create (handles both initial creation, and already existing)
if args.recreate != None:
    #if stack already running, remove it
    name = args.recreate[0]
    print("need to check if the '{name}' stack already exists".format(name=name))

    #this will check if the stack already exists, and delete it if it does
    remove_stack_by_name(host, port, head, name, endpoint_id)

    #if no error, create stack
    create_stack(host, port, head, endpoint_id, repo, branch, name)
