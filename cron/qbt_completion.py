import argparse
import shutil
import os
from pathlib import Path
import requests
import subprocess

WEBHOOK = os.getenv('DISCORD_WEBHOOK_QBT')

# --name=       "%N"    Torrent name
# --category=   "%L"    Category
# --tags=       "%G"    Tags (separated by comma)
# --cpath=      "%F"    Content path (same as root path for multifile torrent)
# --rpath=      "%R"    Root path (first torrent subdirectory path)
# --spath=      "%D"    Save path
# --num=        "%C"    Number of files
# --size=       "%Z"    Torrent size (bytes)
# --tracker=    "%T"    Current tracker
# --hash=       "%I"    Info hash

# takes a list of lower case files, duplicates them all as upper case,
# and returns the combined list
def combine_upper_lower(lower):
    upper = []
    for file in lower:
        upper.append(file.upper())
    files = upper + lower
    return files


def clean_files_to_ignore(to_clean, to_ignore):
    for ignore in to_ignore:
        for path in Path(to_clean).rglob(ignore):
            os.remove(path)


def remove_empty_dirs(path, removeRoot=True):
    if not os.path.isdir(path):
        return

    # remove empty subfolders
    files = os.listdir(path)
    if len(files):
        for file in files:
            fullpath = os.path.join(path, file)
            if os.path.isdir(fullpath):
                remove_empty_dirs(fullpath)

    # if folder empty, delete it
    files = os.listdir(path)
    if len(files) == 0 and removeRoot:
        print("Removing empty folder:", path)
        os.rmdir(path)


# must handle the copy differently depending on if its a dir or a file
def copy_files(source, dest):

    # directory
    if os.path.isdir(source):
        shutil.copytree(source, dest)

    # file
    else:
        shutil.copy(source, dest)


def send_discord_message(webhook, message):
    content = {
        "content":  message
    }
    r = requests.post(webhook, data=content)
    print(r.status_code)


def error_message(webhook, error):
    body = f"""The qBittorrent completion script (qbt_completion.py) failed with the following error:

        ```python
        {error}
        ```
        """
    send_discord_message(webhook=webhook, message=body)


def send_notification(webhook, path, args):
    destination_path = str(path + '/' + args.name)
    if os.path.isdir(destination_path):
        cmd = ['tree', destination_path]
        tree = subprocess.run(cmd, capture_output=True, text=True)    
        body = f"""A download has completed:

            {args.name}

            {tree}

            if this looks wrong, manually investigate
        
        """
    else:
        body = f"""A download has completed:

            {args.name}
        
        """
    send_discord_message(webhook=webhook, message=body)


def main():
    #argument parsing:
    parser = argparse.ArgumentParser(description='cleanup files on torrent completion')

    # recieve all the info from qBittorrent
    parser.add_argument('--name',       required=True, type=str)
    parser.add_argument('--category',   required=True, type=str)
    parser.add_argument('--tags',       required=True, type=str)
    parser.add_argument('--cpath',      required=True, type=str)
    parser.add_argument('--rpath',      required=True, type=str)
    parser.add_argument('--spath',      required=True, type=str)
    parser.add_argument('--num',        required=True, type=str)
    parser.add_argument('--size',       required=True, type=str)
    parser.add_argument('--tracker',    required=True, type=str)
    parser.add_argument('--hash',       required=True, type=str)

    #parse the arguments
    args = parser.parse_args()

    # TODO: source these paths from an INI or something?
    destinations = {
        "Movies":   '/mnt/mobius/Video/Movies',
        "TV":       '/mnt/mobius/Video/TV-shows',
        "Music":    '/mnt/mobius/Music/staging',
        # "other":    '/mnt/mobius/staging/'
    }
    text_files = combine_upper_lower(['*.nfo', '*.txt', '*.md'])
    img_files = combine_upper_lower(['*.jpg', '*.png', '*.jpeg', '*.gif', '*.bmp', '*.raw', '*.tiff'])

    SOURCE = args.cpath

    # Movies/TV
    if args.category in ("Movies", "TV_Shows"):
        print('we have a movie or a TV show')
        # set the destination:
        DEST = destinations["TV"]
        if args.category == "Movies":
            DEST = destinations["Movies"]

        # combine file types to ignore/remove
        text_and_img_files = text_files + img_files

        # if the source is a directory, more things need doing
        # - copy files to new folder
        # - clean up undesired files
        # - remove empty directories
        # - if there is a single file in the top directory:
        #   - move that one level higher
        #   - remove the directory
        if os.path.isdir(SOURCE):
            print('source is a directory')

            # get the containing folder and create the destination path (folder)
            folder = SOURCE.split('/')[-1]
            dest_dir = str(DEST + '/' + folder)

            copy_files(SOURCE, dest_dir)
            clean_files_to_ignore(DEST, text_and_img_files)

            # only clean the new directory
            remove_empty_dirs(dest_dir)

            # handle single files in a folder
            num_files = len(os.listdir(dest_dir))
            if num_files == 1:
                file_name = os.listdir(dest_dir)[0]
                source_path = str(dest_dir + '/' + file_name)
                shutil.move(source_path, DEST)
                os.rmdir(dest_dir)
            else:
                # multiple files/folders remaining
                pass

        # if the source is a single file, things are simple
        # really only applies to movies
        else:
            # no need to clean files, or remove empty dirs
            copy_files(SOURCE, DEST)

    # Music
    # should .log and .cue files be kept for music?  for now, yes
    elif args.category == "Music":
        # because music is almost always going to be a directory, things are simplified
        DEST = destinations["Music"]
        folder = SOURCE.split('/')[-1]
        dest_dir = str(DEST + '/' + folder)

        copy_files(SOURCE, dest_dir)
        clean_files_to_ignore(DEST, text_files)

        # only clean the new directory
        remove_empty_dirs(dest_dir)

    # #other
    # else:
    #     # TODO: add handling for .iso and related files?
    #     pass

    # TODO: trigger a rescan of the appropriate plex library?
    send_notification(WEBHOOK, DEST, args)

if __name__=="__main__":
    try:
        main()
    except Exception as e:
        error_message(WEBHOOK, e)
