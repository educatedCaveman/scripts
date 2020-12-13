#!/usr/local/bin/python
import subprocess
import sys
import os

if len(sys.argv) != 2:
    print('incorrect number of arguments. exiting...')
    sys.exit(1)

# git_dir = '/home/drake/docker-lab'
git_dir = sys.argv[1]
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

for stack in to_delete:
    #run the command to delete the stack
    pass

for stack in to_recreate:
    #run the command to re-create the stack
    pass

for stack in to_restart:
    #run the command to restart the stack
    pass
