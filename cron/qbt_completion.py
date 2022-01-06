import argparse


"""
Supported parameters (case sensitive):
    %N: Torrent name
    %L: Category
    %G: Tags (separated by comma)
    %F: Content path (same as root path for multifile torrent)
    %R: Root path (first torrent subdirectory path)
    %D: Save path
    %C: Number of files
    %Z: Torrent size (bytes)
    %T: Current tracker
    %I: Info hash

Tip: Encapsulate parameter with quotation marks to avoid text being cut off at whitespace (e.g., "%N")

--name="%N"
--category="%L"
--tags="%G"
--cpath="%F"
--rpath="%R"
--spath="%D"
--num="%C"
--size="%Z"
--tracker="%T"
--hash="%I"
"""

#argument parsing:
parser = argparse.ArgumentParser(description='cleanup files on torrent completion')

#get the environment, and the repo path:
# parser.add_argument('--env', required=True, choices=['PRD', 'DEV'])
# parser.add_argument('--repo', required=True, nargs=1, type=str)
# parser.add_argument('--action', required=True, choices=['UP', 'DOWN', 'DOWNUP'])

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

# only include lower case. will call .lower() on all extensions
text_files = ['nfo', 'txt', 'md']
image_files = ['jpg', 'png', 'jpeg', 'gif', 'bmp', 'raw', 'tiff']
destinations = {
    "Movies":   '/mnt/mobius/Video/Movies',
    "TV":       '/mnt/mobius/Video/TV-shows',
    "Music":    '/mnt/mobius/Music/staging',
    "other":    ''
}

# should .log and .cue files be kept for music?  for now, yes


with open('/tmp/test.txt', 'w') as my_file:
    my_file.writelines(args)





