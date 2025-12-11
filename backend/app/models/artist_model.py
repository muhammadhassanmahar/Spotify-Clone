from datetime import datetime
from bson import ObjectId
from app.database.connection import db
from backend.app.database.collection import ARTISTS_COLLECTION


class ArtistModel:
    """
    Artist model for storing artist information:
    - name
    - bio
    - image
    - social links
    """

    @staticmethod
    async def create_artist(data: dict):
        data["created_at"] = datetime.utcnow()
        data["updated_at"] = datetime.utcnow()
        result = await db[ARTISTS_COLLECTION].insert_one(data)
        return str(result.inserted_id)

    @staticmethod
    async def get_all_artists():
        cursor = db[ARTISTS_COLLECTION].find({})
        return await cursor.to_list(length=1000)

    @staticmethod
    async def find_by_id(artist_id: str):
        return await db[ARTISTS_COLLECTION].find_one({"_id": ObjectId(artist_id)})

    @staticmethod
    async def update_artist(artist_id: str, update_data: dict):
        update_data["updated_at"] = datetime.utcnow()
        result = await db[ARTISTS_COLLECTION].update_one(
            {"_id": ObjectId(artist_id)},
            {"$set": update_data}
        )
        return result.modified_count > 0

    @staticmethod
    async def delete_artist(artist_id: str):
        result = await db[ARTISTS_COLLECTION].delete_one({"_id": ObjectId(artist_id)})
        return result.deleted_count > 0
