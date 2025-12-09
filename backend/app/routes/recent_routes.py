from fastapi import APIRouter, Depends
from app.controllers.recent_controller import (
    add_recent_song,
    get_recent_songs
)
from app.schemas.recent_schema import RecentCreateSchema
from app.middlewares.auth_middleware import get_current_user


router = APIRouter(prefix="/recent", tags=["Recent"])


# ----------------------------------------
# ADD RECENT SONG (WHEN USER PLAYS A SONG)
# ----------------------------------------
@router.post("/")
async def add_recent(
    data: RecentCreateSchema,
    current_user: dict = Depends(get_current_user)
):
    return await add_recent_song(current_user["id"], data.song_id)


# ----------------------------------------
# GET USER RECENT SONGS
# ----------------------------------------
@router.get("/")
async def fetch_recent_songs(current_user: dict = Depends(get_current_user)):
    return await get_recent_songs(current_user["id"])
