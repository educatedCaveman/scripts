#!/usr/bin/python
# check for the pihole backup to have been performed sucessfully

from datetime import datetime
import os
from glob import glob
import subprocess
from slack_webhook import Slack

path = '/mnt/mobius/Backup/pihole'
d = datetime.today()
d_str = d.strftime("%F")
pi_file = 'pi-hole-singularity-teleporter_{}_*.tar.gz'.format(d_str)
#TODO: get pihole specific webhook
webhook = os.getenv('SLACK_WEBHOOK_PIHOLE')
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

    slack = Slack(url=webhook)
    slack.post(text=message)

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

    slack = Slack(url=webhook)
    slack.post(text=message)


def backup_found():
    ls = subprocess.Popen(['ls', '-lt', path], stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)
    head = subprocess.Popen(['head', '-2'], stdin=ls.stdout, stdout=subprocess.PIPE, text=True)
    tail = subprocess.Popen(['tail', '-1'], stdin=head.stdout, stdout=subprocess.PIPE, text=True)
    res = tail.communicate()

    message = """
    Pi-Hole backup SUCCEEDED! Backup file created.  The most recent file is: ```{}```
    Qapla'!
    """.format(res[0])

    slack = Slack(url=webhook)
    slack.post(text=message)


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
    else:
        backup_found()
else:
    nfs_not_mounted()
