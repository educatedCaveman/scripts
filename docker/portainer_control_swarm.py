#!/usr/local/bin/python
import subprocess
import sys
import os
import argparse
import requests
from tabulate import tabulate
import json


#global variable:
host, port, user, passwd, repo, branch, swarm_ID = None, None, None, None, None, None, None
endpoint_id = 1

#helper functions:
def get_api_token(host, port, user, passwd):
    #TODO: check for existing token, and use it. if invalid, get and store new token
    request_url = 'http://{host}:{port}/api/auth'.format(host=host, port=port)
    body = {
        "Username": "{}".format(user),
        "Password": "{}".format(passwd)
    }
    print(request_url)
    print(body)
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


def get_swarm_id(host, port, head):
    # assumes we already have our token
    request_url = 'http://{host}:{port}/api/endpoints/{endpointId}/docker/swarm'.format(
        host=host, 
        port=port,
        endpointId=endpoint_id)
    r = requests.get(url=request_url, headers=head)
    if r.ok:
        data = json.loads(r.content)
        swarm_ID = data["ID"]
        print(swarm_ID)
        return swarm_ID
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
        print(json_response)
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


def create_stack(host, port, head, endpoint_id, repo, branch, name, swarm_ID):
    request_url = 'http://{host}:{port}/api/stacks?method=repository&type=1&endpointId={endpoint}'.format(
        host=host, 
        port=port, 
        endpoint=endpoint_id)
    
    path = str(name + '/' + name + '-docker-compose.yml')
    body = {
        "Name": name,
        "RepositoryURL": repo,
        "RepositoryReferenceName": branch,
        "ComposeFilePathInRepository": path,
        "SwarmID": swarm_ID,
    }
    body_json = json.dumps(body)
    print(body_json)
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
    print_json(r)
    if (r.ok):
        json_object = json.loads(r.text)
        print(json_object)
        to_restart = []
        for i in range(0, len(json_object)):
            #we only want the results having some labels, and whose name matches the stack
            if len(json_object[i]["Labels"]) > 0:
                print(json_object[i]["Labels"])
                compose_proj = json_object[i]["Labels"]["com.docker.stack.namespace"]
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

if args.env == 'PRD':
    host = os.getenv('PORTAINER_PRD_HOST')
    passwd = os.getenv('PORTAINER_PRD_PASS')
    branch = os.getenv('PORTAINER_PRD_BRANCH')
    token = get_api_token(host, port, user, passwd)

if args.env == 'DEV':
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
swarm_ID = get_swarm_id(host, port, head)

#determine most recent change to git repo
git_dir = args.repo[0]
#TODO: can use only the cmd_PRD?
#get only the last commit
cmd_dev = ['git', '-C', git_dir, '--no-pager', 'log', '-1', '--stat']
#get the latest merge, and filter out everything but the files
cmd_prd = ['git', '-C', git_dir, '--no-pager', 'log', '-m', '-1', '--name-only']

#choose between the commands
if args.env == 'PRD':
    cmd = cmd_prd
else:
    cmd = cmd_dev

res = subprocess.check_output(cmd)
output = res.decode().splitlines()
print(output)
changed_files = []

#PRD
if args.env == 'PRD':
    #the assumption is all files we potentially want to take action on will have at least 1 / in them
    for line in output:
        if '/' in line:
            tmp = line.strip()
            changed_files.append(tmp)

#DEV
else:
    #need to know how many files were changed:
    last_line = output[-1]
    last_words = last_line.split()

    change_count = None
    try:
        change_count = int(last_words[0])
    except:
        print('error parsing git output')
        sys.exit(1)

    #using that number, get that number of lines before the last line
    #then split those lines getting the files
    for i in range(len(output)-2, len(output)-change_count-2, -1):
        tmp = output[i].split()
        changed_files.append(tmp[0])

print(changed_files)

to_restart = []
to_recreate = []
to_delete = []
stack_changes = []

#next, figure out which directories contain changed files
for file in changed_files:
    tmp = file.split('/')
    #if the file is in the archive or scripts folders, ignore
    if ((tmp[0] != 'scripts') and (tmp[0] != 'archive')):
    #if the file is in the root of the repo, it is ignored
        if len(tmp) > 1:
            #a change to a docker compose file means we need to restart the stack
            if 'docker-compose.yml' in tmp[-1]:
                #if its a stack related change, register it as such
                stack_changes.append(tmp[0])
                
                #if the file exists, we need to re-create
                #get absolute path:
                full_path = git_dir + '/' + file
                if os.path.isfile(full_path):
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
    

for stack in to_restart:
    if stack in stack_changes:
        #if the stack is in the reastart and re-create lists, only need to re-create
        to_restart.remove(stack)
        print('dont restart stack: {}'.format(stack))

#if the env is PRD, all stacks get re-created:
if args.env == 'PRD':
    for stack in to_restart:
        to_recreate.append(stack)

#delete stack
for stack in to_delete:
    #run the command to delete the stack
    remove_stack_by_name(host, port, head, stack, endpoint_id)

#recreate
for stack in to_recreate:
    #run the command to re-create the stack

    #this will check if the stack already exists, and delete it if it does
    remove_stack_by_name(host, port, head, stack, endpoint_id)

    #if no error, create stack
    create_stack(host, port, head, endpoint_id, remote_repo, branch, stack, swarm_ID)

#restart
for stack in to_restart:
    #run the command to restart the stack
    restart_stack(host, port, head, stack, endpoint_id)
