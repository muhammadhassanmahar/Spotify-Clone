import os
import urllib.parse
from bson import ObjectId
from app.database.collection import artists_collection, songs_collection, albums_collection

# -------------------------------------------------
# PATHS
# -------------------------------------------------
UPLOADS_DIR = "uploads"
ARTISTS_DIR = os.path.join(UPLOADS_DIR, "artists")
SONGS_DIR = os.path.join(UPLOADS_DIR, "songs")

SUPPORTED_AUDIO = (".mp3", ".wav", ".m4a")
SUPPORTED_IMAGES = (".jpg", ".jpeg", ".png", ".webp")


# -------------------------------------------------
# 🔁 AUTO SCAN ARTISTS
# -------------------------------------------------
async def auto_scan_artists():
    if artists_collection is None:
        print("❌ artists_collection not connected")
        return

    if not os.path.exists(ARTISTS_DIR):
        print("⚠ artists folder not found")
        return

    for item in os.listdir(ARTISTS_DIR):
        artist_path = os.path.join(ARTISTS_DIR, item)

        # If item is a file
        if os.path.isfile(artist_path) and item.lower().endswith(SUPPORTED_IMAGES):
            artist_name = os.path.splitext(item)[0]
            image_path = f"uploads/artists/{urllib.parse.quote(item)}"

        # If item is a folder
        elif os.path.isdir(artist_path):
            artist_name = item
            image_path = None
            for root, dirs, files in os.walk(artist_path):
                for file in files:
                    if file.lower().endswith(SUPPORTED_IMAGES):
                        rel_path = os.path.relpath(os.path.join(root, file), ".")
                        image_path = urllib.parse.quote(rel_path.replace("\\", "/"))
                        break
                if image_path:
                    break
            if not image_path:
                image_path = ""

        else:
            continue

        existing = await artists_collection.find_one({"name": artist_name})
        if existing:
            continue

        artist_doc = {
            "name": artist_name,
            "image": image_path,
            "bio": "",
        }

        await artists_collection.insert_one(artist_doc)
        print(f"✅ Artist added: {artist_name}")


# -------------------------------------------------
# 🔁 AUTO SCAN ALBUMS AND SONGS
# uploads/songs/Album Name/song.mp3
# -------------------------------------------------
async def auto_scan_songs_and_albums():
    if songs_collection is None or albums_collection is None:
        print("❌ songs_collection or albums_collection not connected")
        return

    if not os.path.exists(SONGS_DIR):
        print("⚠ songs folder not found")
        return

    for album_item in os.listdir(SONGS_DIR):
        album_path = os.path.join(SONGS_DIR, album_item)
        if os.path.isdir(album_path):
            album_title = album_item

            # Check if album already exists
            existing_album = await albums_collection.find_one({"title": album_title})
            if existing_album:
                album_id = existing_album["_id"]
            else:
                album_doc = {
                    "title": album_title,
                    "cover_image": "",  # optional, can scan folder for first image
                    "artist_id": None,  # map manually later
                    "year": None,
                }
                result = await albums_collection.insert_one(album_doc)
                album_id = result.inserted_id
                print(f"📀 Album added: {album_title}")

            # Scan songs inside album
            for song_file in os.listdir(album_path):
                if not song_file.lower().endswith(SUPPORTED_AUDIO):
                    continue

                song_title = os.path.splitext(song_file)[0]

                existing_song = await songs_collection.find_one({"title": song_title, "album_id": album_id})
                if existing_song:
                    continue

                safe_file_name = urllib.parse.quote(song_file)
                song_doc = {
                    "title": song_title,
                    "artist_id": None,  # map later
                    "album_id": album_id,
                    "duration": 0,
                    "audio_url": f"uploads/songs/{urllib.parse.quote(album_title)}/{safe_file_name}",
                    "cover_image": "",
                    "genre_id": None,
                }

                await songs_collection.insert_one(song_doc)
                print(f"🎵 Song added: {song_title} (Album: {album_title})")

        # Handle loose songs in SONGS_DIR (no album folder)
        elif os.path.isfile(album_path) and album_item.lower().endswith(SUPPORTED_AUDIO):
            song_title = os.path.splitext(album_item)[0]
            existing = await songs_collection.find_one({"title": song_title, "album_id": None})
            if existing:
                continue

            safe_file_name = urllib.parse.quote(album_item)
            song_doc = {
                "title": song_title,
                "artist_id": None,
                "album_id": None,
                "duration": 0,
                "audio_url": f"uploads/songs/{safe_file_name}",
                "cover_image": "",
                "genre_id": None,
            }
            await songs_collection.insert_one(song_doc)
            print(f"🎵 Song added: {song_title} (No Album)")


# -------------------------------------------------
# 🔁 MASTER AUTO SCAN
# -------------------------------------------------
async def auto_scan_uploads():
    print("🔍 Scanning artists...")
    await auto_scan_artists()
    print("🔍 Scanning albums & songs...")
    await auto_scan_songs_and_albums()
    print("✅ Auto scan completed")
