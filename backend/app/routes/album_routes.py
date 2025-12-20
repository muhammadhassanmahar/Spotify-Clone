from fastapi import APIRouter, HTTPException
from bson import ObjectId
from app.database.collection import albums_collection, songs_collection

router = APIRouter(prefix="/albums", tags=["Albums"])


# -------------------------------------------------
# ✅ TEST ROUTE
# -------------------------------------------------
@router.get("/test")
def test_album():
    return {"message": "Album route working!"}


# -------------------------------------------------
# 📀 GET ALL ALBUMS
# -------------------------------------------------
@router.get("/")
async def get_all_albums():
    albums = []

    async for album in albums_collection.find():
        album["_id"] = str(album["_id"])
        albums.append(album)

    return albums


# -------------------------------------------------
# 📀 GET SINGLE ALBUM + SONGS
# -------------------------------------------------
@router.get("/{album_id}")
async def get_album_with_songs(album_id: str):
    try:
        album = await albums_collection.find_one(
            {"_id": ObjectId(album_id)}
        )
        if not album:
            raise HTTPException(status_code=404, detail="Album not found")

        album["_id"] = str(album["_id"])

        songs = []
        async for song in songs_collection.find(
            {"album_id": ObjectId(album_id)}
        ):
            song["_id"] = str(song["_id"])
            song["album_id"] = str(song["album_id"])
            songs.append(song)

        album["songs"] = songs

        return album

    except Exception:
        raise HTTPException(status_code=400, detail="Invalid album id")
