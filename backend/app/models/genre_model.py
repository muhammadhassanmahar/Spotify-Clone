from datetime import datetime
from bson import ObjectId
from app.database.connection import db
from backend.app.database.collection import GENRES_COLLECTION


class GenreModel:
    """
    Genre model:
    - name
    - description
    """

    @staticmethod
    async def create_genre(data: dict):
        data["created_at"] = datetime.utcnow()
        data["updated_at"] = datetime.utcnow()
        result = await db[GENRES_COLLECTION].insert_one(data)
        return str(result.inserted_id)

    @staticmethod
    async def find_by_id(genre_id: str):
        return await db[GENRES_COLLECTION].find_one({"_id": ObjectId(genre_id)})

    @staticmethod
    async def get_all_genres():
        cursor = db[GENRES_COLLECTION].find({})
        return await cursor.to_list(length=500)

    @staticmethod
    async def update_genre(genre_id: str, update_data: dict):
        update_data["updated_at"] = datetime.utcnow()
        result = await db[GENRES_COLLECTION].update_one(
            {"_id": ObjectId(genre_id)},
            {"$set": update_data}
        )
        return result.modified_count > 0

    @staticmethod
    async def delete_genre(genre_id: str):
        result = await db[GENRES_COLLECTION].delete_one({"_id": ObjectId(genre_id)})
        return result.deleted_count > 0
