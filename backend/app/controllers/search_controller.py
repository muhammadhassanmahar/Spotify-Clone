from fastapi import HTTPException
from bson import ObjectId

from app.database.collection import (
    songs_collection,
    artists_collection,
    albums_collection,
)

# ----------------------------------------
# HELPER: CLEAN MONGO DOCUMENT
# ----------------------------------------
def serialize(doc):
    doc["id"] = str(doc["_id"])
    del doc["_id"]
    return doc


# ----------------------------------------
# SEARCH ALL (SONGS + ARTISTS + ALBUMS)
# ----------------------------------------
async def search_all(query: str):

    if not query or query.strip() == "":
        raise HTTPException(status_code=400, detail="Query cannot be empty")

    regex = {"$regex": query, "$options": "i"}

    songs = []
    async for song in songs_collection.find({"title": regex}).limit(20):
        song = serialize(song)

        # attach artist name
        if song.get("artist_id"):
            artist = await artists_collection.find_one(
                {"_id": ObjectId(song["artist_id"])}
            )
            song["artist_name"] = artist["name"] if artist else "Unknown Artist"

        songs.append(song)

    artists = []
    async for artist in artists_collection.find({"name": regex}).limit(20):
        artists.append(serialize(artist))

    albums = []
    async for album in albums_collection.find({"title": regex}).limit(20):
        albums.append(serialize(album))

    return {
        "songs": songs,
        "artists": artists,
        "albums": albums,
    }


# ----------------------------------------
# SEARCH SONGS ONLY (USED BY FLUTTER)
# ----------------------------------------
async def search_songs(query: str):

    if not query or query.strip() == "":
        raise HTTPException(status_code=400, detail="Query cannot be empty")

    regex = {"$regex": query, "$options": "i"}

    results = []

    async for song in songs_collection.find({"title": regex}).limit(30):
        song = serialize(song)

        # artist name
        if song.get("artist_id"):
            artist = await artists_collection.find_one(
                {"_id": ObjectId(song["artist_id"])}
            )
            song["artist_name"] = artist["name"] if artist else "Unknown Artist"

        results.append(song)

    return results


# ----------------------------------------
# SEARCH ARTISTS ONLY
# ----------------------------------------
async def search_artists(query: str):

    if not query or query.strip() == "":
        raise HTTPException(status_code=400, detail="Query cannot be empty")

    regex = {"$regex": query, "$options": "i"}

    artists = []
    async for artist in artists_collection.find({"name": regex}).limit(30):
        artists.append(serialize(artist))

    return artists


# ----------------------------------------
# SEARCH ALBUMS ONLY
# ----------------------------------------
async def search_albums(query: str):

    if not query or query.strip() == "":
        raise HTTPException(status_code=400, detail="Query cannot be empty")

    regex = {"$regex": query, "$options": "i"}

    albums = []
    async for album in albums_collection.find({"title": regex}).limit(30):
        albums.append(serialize(album))

    return albums
