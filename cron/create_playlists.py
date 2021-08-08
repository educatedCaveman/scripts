import json
import xmltodict
import urllib.parse as url
import shutil
import os
import glob
import sys

# TODO: handle all other playlists?
#   - inspect playlists.xml for that.

db_source = '/home/drake/.local/share/rhythmbox/rhythmdb.xml'
xml_db = '/tmp/rhythmdb.xml'
mobile_lib = '/media/storage/Music_(mobile)/'

library = {}
songs = []

# define the playlists as a dict
# makes looping possible/easier
playlists = {
    "5_stars":      {"songs": [], "file": "5 stars.m3u"},
    "4_5_stars":    {"songs": [], "file": "4-5 stars.m3u"},
    "3_4_5_stars":  {"songs": [], "file": "3-5 stars.m3u"},
    "4_stars":      {"songs": [], "file": "4 stars.m3u"},
    "3_stars":      {"songs": [], "file": "3 stars.m3u"},
    "2_stars":      {"songs": [], "file": "2 stars.m3u"},
    "1_star":       {"songs": [], "file": "1 star.m3u"},
    "unrated":      {"songs": [], "file": "unrated.m3u"},
}

# clear /tmp
if os.path.exists(xml_db):
    os.remove(xml_db)

for m3u in glob.glob('/tmp/*.m3u'):
    os.remove(m3u)

# first, copy the xml file to /tmp
shutil.copyfile(db_source, xml_db)

# convert the XML to a dict, bc its easier
with open(xml_db) as xml_file:      
    data_dict = xmltodict.parse(xml_file.read())
    library = data_dict

# construct the simplified version of the library, while filtering out non-song things
for item in library['rhythmdb']['entry']:
    if item['@type'] == 'song':
        # set the title; nothing special
        title = item['title']

        # prep the location string:
        #   - fix the URL encoding; set to UTF-8
        #   - remove the leading path "file:///media/storage/Music/"
        #   - replace .flac extentions with .ogg
        location = item['location']
        location = url.unquote(location, encoding='utf-8')
        location = location[28:]
        if location[-5:] == '.flac':
            location = str(location[:-5] + '.ogg')

        # the rating may not exist, so set to 0 if its missing:
        try:
            rating = int(item['rating'])
        except:
            rating = 0

        # add the song to the simplified list
        song_dict = {
            "title":    title,
            "location": location,
            "rating":   rating
        }
        songs.append(song_dict)

# sort the list of all songs, using the the file path:
songs.sort(key=lambda x: x['location'])
 
# create the playlists:
for song in songs:
    # 5 stars 
    if song['rating'] == 5:
        playlists['5_stars']['songs'].append(song)
        playlists['4_5_stars']['songs'].append(song)
        playlists['3_4_5_stars']['songs'].append(song)
        
    # 4 stars
    if song['rating'] == 4:
        playlists['4_stars']['songs'].append(song)
        playlists['4_5_stars']['songs'].append(song)
        playlists['3_4_5_stars']['songs'].append(song)

    # 3 stars
    if song['rating'] == 3:
        playlists['3_stars']['songs'].append(song)
        playlists['3_4_5_stars']['songs'].append(song)

    # 2 stars
    if song['rating'] == 2:
        playlists['2_stars']['songs'].append(song)

    # 1 stars
    if song['rating'] == 1:
        playlists['1_star']['songs'].append(song)

    # 0 stars (unrated)
    if song['rating'] == 0:
        playlists['unrated']['songs'].append(song)


# construct the playlist files:
header = '#EXTM3U\n'

for pl in playlists:
    songs = playlists[pl]['songs']
    file = playlists[pl]['file']
    full_path = str('/tmp/' + file)

    with open(full_path, 'w') as m3u_file:
        # write the header once
        m3u_file.write(header)

        # write the song lines
        for song in songs:
            # title
            title = str(song['title'].strip())
            title_line = str('#EXTINF:,' + title + '\n')
            m3u_file.write(title_line)

            # location/path
            loc_line = str(song['location'] + '\n')
            m3u_file.write(loc_line)

    # move files to mobile library, overwriting the existing file
    dest = str(mobile_lib + file)
    shutil.move(full_path, dest)

# cleanup:
os.remove(xml_db)
# remove playlist files?

