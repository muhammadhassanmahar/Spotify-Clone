from datetime import datetime
from bson import ObjectId
from app.database.connection import db
from app.database.collections import ALBUMS_COLLECTION


class AlbumModel:
    """
    Album model for storing:
    - album name
    - artist id
    - release year
    - cover image
    """

    @staticmethod
    async def create_album(data: dict):
        data["created_at"] = datetime.utcnow()
        data["updated_at"] = datetime.utcnow()
        result = await db[ALBUMS_COLLECTION].insert_one(data)
        return str(result.inserted_id)

    @staticmethod
    async def find_by_id(album_id: str):
        return await db[ALBUMS_COLLECTION].find_one({"_id": ObjectId(album_id)})

    @staticmethod
    async def get_albums_by_artist(artist_id: str):
        cursor = db[ALBUMS_COLLECTION].find({"artist_id": artist_id})
        return await cursor.to_list(length=1000)

    @staticmethod
    async def update_album(album_id: str, update_data: dict):
        update_data["updated_at"] = datetime.utcnow()
        result = await db[ALBUMS_COLLECTION].update_one(
            {"_id": ObjectId(album_id)},
            {"$set": update_data}
        )
        return result.modified_count > 0

    @staticmethod
    async def delete_album(album_id: str):
        result = await db[ALBUMS_COLLECTION].delete_one({"_id": ObjectId(album_id)})
        return result.deleted_count > 0
