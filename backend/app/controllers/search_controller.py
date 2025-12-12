from fastapi import HTTPException
from bson import ObjectId

from app.database.collection import (
    songs_collection,
    artists_collection,
    albums_collection,
    playlists_collection,
    genres_collection,
    users_collection,
    history_collection,
    liked_songs_collection,
    recent_collection,
    likes_collection
)


# ----------------------------------------
# SEARCH ALL (SONGS + ARTISTS + ALBUMS)
# ----------------------------------------
async def search_all(query: str):

    if not query or query.strip() == "":
        raise HTTPException(status_code=400, detail="Query cannot be empty")

    search_filter = {"$regex": query, "$options": "i"}

    songs = await songs_collection.find({"title": search_filter}).to_list(20)
    artists = await artists_collection.find({"name": search_filter}).to_list(20)
    albums = await albums_collection.find({"title": search_filter}).to_list(20)

    return {
        "songs": songs,
        "artists": artists,
        "albums": albums
    }


# ----------------------------------------
# SEARCH SONGS ONLY
# ----------------------------------------
async def search_songs(query: str):

    if not query or query.strip() == "":
        raise HTTPException(status_code=400, detail="Query cannot be empty")

    search_filter = {"title": {"$regex": query, "$options": "i"}}

    songs = await songs_collection.find(search_filter).to_list(30)
    return songs


# ----------------------------------------
# SEARCH ARTISTS ONLY
# ----------------------------------------
async def search_artists(query: str):

    if not query or query.strip() == "":
        raise HTTPException(status_code=400, detail="Query cannot be empty")

    search_filter = {"name": {"$regex": query, "$options": "i"}}

    artists = await artists_collection.find(search_filter).to_list(30)
    return artists


# ----------------------------------------
# SEARCH ALBUMS ONLY
# ----------------------------------------
async def search_albums(query: str):

    if not query or query.strip() == "":
        raise HTTPException(status_code=400, detail="Query cannot be empty")

    search_filter = {"title": {"$regex": query, "$options": "i"}}

    albums = await albums_collection.find(search_filter).to_list(30)
    return albums
