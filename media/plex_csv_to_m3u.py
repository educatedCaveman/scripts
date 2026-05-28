import csv

BASE_DIR = "/home/drake/Downloads/WebTools-NG/ExportTools"
plex_csvs = [
    {
        "csv": f"{BASE_DIR}/plex_VM_1_Star_Playlist_Audio__Item 0-942_2026.05.28_12.22.47.csv",
        "m3u": f"{BASE_DIR}/1-stars.m3u"
    },
    {
        "csv": f"{BASE_DIR}/plex_VM_2_Stars_Playlist_Audio__Item 0-3642_2026.05.28_12.18.47.csv",
        "m3u": f"{BASE_DIR}/2-stars.m3u"
    },
    {
        "csv": f"{BASE_DIR}/plex_VM_3_Stars_Playlist_Audio__Item 0-4521_2026.05.28_12.13.58.csv",
        "m3u": f"{BASE_DIR}/3-stars.m3u"
    },
    {
        "csv": f"{BASE_DIR}/plex_VM_4_Stars_Playlist_Audio_Level 2_Item 0-3423_2026.05.28_12.13.10.csv",
        "m3u": f"{BASE_DIR}/4-stars.m3u"
    },
    {
        "csv": f"{BASE_DIR}/plex_VM_5_Stars_Playlist_Audio_Level 2_Item 0-2543_2026.05.28_12.00.14.csv",
        "m3u": f"{BASE_DIR}/5-stars.m3u"
    },
]
prefix_sub = {"from": "/mnt/mobius/Music", "to": "/music"}

for stars in plex_csvs:
    csv_path = stars["csv"]
    m3u_path = stars["m3u"]

    with open(csv_path, 'r') as f_in, open(m3u_path, 'w') as f_out:
        # write the filename to the file
        f_out.write(f"# {m3u_path.split('/')[-1].replace(prefix_sub['from'], prefix_sub['to'])}\n")

        data = csv.reader(f_in, delimiter='|', quotechar='"')
        # skip the header
        _ = next(data)
        for row in data:
            f_out.write(f"{row[9]}\n")

