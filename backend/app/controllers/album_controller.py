from fastapi import HTTPException
from bson import ObjectId

from app.database import albums_collection, artists_collection
from app.schemas.album_schema import AlbumCreateSchema, AlbumUpdateSchema


# ----------------------------------------
# CREATE ALBUM
# ----------------------------------------
async def create_album(data: AlbumCreateSchema):
    # Check if artist exists
    artist = await artists_collection.find_one({"_id": ObjectId(data.artist_id)})
    if not artist:
        raise HTTPException(status_code=404, detail="Artist not found")

    album_dict = data.dict()
    result = await albums_collection.insert_one(album_dict)

    new_album = await albums_collection.find_one({"_id": result.inserted_id})
    new_album["id"] = str(new_album["_id"])
    del new_album["_id"]

    return new_album


# ----------------------------------------
# GET ALBUM BY ID
# ----------------------------------------
async def get_album_by_id(album_id: str):
    album = await albums_collection.find_one({"_id": ObjectId(album_id)})
    if not album:
        raise HTTPException(status_code=404, detail="Album not found")

    album["id"] = str(album["_id"])
    del album["_id"]

    return album


# ----------------------------------------
# GET ALL ALBUMS
# ----------------------------------------
async def get_all_albums():
    albums = []
    async for a in albums_collection.find():
        a["id"] = str(a["_id"])
        del a["_id"]
        albums.append(a)

    return albums


# ----------------------------------------
# UPDATE ALBUM
# ----------------------------------------
async def update_album(album_id: str, data: AlbumUpdateSchema):
    update_data = {k: v for k, v in data.dict().items() if v is not None}

    result = await albums_collection.update_one(
        {"_id": ObjectId(album_id)},
        {"$set": update_data}
    )

    if result.modified_count == 0:
        raise HTTPException(status_code=404, detail="Album not found or no changes applied")

    updated_album = await albums_collection.find_one({"_id": ObjectId(album_id)})
    updated_album["id"] = str(updated_album["_id"])
    del updated_album["_id"]

    return updated_album


# ----------------------------------------
# DELETE ALBUM
# ----------------------------------------
async def delete_album(album_id: str):
    result = await albums_collection.delete_one({"_id": ObjectId(album_id)})
    if result.deleted_count == 0:
        raise HTTPException(status_code=404, detail="Album not found")

    return {"message": "Album deleted successfully"}
