from datetime import datetime
from bson import ObjectId
from app.database import db


# --------------------------------------------------
# ADD SONG TO RECENT LIST (when user plays a song)
# --------------------------------------------------
async def add_recent_song(user_id: int, song_id: int):

    new_data = {
        "user_id": user_id,
        "song_id": song_id,
        "played_at": datetime.utcnow()
    }

    result = await db.recent_songs.insert_one(new_data)

    return {
        "id": str(result.inserted_id),
        "user_id": user_id,
        "song_id": song_id,
        "played_at": new_data["played_at"]
    }


# --------------------------------------------------
# GET USER'S RECENT SONG LIST
# --------------------------------------------------
async def get_recent_songs(user_id: int):
    cursor = db.recent_songs.find(
        {"user_id": user_id}
    ).sort("played_at", -1)

    recent_list = []

    async for doc in cursor:
        recent_list.append({
            "id": str(doc["_id"]),
            "user_id": doc["user_id"],
            "song_id": doc["song_id"],
            "played_at": doc["played_at"]
        })

    return recent_list
