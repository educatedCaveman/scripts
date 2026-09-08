import os
import hashlib
import requests
import getpass
import xmltodict
import tabulate
import sys
import time

# retrieve the required connection details
SERVER = input("navidrome server URL(:port)?:")
UN = input("navidrome username?:")
PW = getpass.getpass("navidrome password? (text hidden):")


def get_auth_payload(username=UN, password=PW, version='1.16.1', client='python') -> dictionary:
    salt = os.urandom(6).hex()
    token = hashlib.md5(f"{password}{salt}".encode('utf-8')).hexdigest()
    print({
        'u': username, 
        't': token, 
        's': salt, 
        'v': version, 
        'c': client
    })
    return {
        'u': username, 
        't': token, 
        's': salt, 
        'v': version, 
        'c': client
    }


# request the playlists, and convert the XML response to a dictionary
get_playlists_req = f"{SERVER}/rest/getPlaylists"
playlists_resp = requests.get(get_playlists_req, params=get_auth_payload())
resp = xmltodict.parse(playlists_resp.text)

# check for a good response the first time
req_stus = resp['subsonic-response']['@status']
if req_stus == 'ok':
    # dissect the reponse for display to the user, which allows an informed user response later
    header = ['index', 'name', 'comment', 'song_count', 'id']
    playlists = []
    for i, pl in enumerate(resp['subsonic-response']['playlists']['playlist']):
        playlists.append([
            i,
            pl['@name'],
            pl['@comment'],
            pl['@songCount'],
            pl['@id']
        ])

    print(tabulate.tabulate(playlists, headers=header, maxcolwidths=40, tablefmt="fancy_grid"))

# on error, print the message, and exit
else:
    print(resp['subsonic-response']['error']['@message'])
    sys.exit(1)

# interrogate the user for more information
try:
    pl_index = int(input('select playlist index: '))
    if int(pl_index) > len(playlists) - 1:
        raise ValueError
except ValueError:
    print('you must enter a valid index!')
    sys.exit(1)

try:
    pl_rating = int(input('rating to apply (0-5)?: '))
    if int(pl_rating) > 5 or int(pl_rating) < 0:
        raise ValueError
except ValueError:
    print('you must enter a valid rating!')
    sys.exit(1)

print('fetching songs...')

# fetch the playlist
songs_req = f"{SERVER}/rest/getPlaylist"
payload = get_auth_payload()
payload['id'] = playlists[pl_index][4]
songs_resp = requests.get(songs_req, params=payload)
resp = xmltodict.parse(songs_resp.text)

# rate the songs, one-by-one
print('rating songs...')
for i, song in enumerate(resp['subsonic-response']['playlist']['entry']):
    song_id = song['@id']
    rating_req = f"{SERVER}/rest/setRating"
    payload = get_auth_payload()
    payload['id'] = song['@id']
    payload['rating'] = pl_rating
    rating_resp = requests.get(rating_req, params=payload)
    resp = xmltodict.parse(rating_resp.text)

    # check for a response, in case there is some kind of a rate-limit/reject
    if resp['subsonic-response']['@status'] == 'ok':
        print(f"rated song {i+1}/{playlists[pl_index][3]}:\t{song['@path']}")
        time.sleep(0.2)
    else:
        # print(resp['subsonic-response']['error']['@message'])
        sys.exit(1)
        
print('done!')