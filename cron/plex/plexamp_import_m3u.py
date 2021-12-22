from pathlib import Path
import sys
# from tabulate import tabulate
from plexapi.server import PlexServer
import requests
PLAYLIST_PATH = '/media/storage/Music_(mobile)'
PLAYLISTS = ['5_stars.m3u', '4_stars.m3u', '3_stars.m3u', '2_stars.m3u', '1_star.m3u']
IGNORE_LINES = ['#EXTM3U', '#EXTINF']

# create a collection of paths and plex IDs
BASEURL = 'http://plex.vm:32400'
# eventually retrieve from an env var or something
TOKEN = 'redacted'
plex = PlexServer(BASEURL, TOKEN)

print('retrieving all tracks from plex')
tracks = plex.library.search(libtype='track')
plex_list = []

print('parsing track info')
for track in tracks:
    track_id = track.ratingKey
    track_file = track.media[0].parts[0].file.replace('/mnt/mobius/Music/', '')
    song_dict = {
        "file":     track_file,
        "plex_ID":  track_id
    }
    plex_list.append(song_dict)

print('parsing playlist')
for playlist in PLAYLISTS:
    print(f'working on playlist: {playlist}')
    file_path = f'{PLAYLIST_PATH}/{playlist}'
    print(file_path)

    # import each playlist
    # check if the file exists first
    path = Path(file_path)
    if not path.is_file():
        print(f'{playlist} file does not exist or is not a file.')
        sys.exit(1)

    FILE_RATING = int(playlist[:1])
    PLEX_RATING = FILE_RATING * 2

    with open(file_path) as fp:
        playlist_lines = []
        plex_IDs = []
        lines = fp.read().splitlines()
        for line in lines:
            start = line[:7]
            if start not in IGNORE_LINES:

                song_id = next( \
                    (item.get('plex_ID') for item in plex_list if item["file"] == line), None)

                if song_id is None:
                    print("match not found")
                    print(line)
                    sys.exit(1)
                else:
                    plex_IDs.append(song_id)

                song_line = {
                    "ID":       song_id,
                    "path":     line,
                    "rating":   PLEX_RATING
                }
                playlist_lines.append(song_line)

    print('begin contructing API query')
    # create comma-delimited list of IDs
    ID_LIST = ''
    for x in range(0, len(plex_IDs) -1):
        ID_LIST = str(ID_LIST + f"{plex_IDs[x]},")
    #add last item w/o the comma:
    ID_LIST = str(ID_LIST + f"{plex_IDs[x]}")

    #TODO: parameterize this more.
    request_url = f"{BASEURL}/library/sections/6/all?type=10&id={ID_LIST}&userRating.value={PLEX_RATING}"
    r = requests.put(url=request_url)
    if r.ok:
        print('request ok')
    else:
        print(r)
        print(r.text)
        print(r.content)

    print('done!')
    print()
