from fastapi import APIRouter, Depends, HTTPException
from app.controllers.recent_controller import (
    add_recent_song,
    get_recent_songs
)
from app.schemas.recent_schema import RecentCreateSchema
from app.middlewares.auth_middleware import get_current_user


router = APIRouter(prefix="/recent", tags=["Recent"])


# ----------------------------------------------------
# ADD RECENT SONG (Automatically called when user plays)
# ----------------------------------------------------
@router.post("/")
async def add_recent(
    data: RecentCreateSchema,
    current_user: dict = Depends(get_current_user)
):
    user_id = current_user["id"]

    result = await add_recent_song(user_id, data.song_id)

    if result is None:
        raise HTTPException(status_code=400, detail="Failed to add recent song")

    return {"message": "Song added to recent list", "data": result}


# ----------------------------------------
# GET RECENT SONGS FOR LOGGED-IN USER
# ----------------------------------------
@router.get("/")
async def fetch_recent_songs(
    current_user: dict = Depends(get_current_user)
):
    user_id = current_user["id"]

    songs = await get_recent_songs(user_id)

    return {"recent_songs": songs}
