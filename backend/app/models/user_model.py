from datetime import datetime
from bson import ObjectId
from app.database.connection import db
from backend.app.database.collection import USERS_COLLECTION


class UserModel:
    """
    MongoDB User Model using simple dictionary operations.
    This acts like a mini ORM for user-related DB operations.
    """

    @staticmethod
    async def create_user(data: dict):
        data["created_at"] = datetime.utcnow()
        data["updated_at"] = datetime.utcnow()
        result = await db[USERS_COLLECTION].insert_one(data)
        return str(result.inserted_id)

    @staticmethod
    async def find_by_email(email: str):
        return await db[USERS_COLLECTION].find_one({"email": email})

    @staticmethod
    async def find_by_id(user_id: str):
        return await db[USERS_COLLECTION].find_one({"_id": ObjectId(user_id)})

    @staticmethod
    async def update_user(user_id: str, update_data: dict):
        update_data["updated_at"] = datetime.utcnow()
        result = await db[USERS_COLLECTION].update_one(
            {"_id": ObjectId(user_id)},
            {"$set": update_data}
        )
        return result.modified_count > 0

    @staticmethod
    async def delete_user(user_id: str):
        result = await db[USERS_COLLECTION].delete_one({"_id": ObjectId(user_id)})
        return result.deleted_count > 0
