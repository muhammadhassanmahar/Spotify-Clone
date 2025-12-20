from fastapi import HTTPException
from bson import ObjectId

from app.database import (
    songs_collection,
    artists_collection,
    albums_collection,
)
from app.schemas.song_schema import SongCreateSchema, SongUpdateSchema


# -------------------------------------------------
# 🔧 HELPER: ObjectId safe convert
# -------------------------------------------------
def to_object_id(value):
    if value and ObjectId.is_valid(str(value)):
        return ObjectId(str(value))
    return None


# -------------------------------------------------
# 🔧 HELPER: ENRICH SONG
# -------------------------------------------------
async def enrich_song(song: dict):
    # -------------------------
    # Artist
    # -------------------------
    artist_name = "Unknown Artist"
    artist_id = to_object_id(song.get("artist_id"))

    if artist_id:
        artist = await artists_collection.find_one({"_id": artist_id})
        if artist:
            artist_name = artist.get("name", artist_name)

    # -------------------------
    # Album
    # -------------------------
    album_name = None
    album_id = to_object_id(song.get("album_id"))

    if album_id:
        album = await albums_collection.find_one({"_id": album_id})
        if album:
            album_name = album.get("title")

    # -------------------------
    # Audio path (🔥 CRITICAL FIX)
    # -------------------------
    audio_url = (
        song.get("audio_url")
        or song.get("audio")
        or ""
    )

    # -------------------------
    # Cover image
    # -------------------------
    cover_image = song.get("cover_image") or ""

    # -------------------------
    # Final response
    # -------------------------
    return {
        "id": str(song["_id"]),
        "title": song.get("title", "Unknown Song"),
        "artist_id": str(artist_id) if artist_id else None,
        "album_id": str(album_id) if album_id else None,
        "artist_name": artist_name,
        "album_name": album_name,
        "duration": song.get("duration", 0),
        "audio_url": audio_url,          # ✅ Flutter expects this
        "cover_image": cover_image,       # ✅ empty allowed
        "genre_id": song.get("genre_id"),
    }


# -------------------------------------------------
# ➕ CREATE SONG
# -------------------------------------------------
async def create_song(data: SongCreateSchema):
    song_dict = data.dict()
    result = await songs_collection.insert_one(song_dict)

    song = await songs_collection.find_one({"_id": result.inserted_id})
    if not song:
        raise HTTPException(status_code=500, detail="Failed to create song")

    return await enrich_song(song)


# -------------------------------------------------
# 🎵 GET SONG BY ID
# -------------------------------------------------
async def get_song_by_id(song_id: str):
    if not ObjectId.is_valid(song_id):
        raise HTTPException(status_code=400, detail="Invalid song ID")

    song = await songs_collection.find_one({"_id": ObjectId(song_id)})
    if not song:
        raise HTTPException(status_code=404, detail="Song not found")

    return await enrich_song(song)


# -------------------------------------------------
# 🎵 GET ALL SONGS
# -------------------------------------------------
async def get_all_songs():
    songs = []
    async for song in songs_collection.find():
        songs.append(await enrich_song(song))
    return songs


# -------------------------------------------------
# ✏️ UPDATE SONG
# -------------------------------------------------
async def update_song(song_id: str, data: SongUpdateSchema):
    if not ObjectId.is_valid(song_id):
        raise HTTPException(status_code=400, detail="Invalid song ID")

    update_data = {
        k: v for k, v in data.dict().items()
        if v is not None
    }

    result = await songs_collection.update_one(
        {"_id": ObjectId(song_id)},
        {"$set": update_data}
    )

    if result.matched_count == 0:
        raise HTTPException(status_code=404, detail="Song not found")

    song = await songs_collection.find_one({"_id": ObjectId(song_id)})
    return await enrich_song(song)


# -------------------------------------------------
# 🗑️ DELETE SONG
# -------------------------------------------------
async def delete_song(song_id: str):
    if not ObjectId.is_valid(song_id):
        raise HTTPException(status_code=400, detail="Invalid song ID")

    result = await songs_collection.delete_one(
        {"_id": ObjectId(song_id)}
    )

    if result.deleted_count == 0:
        raise HTTPException(status_code=404, detail="Song not found")

    return {"message": "Song deleted successfully"}
