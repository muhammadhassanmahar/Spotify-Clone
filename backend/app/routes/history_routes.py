from fastapi import APIRouter, Depends
from app.controllers.history_controller import (
    add_to_history,
    get_user_history,
    remove_from_history
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
    return await add_to_history(current_user["id"], data.song_id)


# ----------------------------------------
# GET LOGGED-IN USER HISTORY
# ----------------------------------------
@router.get("/")
async def fetch_history(current_user: dict = Depends(get_current_user)):
    return await get_user_history(current_user["id"])


# ----------------------------------------
# CLEAR ONE HISTORY ITEM (DELETE BY ID)
# ----------------------------------------
@router.delete("/{history_id}")
async def clear_history(history_id: str, current_user: dict = Depends(get_current_user)):
    return await remove_from_history(history_id)
