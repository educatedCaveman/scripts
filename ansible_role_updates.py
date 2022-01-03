import argparse
import subprocess


# set up argument parsing
parser = argparse.ArgumentParser(description='interrogate.')
parser.add_argument('--repo', required=True, nargs=1, type=str)
#parse the arguments
args = parser.parse_args()


# determine the most recent git changes
git_dir = args.repo[0]
cmd = ['git', '-C', git_dir, '--no-pager', 'log', '-m', '-1', '--name-only']
res = subprocess.check_output(cmd)
output = res.decode().splitlines()
# print(output)

changed_files = []
for line in output:
    if '/' in line:
        tmp = line.strip()
        changed_files.append(tmp)

# print(len(changed_files))

# filter the files changed
changed_roles = []
for file in changed_files:
    tmp = file.split('/')
    # print(tmp)
    if (tmp[0] == 'roles'):
        changed_roles.append(file)
    # print(file)


print(changed_roles)

# determine if any of the roles changed


# if so, check for the role update playbook


# if the playbook exists, run it.

