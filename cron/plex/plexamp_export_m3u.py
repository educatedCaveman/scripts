from plexapi.server import PlexServer
from tabulate import tabulate

PLAYLIST_PATH = '/home/drake'
PLAYLIST_PATH = '/tmp'
PLEX_PATH = '/mnt/mobius/Music/'
BASEURL = 'http://plex.vm:32400'
TOKEN = 'redacted'
HEADER = '#EXTM3U'
PREFIX = '#EXTINF:,'

# start by interrogating the plex database/library
plex = PlexServer(BASEURL, TOKEN)

print('retrieving all tracks from plex')
tracks = plex.library.search(libtype='track')
plex_list = []

# construct a datastructure with all the necessary info:
# - file path (track.media.part.file)
# - song title (display name; track.title)
# - rating (track.userRating)
print('parsing track info')
for track in tracks:
    try:
        track_rating = round(track.userRating / 2)
    except TypeError as e:
        track_rating = 0

    song_dict = {
        "title":    track.title,
        "file":     track.media[0].parts[0].file.replace(PLEX_PATH, ''),
        "rating":   track_rating
    }
    plex_list.append(song_dict)

# print(tabulate(plex_list))

# create the rating-based playlists
# loop through the previously created datastructure.
# for each track, inspect the rating, adding it to the appropriate playlists.

playlists = {
    "5_stars":      [],
    "4_stars":      [],
    "3_stars":      [],
    "2_stars":      [],
    "1_star":       [],
    "unrated":      [],
    "5-3_stars":    [],
    "5-4_stars":    []
}

for track in plex_list:
    # 5 stars
    if track['rating'] == 5:
        playlists['5_stars'].append(track)
        playlists['5-3_stars'].append(track)
        playlists['5-4_stars'].append(track)

    # 4 stars
    elif track['rating'] == 4:
        playlists['4_stars'].append(track)
        playlists['5-3_stars'].append(track)
        playlists['5-4_stars'].append(track)

    # 3 stars
    elif track['rating'] == 3:
        playlists['3_stars'].append(track)
        playlists['5-3_stars'].append(track)

    # 2 stars
    elif track['rating'] == 2:
        playlists['2_stars'].append(track)

    # 1 stars
    elif track['rating'] == 1:
        playlists['1_star'].append(track)

    # unrated
    else:
        playlists['unrated'].append(track)

# print(tabulate(playlists))

for playlist, tracks in playlists.items():
    # create a list of lines to write out as the playlist
    data = []
    data.append(str(HEADER + '\n'))
    for track in tracks:
        info_line = str(PREFIX + track['title'] + '\n')
        file_line = str(track['file'] + '\n')
        data.append(info_line)
        data.append(file_line)

    with open(f"{PLAYLIST_PATH}/{playlist}.m3u", 'w') as f:
        f.writelines(data)
