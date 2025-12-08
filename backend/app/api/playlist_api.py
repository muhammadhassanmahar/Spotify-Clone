from fastapi import APIRouter, HTTPException, Depends
from app.schemas.playlist_schema import PlaylistCreateSchema, PlaylistUpdateSchema
from app.services.playlist_service import PlaylistService
from app.utils.oauth2 import get_current_user

router = APIRouter(prefix="/playlists", tags=["Playlists"])


# -------------------------------
# CREATE PLAYLIST
# -------------------------------
@router.post("/create")
async def create_playlist(payload: PlaylistCreateSchema, user=Depends(get_current_user)):
    data = payload.dict()
    data["user_id"] = user["_id"]

    playlist_id = await PlaylistService.create_playlist(data)
    if not playlist_id:
        raise HTTPException(status_code=400, detail="Playlist creation failed")

    return {"message": "Playlist created", "playlist_id": playlist_id}


# -------------------------------
# GET USER PLAYLISTS
# -------------------------------
@router.get("/my")
async def get_my_playlists(user=Depends(get_current_user)):
    playlists = await PlaylistService.get_user_playlists(user["_id"])
    return playlists


# -------------------------------
# GET PLAYLIST BY ID
# -------------------------------
@router.get("/{playlist_id}")
async def get_playlist(playlist_id: str):
    playlist = await PlaylistService.get_playlist_by_id(playlist_id)
    if not playlist:
        raise HTTPException(status_code=404, detail="Playlist not found")
    return playlist


# -------------------------------
# ADD SONG TO PLAYLIST
# -------------------------------
@router.post("/{playlist_id}/add/{song_id}")
async def add_song(playlist_id: str, song_id: str, user=Depends(get_current_user)):
    updated = await PlaylistService.add_song(playlist_id, song_id)

    if not updated:
        raise HTTPException(status_code=400, detail="Failed to add song")

    return {"message": "Song added to playlist"}


# -------------------------------
# REMOVE SONG FROM PLAYLIST
# -------------------------------
@router.delete("/{playlist_id}/remove/{song_id}")
async def remove_song(playlist_id: str, song_id: str, user=Depends(get_current_user)):
    updated = await PlaylistService.remove_song(playlist_id, song_id)

    if not updated:
        raise HTTPException(status_code=400, detail="Failed to remove song")

    return {"message": "Song removed from playlist"}


# -------------------------------
# UPDATE PLAYLIST
# -------------------------------
@router.put("/update/{playlist_id}")
async def update_playlist(playlist_id: str, payload: PlaylistUpdateSchema):
    updated = await PlaylistService.update_playlist(
        playlist_id, payload.dict(exclude_unset=True)
    )

    if not updated:
        raise HTTPException(status_code=400, detail="Update failed")

    return {"message": "Playlist updated successfully"}


# -------------------------------
# DELETE PLAYLIST
# -------------------------------
@router.delete("/delete/{playlist_id}")
async def delete_playlist(playlist_id: str):
    deleted = await PlaylistService.delete_playlist(playlist_id)
    if not deleted:
        raise HTTPException(status_code=400, detail="Delete failed")

    return {"message": "Playlist deleted"}
