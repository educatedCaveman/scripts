#!/usr/local/bin/python
import subprocess
import sys
import os
import argparse
import requests
from tabulate import tabulate
import json


#global variable:
host, port, user, passwd, repo, branch = None, None, None, None, None, None
endpoint_id = 1

#helper functions:
def get_api_token(host, port, user, passwd):
    #TODO: check for existing token, and use it. if invalid, get and store new token
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


def print_json(json_data):
    try:
        json_object = json.loads(json_data)
        print(json.dumps(json_object, indent = 2)) 
    except:
        pass


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


#argument parsing:
parser = argparse.ArgumentParser(description='perform actions on portainer.')
#get the environment, and the repo path:
parser.add_argument('--env', required=True, choices=['PRD', 'DEV'])
parser.add_argument('--repo', required=True, nargs=1, type=str)
#parse the arguments
args = parser.parse_args()

#get environment variables:
remote_repo = os.getenv('PORTAINER_REPO')
port = os.getenv('PORTAINER_PORT')
user = os.getenv('PORTAINER_USER')

if args.e in ('prd', 'PRD'):
    host = os.getenv('PORTAINER_PRD_HOST')
    passwd = os.getenv('PORTAINER_PRD_PASS')
    branch = os.getenv('PORTAINER_PRD_BRANCH')
    token = get_api_token(host, port, user, passwd)

if args.e in ('dev', 'DEV'):
    host = os.getenv('PORTAINER_DEV_HOST')
    passwd = os.getenv('PORTAINER_DEV_PASS')
    branch = os.getenv('PORTAINER_DEV_BRANCH')
    token = get_api_token(host, port, user, passwd)

#exit if key variables weren't set:
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

#determine most recent change to git repo
git_dir = args.repo[0]
cmd = ['git', '-C', git_dir, '--no-pager', 'log', '-1', '--stat']
res = subprocess.check_output(cmd)
output = res.decode().splitlines()

#need to know how many files were changed:
last_line = output[-1]
last_words = last_line.split()

change_count = None
try:
    change_count = int(last_words[0])
except:
    print('error parsing git output')
    sys.exit(1)

changed_files = []
#using that number, get that number of lines before the last line
#then split those lines getting the files
for i in range(len(output)-2, len(output)-change_count-2, -1):
    tmp = output[i].split()
    changed_files.append(tmp[0])

to_restart = []
to_recreate = []
to_delete = []
stack_changes = []

#next, figure out which directories contain changed files
for file in changed_files:
    tmp = file.split('/')
    #if the file is in the root of the repo, it is ignored
    if len(tmp) > 1:
        #a change to a docker compose file means we need to restart the stack
        if 'docker-compose.yaml' in tmp[-1]:
            #if its a stack related change, register it as such
            stack_changes.append(tmp[0])
            
            #if the file exists, we need to re-create
            if os.path.isfile(file):
                to_recreate.append(tmp[0])
                print('re-create stack: {}'.format(tmp[0]))
            
            #if it doesn't, we just need to delete it
            else:
                to_delete.append(tmp[0])
                print('delete stack: {}'.format(tmp[0]))

        #otherwise, just restart all the containers in the stack
        else:
            to_restart.append(tmp[0])
            print('restart stack: {}'.format(tmp[0]))
    
    #TODO: remove
    else:
        print('ignore stack: {}'.format(tmp[0]))

for stack in to_restart:
    if stack in stack_changes:
        #if the stack is in the reastart and re-create lists, only need to re-create
        to_restart.remove(stack)
        print('dont restart stack: {}'.format(stack))

#TODO: test this
for stack in to_delete:
    #run the command to delete the stack
    # pass
    remove_stack_by_name(host, port, head, stack, endpoint_id)

#TODO: test this:
for stack in to_recreate:
    #run the command to re-create the stack
    # pass
    #if stack already running, remove it
    # name = args.recreate[0]
    print("need to check if the '{name}' stack already exists".format(name=stack))

    #this will check if the stack already exists, and delete it if it does
    remove_stack_by_name(host, port, head, stack, endpoint_id)

    #if no error, create stack
    create_stack(host, port, head, endpoint_id, remote_repo, branch, stack)

#TODO: test this
for stack in to_restart:
    #run the command to restart the stack
    # pass
    name = args.restart[0]
    restart_stack(host, port, head, stack, endpoint_id)
