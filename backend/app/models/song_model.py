from datetime import datetime
from bson import ObjectId
from app.database.connection import db
from app.database.collections import SONGS_COLLECTION


class SongModel:
    """
    Song model:
    - title
    - artist id
    - album id
    - duration
    - audio file path
    - cover image
    - plays count
    """

    @staticmethod
    async def create_song(data: dict):
        data["created_at"] = datetime.utcnow()
        data["updated_at"] = datetime.utcnow()
        data["plays"] = 0  # default plays
        result = await db[SONGS_COLLECTION].insert_one(data)
        return str(result.inserted_id)

    @staticmethod
    async def find_by_id(song_id: str):
        return await db[SONGS_COLLECTION].find_one({"_id": ObjectId(song_id)})

    @staticmethod
    async def get_songs_by_artist(artist_id: str):
        cursor = db[SONGS_COLLECTION].find({"artist_id": artist_id})
        return await cursor.to_list(length=1000)

    @staticmethod
    async def get_songs_by_album(album_id: str):
        cursor = db[SONGS_COLLECTION].find({"album_id": album_id})
        return await cursor.to_list(length=1000)

    @staticmethod
    async def search_songs(keyword: str):
        cursor = db[SONGS_COLLECTION].find({"title": {"$regex": keyword, "$options": "i"}})
        return await cursor.to_list(length=1000)

    @staticmethod
    async def increment_plays(song_id: str):
        await db[SONGS_COLLECTION].update_one(
            {"_id": ObjectId(song_id)},
            {"$inc": {"plays": 1}}
        )

    @staticmethod
    async def update_song(song_id: str, update_data: dict):
        update_data["updated_at"] = datetime.utcnow()
        result = await db[SONGS_COLLECTION].update_one(
            {"_id": ObjectId(song_id)},
            {"$set": update_data}
        )
        return result.modified_count > 0

    @staticmethod
    async def delete_song(song_id: str):
        result = await db[SONGS_COLLECTION].delete_one({"_id": ObjectId(song_id)})
        return result.deleted_count > 0
