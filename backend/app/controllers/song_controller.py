from fastapi import HTTPException
from bson import ObjectId

from app.database import (
    songs_collection,
    artists_collection,
    albums_collection,
)
from app.schemas.song_schema import SongCreateSchema, SongUpdateSchema


# ----------------------------------------
# HELPER: attach artist / album names
# ----------------------------------------
async def enrich_song(song: dict):
    # Artist name
    artist_name = "Unknown Artist"
    if song.get("artist_id") and ObjectId.is_valid(song["artist_id"]):
        artist = await artists_collection.find_one(
            {"_id": ObjectId(song["artist_id"])}
        )
        if artist:
            artist_name = artist.get("name", artist_name)

    # Album name (optional)
    album_name = None
    if song.get("album_id") and ObjectId.is_valid(song["album_id"]):
        album = await albums_collection.find_one(
            {"_id": ObjectId(song["album_id"])}
        )
        if album:
            album_name = album.get("title")

    # 🔥 IMPORTANT: AUDIO FIELD FIX
    # MongoDB me 'audio' ya 'audio_url' jo bhi ho, Flutter ko 'audio_url' milega
    audio_path = song.get("audio") or song.get("audio_url")

    song["id"] = str(song["_id"])
    song["artist_name"] = artist_name
    song["album_name"] = album_name
    song["audio_url"] = audio_path  # ✅ Flutter expects this

    # Optional: agar cover image hai
    if song.get("cover_image"):
        song["cover_image"] = song.get("cover_image")

    del song["_id"]

    return song


# ----------------------------------------
# CREATE SONG
# ----------------------------------------
async def create_song(data: SongCreateSchema):
    song_dict = data.dict()
    result = await songs_collection.insert_one(song_dict)

    song = await songs_collection.find_one({"_id": result.inserted_id})
    if not song:
        raise HTTPException(status_code=500, detail="Failed to create song")

    return await enrich_song(song)


# ----------------------------------------
# GET SONG BY ID
# ----------------------------------------
async def get_song_by_id(song_id: str):
    if not ObjectId.is_valid(song_id):
        raise HTTPException(status_code=400, detail="Invalid song ID")

    song = await songs_collection.find_one({"_id": ObjectId(song_id)})
    if not song:
        raise HTTPException(status_code=404, detail="Song not found")

    return await enrich_song(song)


# ----------------------------------------
# GET ALL SONGS
# ----------------------------------------
async def get_all_songs():
    songs = []
    async for song in songs_collection.find():
        songs.append(await enrich_song(song))
    return songs


# ----------------------------------------
# UPDATE SONG
# ----------------------------------------
async def update_song(song_id: str, data: SongUpdateSchema):
    if not ObjectId.is_valid(song_id):
        raise HTTPException(status_code=400, detail="Invalid song ID")

    update_data = {k: v for k, v in data.dict().items() if v is not None}

    result = await songs_collection.update_one(
        {"_id": ObjectId(song_id)},
        {"$set": update_data},
    )

    if result.matched_count == 0:
        raise HTTPException(status_code=404, detail="Song not found")

    song = await songs_collection.find_one({"_id": ObjectId(song_id)})
    return await enrich_song(song)


# ----------------------------------------
# DELETE SONG
# ----------------------------------------
async def delete_song(song_id: str):
    if not ObjectId.is_valid(song_id):
        raise HTTPException(status_code=400, detail="Invalid song ID")

    result = await songs_collection.delete_one({"_id": ObjectId(song_id)})

    if result.deleted_count == 0:
        raise HTTPException(status_code=404, detail="Song not found")

    return {"message": "Song deleted successfully"}
