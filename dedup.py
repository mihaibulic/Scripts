#!/usr/bin/python
#outputs list of duplicates

import sys
import os
import pprint
import subprocess
import pickle
import atexit
import simplejson as json

sys.path.insert(0, "/home/mihai/echoprint-server/API/")
import fp

_codegen_path = "/home/mihai/echoprint-codegen/echoprint-codegen"

done = {}

def codegen(filename, start=0, duration=60):
    """ runs codegen on the given file, returns a tuple with
        the track id, a code string for lookup, and a codegen
        block for ingest
    """

    if not os.path.exists(_codegen_path):
        raise Exception("Codegen binary not found.")

    command = _codegen_path + " \"" + filename + "\" " 
    if start >= 0:
        command = command + str(start) + " "
    if duration >= 0:
        command = command + str(duration)

    p = subprocess.Popen(command, shell=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    (json_block, errs) = p.communicate()

    try:
        return parse_json_block(json_block)
    except ValueError:
        logger.debug("No JSON object came out of codegen: error was %s" % (errs))
        return None

def parse_json_block(json_block):
    codes = json.loads(json_block)
    code = codes[0]

    if not 'code' in code:
        return None

    raw_code = code["code"]

    m = code["metadata"]
    if "track_id" in m:
        trid = m["track_id"].encode("utf-8")
    else:
        trid = fp.new_track_id()

    length = m["duration"]
    version = m["version"]
    artist = m.get("artist", None)
    title = m.get("title", None)
    release = m.get("release", None)
    decoded = fp.decode_code_string(raw_code)
    
    ingest_data = {
        "track_id": trid,
        "fp": decoded,
        "length": length,
        "codever": "%.2f" % version
    }
    if artist: 
        ingest_data["artist"] = artist
    if release: 
        ingest_data["release"] = release
    if title: 
        ingest_data["track"] = title

    return trid, raw_code, ingest_data

def collect_mp3s(list, dir):
    """ recursively collects all mp3s in a directory into 
        the given list.
    """
    if os.path.isdir(dir):
        files = os.listdir(dir)
        for f in files:
            fp = os.path.join(dir, f)
            if os.path.isdir(fp):
                collect_mp3s(list, fp)
            elif fp.lower().endswith('.mp3'):
                list.append(fp)


def save_state():
    f = open("dedup.state.pkl", "w")
    pickle.dump(done, f)
    f.close()

def restore_state():
    if os.path.exists("dedup.state.pkl"):
        f = open("dedup.state.pkl")
        dict = pickle.load(f)
        f.close()
        done.update(dict)

def delete_files():
    if os.path.exists("dedup.state.pkl"):
        os.remove("dedup.state.pkl")
    if os.path.exists("dedup.dat"):
        os.remove("dedup.dat")

def get_file(id):
    iddone  = dict(zip(done.values(),done.keys()))
    return iddone[id]

    o
if __name__ == "__main__":
    if sys.argv[1] == '--reset':
        fp.erase_database(really_delete=True)
        delete_files()
        sys.exit(0)

    if len(sys.argv) < 3:
        print "Usage: dedup.py path-to-mp3s path-to-dups"
        sys.exit(1)

    restore_state()
    atexit.register(save_state)

    mp3s = []
    S = '<sep>'

    f=open(sys.argv[1], 'r')
    for line in f:
        mp3s.append(line.strip('\n'))
    f.close()

    print 'processing', len(mp3s), 'files'
    dups = open(sys.argv[2], "a")
    for count, mp3 in enumerate(mp3s):
        if mp3 in done:
            print '        skipping', mp3
            continue
        print "       ", len(done), count, mp3
        results = codegen(mp3)
        if not results:
            print "can't process", mp3, "skipping"
            continue
        trid, raw_code, ingest_data = results
        response = fp.best_match_for_query(raw_code)
        if response.match():
            print >>dups, 'duplicate: ', mp3, 'original: ', get_file(response.TRID)
            print 'duplicate', mp3  
            print '         ', get_file(response.TRID)
        else:
            fp.ingest([ingest_data], do_commit=True)
        done[mp3] = trid
    dups.close()
    
