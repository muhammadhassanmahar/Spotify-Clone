import os
import urllib.parse
from app.database.collection import (
    artists_collection,
    songs_collection,
    albums_collection,
)

UPLOADS_DIR = "uploads"
ARTISTS_DIR = os.path.join(UPLOADS_DIR, "artists")
SONGS_DIR = os.path.join(UPLOADS_DIR, "songs")

SUPPORTED_AUDIO = (".mp3", ".wav", ".m4a")
SUPPORTED_IMAGES = (".jpg", ".jpeg", ".png", ".webp")


# -------------------------------------------------
# 🔁 AUTO SCAN ARTISTS
# -------------------------------------------------
async def auto_scan_artists():
    if not os.path.exists(ARTISTS_DIR):
        return

    for file in os.listdir(ARTISTS_DIR):
        if not file.lower().endswith(SUPPORTED_IMAGES):
            continue

        name = os.path.splitext(file)[0]
        image_path = f"uploads/artists/{urllib.parse.quote(file)}"

        if await artists_collection.find_one({"name": name}):
            continue

        await artists_collection.insert_one({
            "name": name,
            "image": image_path,
            "bio": ""
        })

        print(f"✅ Artist added: {name}")


# -------------------------------------------------
# 🔁 AUTO SCAN ALBUMS + SONGS
# -------------------------------------------------
async def auto_scan_songs_and_albums():
    if not os.path.exists(SONGS_DIR):
        return

    for item in os.listdir(SONGS_DIR):
        item_path = os.path.join(SONGS_DIR, item)

        # ==========================
        # 📀 ALBUM FOLDER
        # ==========================
        if os.path.isdir(item_path):
            album_title = item.strip()

            album = await albums_collection.find_one({"title": album_title})
            if not album:
                result = await albums_collection.insert_one({
                    "title": album_title,
                    "cover_image": "",
                    "artist_id": None,
                    "year": None
                })
                album_id = result.inserted_id
                print(f"📀 Album added: {album_title}")
            else:
                album_id = album["_id"]

            for song_file in os.listdir(item_path):
                if not song_file.lower().endswith(SUPPORTED_AUDIO):
                    continue

                title = os.path.splitext(song_file)[0]

                audio_url = (
                    f"uploads/songs/"
                    f"{urllib.parse.quote(album_title)}/"
                    f"{urllib.parse.quote(song_file)}"
                )

                existing_song = await songs_collection.find_one({
                    "title": title,
                    "album_id": album_id
                })

                # ✅ song already exists with album → skip
                if existing_song:
                    continue

                # 🔁 song exists but album_id is null → update it
                orphan_song = await songs_collection.find_one({
                    "title": title,
                    "album_id": None
                })

                if orphan_song:
                    await songs_collection.update_one(
                        {"_id": orphan_song["_id"]},
                        {"$set": {
                            "album_id": album_id,
                            "audio_url": audio_url
                        }}
                    )
                    print(f"🔁 Song updated: {title} → {album_title}")
                else:
                    await songs_collection.insert_one({
                        "title": title,
                        "artist_id": None,
                        "album_id": album_id,
                        "duration": 0,
                        "audio_url": audio_url,
                        "cover_image": "",
                        "genre_id": None
                    })
                    print(f"🎵 Song added: {title} → {album_title}")

        # ==========================
        # 🎵 LOOSE SONG (NO ALBUM)
        # ==========================
        elif item.lower().endswith(SUPPORTED_AUDIO):
            title = os.path.splitext(item)[0]

            if await songs_collection.find_one({
                "title": title,
                "album_id": None
            }):
                continue

            await songs_collection.insert_one({
                "title": title,
                "artist_id": None,
                "album_id": None,
                "duration": 0,
                "audio_url": f"uploads/songs/{urllib.parse.quote(item)}",
                "cover_image": "",
                "genre_id": None
            })

            print(f"🎵 Song added (no album): {title}")


# -------------------------------------------------
# 🔁 MASTER
# -------------------------------------------------
async def auto_scan_uploads():
    print("🔍 Scanning artists...")
    await auto_scan_artists()

    print("🔍 Scanning albums & songs...")
    await auto_scan_songs_and_albums()

    print("✅ Auto scan completed")
