from fastapi import HTTPException
from bson import ObjectId
from datetime import datetime

from app.database import history_collection, songs_collection


# ----------------------------------------
# ADD SONG TO HISTORY
# ----------------------------------------
async def add_to_history(user_id: str, song_id: str):
    song_exists = await songs_collection.find_one({"_id": ObjectId(song_id)})
    if not song_exists:
        raise HTTPException(status_code=404, detail="Song not found")

    history_doc = {
        "user_id": user_id,
        "song_id": song_id,
        "timestamp": datetime.utcnow()
    }

    await history_collection.insert_one(history_doc)
    return {"message": "Song added to history"}


# ----------------------------------------
# GET USER HISTORY
# ----------------------------------------
async def get_user_history(user_id: str):
    history = []

    async for entry in history_collection.find({"user_id": user_id}).sort("timestamp", -1):
        entry["id"] = str(entry["_id"])
        del entry["_id"]
        history.append(entry)

    return history


# ----------------------------------------
# REMOVE ITEM FROM HISTORY
# ----------------------------------------
async def remove_from_history(history_id: str):
    result = await history_collection.delete_one({"_id": ObjectId(history_id)})

    if result.deleted_count == 0:
        raise HTTPException(status_code=404, detail="History item not found")

    return {"message": "History item removed"}
