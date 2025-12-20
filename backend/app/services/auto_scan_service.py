import os
import urllib.parse
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
# 🧠 HELPERS
# -------------------------------------------------
def detect_artist_from_title(title: str) -> str:
    if "-" in title:
        return title.split("-")[0].strip()
    if "_" in title:
        return title.split("_")[0].strip()
    return "Unknown Artist"


async def get_or_create_artist(name: str):
    artist = await artists_collection.find_one({"name": name})
    if artist:
        return artist["_id"]

    result = await artists_collection.insert_one({
        "name": name,
        "image": "",
        "bio": "",
    })
    print(f"👤 Artist added: {name}")
    return result.inserted_id


async def get_or_create_album(title: str, artist_id):
    album = await albums_collection.find_one({
        "title": title,
        "artist_id": artist_id
    })
    if album:
        return album["_id"]

    result = await albums_collection.insert_one({
        "title": title,
        "cover_image": "",
        "artist_id": artist_id,
        "year": None,
    })
    print(f"📀 Album added: {title}")
    return result.inserted_id


# -------------------------------------------------
# 🔁 AUTO SCAN ARTISTS (IMAGES)
# -------------------------------------------------
async def auto_scan_artists():
    if artists_collection is None:
        print("❌ artists_collection not connected")
        return

    if not os.path.exists(ARTISTS_DIR):
        print("⚠ artists folder not found")
        return

    for item in os.listdir(ARTISTS_DIR):
        path = os.path.join(ARTISTS_DIR, item)

        if not item.lower().endswith(SUPPORTED_IMAGES):
            continue

        artist_name = os.path.splitext(item)[0]
        image_path = f"uploads/artists/{urllib.parse.quote(item)}"

        existing = await artists_collection.find_one({"name": artist_name})
        if existing:
            continue

        await artists_collection.insert_one({
            "name": artist_name,
            "image": image_path,
            "bio": "",
        })

        print(f"👤 Artist image added: {artist_name}")


# -------------------------------------------------
# 🔁 AUTO SCAN ALBUMS & SONGS
# uploads/songs/Album Name/song.mp3
# -------------------------------------------------
async def auto_scan_songs_and_albums():
    if songs_collection is None or albums_collection is None:
        print("❌ DB collections not connected")
        return

    if not os.path.exists(SONGS_DIR):
        print("⚠ songs folder not found")
        return

    for item in os.listdir(SONGS_DIR):
        item_path = os.path.join(SONGS_DIR, item)

        # ===============================
        # 📀 ALBUM FOLDER
        # ===============================
        if os.path.isdir(item_path):
            album_title = item

            for song_file in os.listdir(item_path):
                if not song_file.lower().endswith(SUPPORTED_AUDIO):
                    continue

                song_title = os.path.splitext(song_file)[0]
                artist_name = detect_artist_from_title(song_title)

                artist_id = await get_or_create_artist(artist_name)
                album_id = await get_or_create_album(album_title, artist_id)

                existing_song = await songs_collection.find_one({
                    "title": song_title,
                    "album_id": album_id
                })
                if existing_song:
                    continue

                safe_name = urllib.parse.quote(song_file)

                await songs_collection.insert_one({
                    "title": song_title,
                    "artist_id": artist_id,
                    "album_id": album_id,
                    "duration": 0,
                    "audio_url": f"uploads/songs/{urllib.parse.quote(album_title)}/{safe_name}",
                    "cover_image": "",
                    "genre_id": None,
                })

                print(f"🎵 Song added: {song_title} → {album_title}")

        # ===============================
        # 🎵 LOOSE SONG (NO ALBUM)
        # ===============================
        elif os.path.isfile(item_path) and item.lower().endswith(SUPPORTED_AUDIO):
            song_title = os.path.splitext(item)[0]
            artist_name = detect_artist_from_title(song_title)
            artist_id = await get_or_create_artist(artist_name)

            existing = await songs_collection.find_one({
                "title": song_title,
                "album_id": None
            })
            if existing:
                continue

            safe_name = urllib.parse.quote(item)

            await songs_collection.insert_one({
                "title": song_title,
                "artist_id": artist_id,
                "album_id": None,
                "duration": 0,
                "audio_url": f"uploads/songs/{safe_name}",
                "cover_image": "",
                "genre_id": None,
            })

            print(f"🎵 Loose song added: {song_title}")


# -------------------------------------------------
# 🔁 MASTER AUTO SCAN
# -------------------------------------------------
async def auto_scan_uploads():
    print("🔍 Scanning artists...")
    await auto_scan_artists()

    print("🔍 Scanning albums & songs...")
    await auto_scan_songs_and_albums()

    print("✅ Auto scan completed")
