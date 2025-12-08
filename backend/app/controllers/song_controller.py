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
    new_song["id"] = str(new_song["_id"])
    del new_song["_id"]

    return new_song


# ----------------------------------------
# GET SONG BY ID
# ----------------------------------------
async def get_song_by_id(song_id: str):
    song = await songs_collection.find_one({"_id": ObjectId(song_id)})
    if
