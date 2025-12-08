from fastapi import APIRouter, HTTPException, Depends
from app.services.liked_songs_service import LikedSongsService
from app.utils.oauth2 import get_current_user

router = APIRouter(prefix="/liked", tags=["Liked Songs"])


# ----------------------------------------
# GET USER'S LIKED SONGS
# ----------------------------------------
@router.get("/my")
async def get_liked_songs(user=Depends(get_current_user)):
    liked = await LikedSongsService.get_user_liked(user["_id"])
    return liked


# ----------------------------------------
# LIKE A SONG
# ----------------------------------------
@router.post("/add/{song_id}")
async def like_song(song_id: str, user=Depends(get_current_user)):
    updated = await LikedSongsService.like_song(user["_id"], song_id)

    if not updated:
        raise HTTPException(status_code=400, detail="Failed to like song")

    return {"message": "Song added to liked list"}


# ----------------------------------------
# UNLIKE A SONG
# ----------------------------------------
@router.delete("/remove/{song_id}")
async def unlike_song(song_id: str, user=Depends(get_current_user)):
    updated = await LikedSongsService.unlike_song(user["_id"], song_id)

    if not updated:
        raise HTTPException(status_code=400, detail="Failed to remove liked song")

    return {"message": "Song removed from liked list"}


# ----------------------------------------
# DELETE USER'S LIKED LIST
# ----------------------------------------
@router.delete("/delete-my-list")
async def delete_liked_list(user=Depends(get_current_user)):
    deleted = await LikedSongsService.delete_user_liked(user["_id"])

    if not deleted:
        raise HTTPException(status_code=400, detail="Failed to delete liked songs list")

    return {"message": "Liked songs list deleted"}
