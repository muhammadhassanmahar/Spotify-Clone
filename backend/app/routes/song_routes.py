from fastapi import APIRouter
from app.controllers.song_controller import (
    create_song,
    get_song_by_id,
    get_all_songs,
    update_song,
    delete_song,
)
from app.schemas.song_schema import (
    SongCreateSchema,
    SongUpdateSchema
)

# -------------------------------------------------
# ROUTER
# -------------------------------------------------
router = APIRouter(
    prefix="/songs",
    tags=["Songs"]
)

# -------------------------------------------------
# 🎵 GET ALL SONGS
# URL: GET /songs
# -------------------------------------------------
@router.get("/")
async def fetch_all_songs():
    return await get_all_songs()


# -------------------------------------------------
# 🎵 GET SONG BY ID
# URL: GET /songs/{song_id}
# -------------------------------------------------
@router.get("/{song_id}")
async def fetch_song_by_id(song_id: str):
    return await get_song_by_id(song_id)


# -------------------------------------------------
# ➕ CREATE NEW SONG
# URL: POST /songs
# -------------------------------------------------
@router.post("/")
async def create_new_song(data: SongCreateSchema):
    return await create_song(data)


# -------------------------------------------------
# ✏️ UPDATE SONG
# URL: PUT /songs/{song_id}
# -------------------------------------------------
@router.put("/{song_id}")
async def modify_song(song_id: str, data: SongUpdateSchema):
    return await update_song(song_id, data)


# -------------------------------------------------
# 🗑️ DELETE SONG
# URL: DELETE /songs/{song_id}
# -------------------------------------------------
@router.delete("/{song_id}")
async def remove_song(song_id: str):
    return await delete_song(song_id)
