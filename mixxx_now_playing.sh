#!usr/bin/env python

import re 
import sqlite3
import subprocess
import time


def currentPlaylist(conn):
	sqlite_select_query = """select playlist_id from PlaylistTracks pt where id = 
    	(select max(id) from PlaylistTracks)"""
    	cursor = conn.cursor()
        cursor.execute(sqlite_select_query)
        playlist = cursor.fetchone()[0]
        print "Current Playlist: %s" % playlist
        cursor.close()
        return(playlist)

def currentSong(conn):
	query = "SELECT library.artist, library.title, library.year  FROM main.library WHERE id = (SELECT track_id from PlaylistTracks WHERE playlist_id = %s ORDER BY position DESC limit 1)" % (currentPlaylist(conn))
	sqlite_select_query = query
    	cursor = conn.cursor()
        cursor.execute(sqlite_select_query)
        song = cursor.fetchone()
        cursor.close()
        return(song)

        
def create_connection(db_file):
    conn = None
    try:
        return sqlite3.connect(db_file)
    except Error as e:
        print(e)
        
def is_runnning(app):
    count = int(subprocess.check_output(["osascript",
                "-e", "tell application \"System Events\"",
                "-e", "count (every process whose name is \"" + app + "\")",
                "-e", "end tell"]).strip())
    return count > 0



def main():
	conn = create_connection('/Users/kiisu/Library/Application Support/Mixxx/mixxxdb.sqlite')
	while is_runnning("mixxx"):
# 		print currentPlaylist(con)
		print currentSong(conn)
		time.sleep(5)

if __name__ == "__main__":
    main()