import argparse
import shutil
import os
from pathlib import Path

# Supported parameters (case sensitive):
#     %N: Torrent name
#     %L: Category
#     %G: Tags (separated by comma)
#     %F: Content path (same as root path for multifile torrent)
#     %R: Root path (first torrent subdirectory path)
#     %D: Save path
#     %C: Number of files
#     %Z: Torrent size (bytes)
#     %T: Current tracker
#     %I: Info hash

# --name="%N"
# --category="%L"
# --tags="%G"
# --cpath="%F"
# --rpath="%R"
# --spath="%D"
# --num="%C"
# --size="%Z"
# --tracker="%T"
# --hash="%I"

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
    'Function to remove empty folders'
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

# TODO: notification that download has completed?

# TODO: source these paths from an INI or something?
destinations = {
    "Movies":   '/mnt/mobius/Video/Movies',
    "TV":       '/mnt/mobius/Video/TV-shows',
    "Music":    '/mnt/mobius/Music/staging',
    "other":    ''
}
text_files = combine_upper_lower(['*.nfo', '*.txt', '*.md'])
img_files = combine_upper_lower(['*.jpg', '*.png', '*.jpeg', '*.gif', '*.bmp', '*.raw', '*.tiff'])
# SOURCE = '/home/drake/test_src/'
# DEST = '/home/drake/test_dest/'

SOURCE = args.cpath

# Movies/TV
if args.category in ("Movies", "TV_Shows"):
    # set the destination:
    DEST = destinations["TV"]
    if args.category == "Movies":
        DEST = destinations["Movies"]

    text_and_img_files = text_files + img_files
    shutil.copytree(SOURCE, DEST)
    clean_files_to_ignore(DEST, text_and_img_files)
    remove_empty_dirs(DEST)

# Music
# should .log and .cue files be kept for music?  for now, yes
elif args.category == "Music":
    DEST = destinations["Music"]
    shutil.copytree(SOURCE, DEST)
    clean_files_to_ignore(DEST, text_files)
    remove_empty_dirs(DEST)

#other
else:
    pass

# TODO: notification that files have been moved into the appropriate directory?
# send an output of the tree command in the message

# trigger a rescan of the appropriate plex library?
