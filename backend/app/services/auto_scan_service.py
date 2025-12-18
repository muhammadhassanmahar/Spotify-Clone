import os
import urllib.parse
from bson import ObjectId
from app.database.collection import artists_collection, songs_collection

# -------------------------------------------------
# PATHS
# -------------------------------------------------
UPLOADS_DIR = "uploads"
ARTISTS_DIR = os.path.join(UPLOADS_DIR, "artists")
SONGS_DIR = os.path.join(UPLOADS_DIR, "songs")

SUPPORTED_AUDIO = (".mp3", ".wav", ".m4a")
SUPPORTED_IMAGES = (".jpg", ".jpeg", ".png", ".webp")


# -------------------------------------------------
# 🔁 AUTO SCAN ARTISTS (recursive & simple)
# uploads/artists/Artist Name/.../image.jpg
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

        # If item is a file (simple structure), treat as artist image
        if os.path.isfile(artist_path) and item.lower().endswith(SUPPORTED_IMAGES):
            artist_name = os.path.splitext(item)[0]
            image_path = f"uploads/artists/{urllib.parse.quote(item)}"

        # If item is a folder (nested structure)
        elif os.path.isdir(artist_path):
            artist_name = item

            # Recursive search for first image in folder
            image_path = None
            for root, dirs, files in os.walk(artist_path):
                for file in files:
                    if file.lower().endswith(SUPPORTED_IMAGES):
                        rel_path = os.path.relpath(os.path.join(root, file), ".")
                        image_path = rel_path.replace("\\", "/")
                        image_path = urllib.parse.quote(image_path)
                        break
                if image_path:
                    break

            if not image_path:
                image_path = ""  # remove default image for now

        else:
            continue  # skip other files

        # Skip if artist already exists
        existing = await artists_collection.find_one({"name": artist_name})
        if existing:
            continue

        # Insert artist document
        artist_doc = {
            "name": artist_name,
            "image": image_path,
            "bio": "",
        }

        await artists_collection.insert_one(artist_doc)
        print(f"✅ Artist added: {artist_name}")


# -------------------------------------------------
# 🔁 AUTO SCAN SONGS (direct in songs folder)
# uploads/songs/songname.mp3
# -------------------------------------------------
async def auto_scan_songs():
    if songs_collection is None:
        print("❌ songs_collection not connected")
        return

    if not os.path.exists(SONGS_DIR):
        print("⚠ songs folder not found")
        return

    for file in os.listdir(SONGS_DIR):
        if not file.lower().endswith(SUPPORTED_AUDIO):
            continue

        title = os.path.splitext(file)[0]

        # Skip if song already exists
        existing = await songs_collection.find_one({"title": title})
        if existing:
            continue

        # Encode file name for URL safety
        safe_file_name = urllib.parse.quote(file)

        song_doc = {
            "title": title,
            "artist_id": None,        # map later
            "album_id": None,         # map later
            "duration": 0,            # optional
            "audio_url": f"uploads/songs/{safe_file_name}",
            "cover_image": "",         # remove default image
            "genre_id": None,
        }

        await songs_collection.insert_one(song_doc)
        print(f"🎵 Song added: {title}")


# -------------------------------------------------
# 🔁 MASTER AUTO SCAN
# -------------------------------------------------
async def auto_scan_uploads():
    print("🔍 Scanning artists...")
    await auto_scan_artists()
    print("🔍 Scanning songs...")
    await auto_scan_songs()
    print("✅ Auto scan completed")
