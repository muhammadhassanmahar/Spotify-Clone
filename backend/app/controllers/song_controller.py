from fastapi import HTTPException
from bson import ObjectId

from app.database import songs_collection
from app.schemas.song_schema import SongCreateSchema, SongUpdateSchema


# ----------------------------------------
# CREATE SONG
# ----------------------------------------
async def create_song(data: SongCreateSchema):
    song_dict = data.dict()
    result = await songs_collection.insert_one(song_dict)

    new_song = await songs_collection.find_one({"_id": result.inserted_id})
    if not new_song:
        raise HTTPException(status_code=500, detail="Failed to create song")

    new_song["id"] = str(new_song["_id"])
    del new_song["_id"]

    return new_song


# ----------------------------------------
# GET SONG BY ID
# ----------------------------------------
async def get_song_by_id(song_id: str):
    if not ObjectId.is_valid(song_id):
        raise HTTPException(status_code=400, detail="Invalid song ID")

    song = await songs_collection.find_one({"_id": ObjectId(song_id)})
    if not song:
        raise HTTPException(status_code=404, detail="Song not found")

    song["id"] = str(song["_id"])
    del song["_id"]

    return song


# ----------------------------------------
# GET ALL SONGS
# ----------------------------------------
async def get_all_songs():
    songs = []
    async for song in songs_collection.find():
        song["id"] = str(song["_id"])
        del song["_id"]
        songs.append(song)
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
        {"$set": update_data}
    )

    if result.matched_count == 0:
        raise HTTPException(status_code=404, detail="Song not found")

    updated_song = await songs_collection.find_one({"_id": ObjectId(song_id)})
    updated_song["id"] = str(updated_song["_id"])
    del updated_song["_id"]

    return updated_song


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
