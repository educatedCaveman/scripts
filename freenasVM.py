#!/usr/local/bin/python
import requests
import pprint
import sys
import getpass
from tabulate import tabulate

#construct URL
freenas = 'mobius.srv'
request_url = 'http://%s/api/v2.0/vm' % freenas

#get username/PW
user = input("username for freenas: ")
pw = getpass.getpass()
authdata = (user, pw)

#get vm list
r = requests.get(request_url, auth=authdata)
pp = pprint.PrettyPrinter(indent=4)
# pp.pprint(r.json())

#make table of basic VM info:
vm_table = []
vm_headers = ['ID', 'name', 'state']
for vm in r.json():
    vm_id = vm['id']
    vm_name = vm['name']
    vm_state = vm['status']['state']
    tmp = [vm_id, vm_name, vm_state]
    vm_table.append(tmp)

print(tabulate(vm_table, vm_headers))
print()

start_input = input("which VMs should be started? (space separated list): ").split()
print()

#convert list of strings to ints, ignoring anything that isnt an int
to_start = []
for n in start_input:
    try:
        tmp = int(n)
        to_start.append(tmp)
    except:
        pass

#need error handling. ignore requests not present, and ones already started
start_vm = []
for vm in vm_table:
    if vm[0] in to_start and vm[2] != 'RUNNING':
        start_vm.append(vm)

print("VMs to start:")
print(tabulate(start_vm, vm_headers))
print()

print("starting VMs...")
for vm in start_vm:
    requests.post('http://{}/api/v2.0/vm/id/{}/start'.format(freenas, vm[0]), auth=authdata)
print("done!")
print("check the FreeNAS UI to verify")
