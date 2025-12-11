from fastapi import HTTPException
from bson import ObjectId
from datetime import datetime

from app.database import likes_collection, songs_collection


# ----------------------------------------
# LIKE A SONG
# ----------------------------------------
async def like_song(user_id: str, song_id: str):
    song_exists = await songs_collection.find_one({"_id": ObjectId(song_id)})
    if not song_exists:
        raise HTTPException(status_code=404, detail="Song not found")

    already_liked = await likes_collection.find_one({
        "user_id": user_id,
        "song_id": song_id
    })

    if already_liked:
        raise HTTPException(status_code=400, detail="Song already liked")

    like_doc = {
        "user_id": user_id,
        "song_id": song_id,
        "timestamp": datetime.utcnow()
    }

    await likes_collection.insert_one(like_doc)
    return {"message": "Song liked successfully"}


# ----------------------------------------
# GET USER'S LIKED SONGS
# ----------------------------------------
async def get_liked_songs(user_id: str):
    liked = []

    async for entry in likes_collection.find({"user_id": user_id}).sort("timestamp", -1):
        entry["id"] = str(entry["_id"])
        del entry["_id"]
        liked.append(entry)

    return liked


# ----------------------------------------
# REMOVE LIKE (UNLIKE SONG)
# ----------------------------------------
async def unlike_song(user_id: str, song_id: str):
    result = await likes_collection.delete_one({
        "user_id": user_id,
        "song_id": song_id
    })

    if result.deleted_count == 0:
        raise HTTPException(status_code=404, detail="Like not found")

    return {"message": "Song unliked"}
