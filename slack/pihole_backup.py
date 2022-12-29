#!/usr/bin/python
# check for the pihole backup to have been performed sucessfully

from datetime import datetime
import os
from glob import glob
import subprocess
# from slack_webhook import Slack
import requests
from tabulate import tabulate

path = '/mnt/mobius/Backup/pihole'
d = datetime.today()
d_str = d.strftime("%F")
pi_file = 'pi-hole-singularity-teleporter_{}_*.tar.gz'.format(d_str)
version_file = 'new_version'
#TODO: get pihole specific webhook
# webhook = os.getenv('SLACK_WEBHOOK_PIHOLE')
webhook = os.getenv('DISCORD_WEBHOOK_PIHOLE')
def nfs_not_mounted():
    # print('NFS not mounted')
    cmd = ['df', '-h']
    res = subprocess.run(cmd, capture_output=True, text=True)

    message = """
    Pi-Hole backup FAILED! Backup directory not present.

    the following is the output of `df -h`:

    ```{}```

    manual investigation is necessary.
    """.format(res.stdout)

    content = {
        "content":  message
    }
    requests.post(webhook, data=content)


def backup_not_found():
    ls = subprocess.Popen(['ls', '-lt', path], stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)
    head = subprocess.Popen(['head', '-11'], stdin=ls.stdout, stdout=subprocess.PIPE, text=True)
    tail = subprocess.Popen(['tail', '-10'], stdin=head.stdout, stdout=subprocess.PIPE, text=True)
    res = tail.communicate()

    message = """
    Pi-Hole backup FAILED! Backup file not present.  The 10 most recent files are thus:

    ```{}```

    manual investigation is necessary.
    """.format(res[0])

    content = {
        "content":  message
    }
    requests.post(webhook, data=content)


def backup_found():
    ls = subprocess.Popen(['ls', '-lt', path], stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)
    head = subprocess.Popen(['head', '-2'], stdin=ls.stdout, stdout=subprocess.PIPE, text=True)
    tail = subprocess.Popen(['tail', '-1'], stdin=head.stdout, stdout=subprocess.PIPE, text=True)
    res = tail.communicate()

    message = """
    Pi-Hole backup SUCCEEDED! Backup file created.  The most recent file is: ```{}```
    Qapla'!
    """.format(res[0])

    content = {
        "content":  message
    }
    requests.post(webhook, data=content)


def format_version(version_str):
    version_list = []
    for version in version_str.split('\n'):
        if len(version) > 0:
            version_list.append(version.split())
    
    version_dict = {
        "pihole":   f"{version_list[0][4]}",
        "adminLTE": f"{version_list[1][4]}",
        "FTL":      f"{version_list[2][4]}",
    }
    return version_dict


def version_check():
    """
    drake@singularity ~ > pihole -v -l
        Latest Pi-hole version is v5.14.2
        Latest AdminLTE version is v5.18
        Latest FTL version is v5.20
    drake@singularity ~ > pihole -v -c
        Current Pi-hole version is v5.14.1
        Current AdminLTE version is v5.17
        Current FTL version is v5.19.2
    """

    # fetch the versions:
    cur_ver = format_version(subprocess.check_output(['pihole', '-v', '-c'], text=True))
    max_ver = format_version(subprocess.check_output(['pihole', '-v', '-l'], text=True))

    # check versions
    pihole_diff = False
    admin_diff = False
    ftl_diff = False

    diff_details = []

    if cur_ver['pihole'] != max_ver['pihole']:
        pihole_diff = True
        diff_details.append(['Pi-hole', cur_ver['pihole'], max_ver['pihole']])

    if cur_ver['adminLTE'] != max_ver['adminLTE']:
        admin_diff = True
        diff_details.append(['AdminLTE', cur_ver['adminLTE'], max_ver['adminLTE']])

    if cur_ver['FTL'] != max_ver['FTL']:
        ftl_diff = True
        diff_details.append(['FTL', cur_ver['FTL'], max_ver['FTL']])

    version_diff = pihole_diff or admin_diff or ftl_diff


    # if new version, check if the version_file exists
    version_file_path = '/'.join(path, version_file)
    version_file_exists = os.path.isfile(version_file_path)
    if version_diff:
        # if there is a new version, and we don't already have a version_file, 
        # send a notification of a new version, and create the version_file
        # if we have a version file already, do nothing
        if not version_file_exists:
            # TODO: send notification
            headers = ['Component', 'Current Version', 'Latest Versioni']
            update_details = tabulate(diff_details, headers, tablefmt='fancy_grid')
            message = f"There is an update for Pi-Hole available:\n```{update_details}```"
            content = {
                "content":  message
            }
            requests.post(webhook, data=content)

            # create version file
            with open(version_file_path, 'w') as f:
                f.write(max_ver)

    # if there isn't a new version, but there is a version file, remove the version file
    elif version_file_exists:
        os.remove(version_file_path)



# main logic:
# if the directory is not mounted, error out and send notification
# if the directory is mounted, but the backup file isn't present, 
#   error out and send notification
# else, the backup is present, so send sucess notificaton

isDir = os.path.isdir(path)
if isDir:
    search_path = path + '/' + pi_file
    bkup_files = glob(search_path)
    if len(bkup_files) == 0:
        backup_not_found()
    # send inform message on sunday only
    elif d.weekday() == 6:
        backup_found()
else:
    nfs_not_mounted()

# check for new version
version_check()