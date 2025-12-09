from fastapi import APIRouter
from app.controllers.search_controller import (
    search_all,
    search_songs,
    search_artists,
    search_albums
)

router = APIRouter(prefix="/search", tags=["Search"])


# ----------------------------------------
# SEARCH EVERYTHING (SONGS + ARTISTS + ALBUMS)
# ----------------------------------------
@router.get("/")
async def search_all_items(query: str):
    return await search_all(query)


# ----------------------------------------
# SEARCH SONGS ONLY
# ----------------------------------------
@router.get("/songs")
async def search_songs_route(query: str):
    return await search_songs(query)


# ----------------------------------------
# SEARCH ARTISTS ONLY
# ----------------------------------------
@router.get("/artists")
async def search_artists_route(query: str):
    return await search_artists(query)


# ----------------------------------------
# SEARCH ALBUMS ONLY
# ----------------------------------------
@router.get("/albums")
async def search_albums_route(query: str):
    return await search_albums(query)
