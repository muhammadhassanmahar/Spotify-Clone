from datetime import datetime
from bson import ObjectId
from app.database.connection import db
from app.database.collections import PLAYLISTS_COLLECTION


class PlaylistModel:
    """
    Playlist model:
    - name
    - description
    - user_id (owner)
    - songs (list of song ids)
    - cover image
    - public/private
    """

    @staticmethod
    async def create_playlist(data: dict):
        data["songs"] = data.get("songs", [])
        data["created_at"] = datetime.utcnow()
        data["updated_at"] = datetime.utcnow()
        result = await db[PLAYLISTS_COLLECTION].insert_one(data)
        return str(result.inserted_id)

    @staticmethod
    async def find_by_id(playlist_id: str):
        return await db[PLAYLISTS_COLLECTION].find_one({"_id": ObjectId(playlist_id)})

    @staticmethod
    async def get_user_playlists(user_id: str):
        cursor = db[PLAYLISTS_COLLECTION].find({"user_id": user_id})
        return await cursor.to_list(length=500)

    @staticmethod
    async def add_song_to_playlist(playlist_id: str, song_id: str):
        result = await db[PLAYLISTS_COLLECTION].update_one(
            {"_id": ObjectId(playlist_id)},
            {"$addToSet": {"songs": song_id}}
        )
        return result.modified_count > 0

    @staticmethod
    async def remove_song_from_playlist(playlist_id: str, song_id: str):
        result = await db[PLAYLISTS_COLLECTION].update_one(
            {"_id": ObjectId(playlist_id)},
            {"$pull": {"songs": song_id}}
        )
        return result.modified_count > 0

    @staticmethod
    async def update_playlist(playlist_id: str, update_data: dict):
        update_data["updated_at"] = datetime.utcnow()
        result = await db[PLAYLISTS_COLLECTION].update_one(
            {"_id": ObjectId(playlist_id)},
            {"$set": update_data}
        )
        return result.modified_count > 0

    @staticmethod
    async def delete_playlist(playlist_id: str):
        result = await db[PLAYLISTS_COLLECTION].delete_one({"_id": ObjectId(playlist_id)})
        return result.deleted_count > 0
