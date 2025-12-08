from fastapi import APIRouter, HTTPException, Depends
from app.services.history_service import HistoryService
from app.utils.oauth2 import get_current_user

router = APIRouter(prefix="/history", tags=["History"])


# ----------------------------------------
# ADD SONG TO USER LISTEN HISTORY
# ----------------------------------------
@router.post("/add/{song_id}")
async def add_to_history(song_id: str, user=Depends(get_current_user)):
    entry_id = await HistoryService.add_entry(user["_id"], song_id)

    if not entry_id:
        raise HTTPException(status_code=400, detail="Failed to add to history")

    return {"message": "History updated", "entry_id": entry_id}


# ----------------------------------------
# GET USER LISTEN HISTORY
# ----------------------------------------
@router.get("/my")
async def get_my_history(user=Depends(get_current_user)):
    history = await HistoryService.get_user_history(user["_id"])
    return history


# ----------------------------------------
# CLEAR USER LISTEN HISTORY
# ----------------------------------------
@router.delete("/clear")
async def clear_history(user=Depends(get_current_user)):
    deleted = await HistoryService.clear_history(user["_id"])

    if not deleted:
        raise HTTPException(status_code=400, detail="Failed to clear history")

    return {"message": "History cleared"}


# ----------------------------------------
# DELETE SPECIFIC HISTORY ENTRY
# ----------------------------------------
@router.delete("/delete/{entry_id}")
async def delete_entry(entry_id: str, user=Depends(get_current_user)):
    deleted = await HistoryService.delete_entry(entry_id)

    if not deleted:
        raise HTTPException(status_code=400, detail="Failed to delete entry")

    return {"message": "History entry deleted"}
