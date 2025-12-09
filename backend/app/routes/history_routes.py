from fastapi import APIRouter, Depends
from app.controllers.history_controller import (
    add_history_entry,
    get_user_history,
    clear_user_history
)
from app.schemas.history_schema import HistoryCreateSchema
from app.middlewares.auth_middleware import get_current_user


router = APIRouter(prefix="/history", tags=["History"])


# ----------------------------------------
# ADD HISTORY ENTRY (WHEN USER PLAYS A SONG)
# ----------------------------------------
@router.post("/")
async def add_history(
    data: HistoryCreateSchema,
    current_user: dict = Depends(get_current_user)
):
    return await add_history_entry(current_user["id"], data.song_id)


# ----------------------------------------
# GET LOGGED-IN USER HISTORY
# ----------------------------------------
@router.get("/")
async def fetch_history(current_user: dict = Depends(get_current_user)):
    return await get_user_history(current_user["id"])


# ----------------------------------------
# CLEAR HISTORY
# ----------------------------------------
@router.delete("/")
async def clear_history(current_user: dict = Depends(get_current_user)):
    return await clear_user_history(current_user["id"])
