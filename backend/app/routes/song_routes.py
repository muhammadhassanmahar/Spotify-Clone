from fastapi import APIRouter
from app.controllers.song_controller import (
    create_song,
    get_song_by_id,
    get_all_songs,
    update_song,
    delete_song,
)
from app.schemas.song_schema import SongCreateSchema, SongUpdateSchema


router = APIRouter(prefix="/songs", tags=["Songs"])


# ----------------------------------------
# GET ALL SONGS  ✅ MUST BE FIRST
# ----------------------------------------
@router.get("/")
async def fetch_all_songs():
    return await get_all_songs()


# ----------------------------------------
# GET SONG BY ID
# ----------------------------------------
@router.get("/{song_id}")
async def get_song(song_id: str):
    return await get_song_by_id(song_id)


# ----------------------------------------
# CREATE NEW SONG
# ----------------------------------------
@router.post("/")
async def create_new_song(data: SongCreateSchema):
    return await create_song(data)


# ----------------------------------------
# UPDATE SONG
# ----------------------------------------
@router.put("/{song_id}")
async def modify_song(song_id: str, data: SongUpdateSchema):
    return await update_song(song_id, data)


# ----------------------------------------
# DELETE SONG
# ----------------------------------------
@router.delete("/{song_id}")
async def remove_song(song_id: str):
    return await delete_song(song_id)
