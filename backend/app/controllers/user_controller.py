from fastapi import HTTPException
from bson import ObjectId

from app.database import users_collection
from app.schemas.user_schema import UpdateUserSchema


# ----------------------------------------
# GET USER BY ID
# ----------------------------------------
async def get_user_by_id(user_id: str):
    user = await users_collection.find_one({"_id": ObjectId(user_id)})
    if not user:
        raise HTTPException(status_code=404, detail="User not found")

    user["id"] = str(user["_id"])
    del user["_id"]
    return user


# ----------------------------------------
# UPDATE USER PROFILE
# ----------------------------------------
async def update_user(user_id: str, data: UpdateUserSchema):
    update_data = {k: v for k, v in data.dict().items() if v is not None}

    result = await users_collection.update_one(
        {"_id": ObjectId(user_id)},
        {"$set": update_data}
    )

    if result.modified_count == 0:
        raise HTTPException(status_code=404, detail="User not found or no changes applied")

    updated_user = await users_collection.find_one({"_id": ObjectId(user_id)})
    updated_user["id"] = str(updated_user["_id"])
    del updated_user["_id"]

    return updated_user
