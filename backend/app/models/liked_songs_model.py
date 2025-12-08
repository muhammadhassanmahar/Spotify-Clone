from datetime import datetime
from bson import ObjectId
from app.database.connection import db
from app.database.collections import LIKED_SONGS_COLLECTION


class LikedSongsModel:
    """
    Liked Songs model:
    - user_id
    - songs: [song_ids]
    """

    @staticmethod
    async def create_user_liked_list(user_id: str):
        existing = await db[LIKED_SONGS_COLLECTION].find_one({"user_id": user_id})
        if existing:
            return existing["_id"]

        data = {
            "user_id": user_id,
            "songs": [],
            "created_at": datetime.utcnow(),
            "updated_at": datetime.utcnow()
        }

        result = await db[LIKED_SONGS_COLLECTION].insert_one(data)
        return str(result.inserted_id)

    @staticmethod
    async def get_user_liked_songs(user_id: str):
        return await db[LIKED_SONGS_COLLECTION].find_one({"user_id": user_id})

    @staticmethod
    async def like_song(user_id: str, song_id: str):
        await LikedSongsModel.create_user_liked_list(user_id)

        result = await db[LIKED_SONGS_COLLECTION].update_one(
            {"user_id": user_id},
            {
                "$addToSet": {"songs": song_id},
                "$set": {"updated_at": datetime.utcnow()}
            }
        )
        return result.modified_count > 0

    @staticmethod
    async def unlike_song(user_id: str, song_id: str):
        result = await db[LIKED_SONGS_COLLECTION].update_one(
            {"user_id": user_id},
            {
                "$pull": {"songs": song_id},
                "$set": {"updated_at": datetime.utcnow()}
            }
        )
        return result.modified_count > 0

    @staticmethod
    async def delete_user_liked_list(user_id: str):
        result = await db[LIKED_SONGS_COLLECTION].delete_one({"user_id": user_id})
        return result.deleted_count > 0
