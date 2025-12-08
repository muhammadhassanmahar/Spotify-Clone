from fastapi import HTTPException
from bson import ObjectId

from app.database import genres_collection
from app.schemas.genre_schema import GenreCreateSchema, GenreUpdateSchema


# ----------------------------------------
# CREATE GENRE
# ----------------------------------------
async def create_genre(data: GenreCreateSchema):
    genre_dict = data.dict()
    result = await genres_collection.insert_one(genre_dict)

    new_genre = await genres_collection.find_one({"_id": result.inserted_id})
    new_genre["id"] = str(new_genre["_id"])
    del new_genre["_id"]

    return new_genre


# ----------------------------------------
# GET GENRE BY ID
# ----------------------------------------
async def get_genre_by_id(genre_id: str):
    genre = await genres_collection.find_one({"_id": ObjectId(genre_id)})
    if not genre:
        raise HTTPException(status_code=404, detail="Genre not found")

    genre["id"] = str(genre["_id"])
    del genre["_id"]

    return genre


# ----------------------------------------
# GET ALL GENRES
# ----------------------------------------
async def get_all_genres():
    genres = []
    async for g in genres_collection.find():
        g["id"] = str(g["_id"])
        del g["_id"]
        genres.append(g)

    return genres


# ----------------------------------------
# UPDATE GENRE
# ----------------------------------------
async def update_genre(genre_id: str, data: GenreUpdateSchema):
    update_data = {k: v for k, v in data.dict().items() if v is not None}

    result = await genres_collection.update_one(
        {"_id": ObjectId(genre_id)},
        {"$set": update_data}
    )

    if result.modified_count == 0:
        raise HTTPException(status_code=404, detail="Genre not found or no changes applied")

    updated_genre = await genres_collection.find_one({"_id": ObjectId(genre_id)})
    updated_genre["id"] = str(updated_genre["_id"])
    del updated_genre["_id"]

    return updated_genre


# ----------------------------------------
# DELETE GENRE
# ----------------------------------------
async def delete_genre(genre_id: str):
    result = await genres_collection.delete_one({"_id": ObjectId(genre_id)})
    if result.deleted_count == 0:
        raise HTTPException(status_code=404, detail="Genre not found")

    return {"message": "Genre deleted successfully"}
