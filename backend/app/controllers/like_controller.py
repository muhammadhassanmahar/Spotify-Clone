from fastapi import HTTPException
from bson import ObjectId
from datetime import datetime

from app.database import likes_collection, songs_collection


# ----------------------------------------
# LIKE A SONG
# ----------------------------------------
async def like_song(user_id: str, song_id: str):
    # Check if song exists
    song_exists = await songs_collection.find_one({"_id": ObjectId(song_id)})
    if not song_exists:
        raise HTTPException(status_code=404, detail="Song not found")

    # Check if already liked
    already_liked = await likes_collection.find_one({
        "user_id": user_id,
        "song_id": song_id
    })

    if already_liked:
        raise HTTPException(status_code=400, detail="Song already liked")

    # Create like entry
    like_doc = {
        "user_id": user_id,
        "song_id": song_id,
        "timestamp": datetime.utcnow()
    }

    await likes_collection.insert_one(like_doc)

    return {"message": "Song liked successfully"}


# ----------------------------------------
# GET USER'S LIKED SONGS (RETURN FULL SONG DETAILS)
# ----------------------------------------
async def get_liked_songs(user_id: str):
    liked_songs = []

    # Fetch user's liked entries
    async for entry in likes_collection.find({"user_id": user_id}).sort("timestamp", -1):
        song = await songs_collection.find_one({"_id": ObjectId(entry["song_id"])})

        if song:
            # Convert _id for JSON response
            song["id"] = str(song["_id"])
            del song["_id"]

            liked_songs.append(song)

    return liked_songs


# ----------------------------------------
# REMOVE LIKE (UNLIKE)
# ----------------------------------------
async def unlike_song(user_id: str, song_id: str):
    result = await likes_collection.delete_one({
        "user_id": user_id,
        "song_id": song_id
    })

    if result.deleted_count == 0:
        raise HTTPException(status_code=404, detail="Like not found")

    return {"message": "Song unliked successfully"}
