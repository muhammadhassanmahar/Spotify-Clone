from fastapi import HTTPException
from bson import ObjectId

from app.database import artists_collection
from app.schemas.artist_schema import ArtistCreateSchema, ArtistUpdateSchema


# ----------------------------------------
# CREATE ARTIST
# ----------------------------------------
async def create_artist(data: ArtistCreateSchema):
    artist_dict = data.dict()
    result = await artists_collection.insert_one(artist_dict)

    new_artist = await artists_collection.find_one({"_id": result.inserted_id})
    new_artist["id"] = str(new_artist["_id"])
    del new_artist["_id"]

    return new_artist


# ----------------------------------------
# GET ARTIST BY ID
# ----------------------------------------
async def get_artist_by_id(artist_id: str):
    artist = await artists_collection.find_one({"_id": ObjectId(artist_id)})
    if not artist:
        raise HTTPException(status_code=404, detail="Artist not found")

    artist["id"] = str(artist["_id"])
    del artist["_id"]

    return artist


# ----------------------------------------
# GET ALL ARTISTS
# ----------------------------------------
async def get_all_artists():
    artists = []
    async for a in artists_collection.find():
        a["id"] = str(a["_id"])
        del a["_id"]
        artists.append(a)

    return artists


# ----------------------------------------
# UPDATE ARTIST
# ----------------------------------------
async def update_artist(artist_id: str, data: ArtistUpdateSchema):
    update_data = {k: v for k, v in data.dict().items() if v is not None}

    result = await artists_collection.update_one(
        {"_id": ObjectId(artist_id)},
        {"$set": update_data}
    )

    if result.modified_count == 0:
        raise HTTPException(status_code=404, detail="Artist not found or no changes applied")

    updated_artist = await artists_collection.f
