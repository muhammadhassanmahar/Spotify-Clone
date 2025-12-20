from fastapi import APIRouter, HTTPException
from bson import ObjectId

from app.database.collection import albums_collection, songs_collection
from app.controllers.song_controller import enrich_song

router = APIRouter(
    prefix="/albums",
    tags=["Albums"]
)

# -------------------------------------------------
# ✅ TEST ROUTE
# -------------------------------------------------
@router.get("/test")
async def test_album():
    return {"message": "Album route working!"}


# -------------------------------------------------
# 📀 GET ALL ALBUMS
# -------------------------------------------------
@router.get("")
async def get_all_albums():
    albums = []

    async for album in albums_collection.find():
        albums.append({
            "id": str(album["_id"]),
            "title": album.get("title", ""),
            "cover_image": album.get("cover_image", ""),
            "artist_id": str(album["artist_id"])
            if album.get("artist_id") else None,
            "year": album.get("year"),
        })

    return albums


# -------------------------------------------------
# 📀 GET SINGLE ALBUM + SONGS (🔥 FIXED)
# -------------------------------------------------
@router.get("/{album_id}")
async def get_album_with_songs(album_id: str):
    if not ObjectId.is_valid(album_id):
        raise HTTPException(status_code=400, detail="Invalid album id")

    album = await albums_collection.find_one(
        {"_id": ObjectId(album_id)}
    )

    if not album:
        raise HTTPException(status_code=404, detail="Album not found")

    # -------------------------
    # Album base
    # -------------------------
    response = {
        "id": str(album["_id"]),
        "title": album.get("title", ""),
        "cover_image": album.get("cover_image", ""),
        "artist_id": str(album["artist_id"])
        if album.get("artist_id") else None,
        "year": album.get("year"),
        "songs": [],
    }

    # -------------------------
    # Songs of album
    # -------------------------
    async for song in songs_collection.find(
        {"album_id": ObjectId(album_id)}
    ):
        response["songs"].append(
            await enrich_song(song)   # ✅ SAME FORMAT AS /songs
        )

    return response
