from fastapi import APIRouter, Depends
from app.controllers.like_controller import (
    like_song,
    unlike_song,
    get_liked_songs
)
from app.middlewares.auth_middleware import get_current_user


router = APIRouter(prefix="/likes", tags=["Likes"])


# ----------------------------------------
# LIKE SONG
# ----------------------------------------
@router.post("/{song_id}")
async def like_song_route(
    song_id: str,
    current_user: dict = Depends(get_current_user)
):
    return await like_song(current_user["id"], song_id)


# ----------------------------------------
# UNLIKE SONG
# ----------------------------------------
@router.delete("/{song_id}")
async def unlike_song_route(
    song_id: str,
    current_user: dict = Depends(get_current_user)
):
    return await unlike_song(current_user["id"], song_id)


# ----------------------------------------
# GET ALL LIKED SONGS OF LOGGED-IN USER
# ----------------------------------------
@router.get("/")
async def fetch_liked_songs(current_user: dict = Depends(get_current_user)):
    return await get_liked_songs(current_user["id"])
