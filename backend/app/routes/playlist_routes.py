from fastapi import APIRouter, Depends
from app.controllers.playlist_controller import (
    create_playlist,
    get_playlist_by_id,
    get_user_playlists,
    add_song_to_playlist,
    remove_song_from_playlist,
    update_playlist,
    delete_playlist
)
from app.schemas.playlist_schema import PlaylistCreateSchema, PlaylistUpdateSchema
from app.middlewares.auth_middleware import get_current_user


router = APIRouter(prefix="/playlists", tags=["Playlists"])


# ----------------------------------------
# CREATE NEW PLAYLIST (USER ONLY)
# ----------------------------------------
@router.post("/")
async def create_new_playlist(
    data: PlaylistCreateSchema,
    current_user: dict = Depends(get_current_user)
):
    return await create_playlist(data, current_user["id"])


# ----------------------------------------
# GET PLAYLIST BY ID
# ----------------------------------------
@router.get("/{playlist_id}")
async def fetch_playlist(playlist_id: str):
    return await get_playlist_by_id(playlist_id)


# ----------------------------------------
# GET ALL PLAYLISTS OF LOGGED-IN USER
# ----------------------------------------
@router.get("/")
async def fetch_my_playlists(current_user: dict = Depends(get_current_user)):
    return await get_user_playlists(current_user["id"])


# ----------------------------------------
# ADD SONG TO PLAYLIST
# ----------------------------------------
@router.post("/{playlist_id}/add-song/{song_id}")
async def add_song(playlist_id: str, song_id: str):
    return await add_song_to_playlist(playlist_id, song_id)


# ----------------------------------------
# REMOVE SONG FROM PLAYLIST
# ----------------------------------------
@router.delete("/{playlist_id}/remove-song/{song_id}")
async def remove_song(playlist_id: str, song_id: str):
    return await remove_song_from_playlist(playlist_id, song_id)


# ----------------------------------------
# UPDATE PLAYLIST
# ----------------------------------------
@router.put("/{playlist_id}")
async def update_playlist_route(playlist_id: str, data: PlaylistUpdateSchema):
    return await update_playlist(playlist_id, data)


# ----------------------------------------
# DELETE PLAYLIST
# ----------------------------------------
@router.delete("/{playlist_id}")
async def delete_playlist_route(playlist_id: str):
    return await delete_playlist(playlist_id)
