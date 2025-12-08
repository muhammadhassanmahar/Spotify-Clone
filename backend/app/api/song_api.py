from fastapi import APIRouter, HTTPException, Depends
from app.schemas.song_schema import SongCreateSchema, SongUpdateSchema
from app.services.song_service import SongService
from app.utils.oauth2 import get_current_user

router = APIRouter(prefix="/songs", tags=["Songs"])


# -------------------------------
# ADD NEW SONG  (Admin / Artist)
# -------------------------------
@router.post("/create")
async def create_song(payload: SongCreateSchema, user=Depends(get_current_user)):

    result = await SongService.create_song(payload.dict())

    if not result:
        raise HTTPException(status_code=400, detail="Song creation failed")

    return {"message": "Song created successfully", "song_id": result}


# -------------------------------
# GET SONG BY ID
# -------------------------------
@router.get("/{song_id}")
async def get_song(song_id: str):
    song = await SongService.get_song_by_id(song_id)
    if not song:
        raise HTTPException(status_code=404, detail="Song not found")
    return song


# -------------------------------
# SEARCH SONGS
# -------------------------------
@router.get("/search/{keyword}")
async def search_songs(keyword: str):
    results = await SongService.search(keyword)
    return results


# -------------------------------
# GET SONGS BY ARTIST
# -------------------------------
@router.get("/artist/{artist_id}")
async def get_songs_by_artist(artist_id: str):
    results = await SongService.get_by_artist(artist_id)
    return results


# -------------------------------
# GET SONGS BY ALBUM
# -------------------------------
@router.get("/album/{album_id}")
async def get_songs_by_album(album_id: str):
    results = await SongService.get_by_album(album_id)
    return results


# -------------------------------
# INCREMENT PLAY COUNT
# -------------------------------
@router.post("/{song_id}/play")
async def play_song(song_id: str, user=Depends(get_current_user)):
    updated = await SongService.increment_play(song_id)
    if not updated:
        raise HTTPException(status_code=400, detail="Unable to count play")
    return {"message": "Play counted"}


# -------------------------------
# UPDATE SONG
# -------------------------------
@router.put("/update/{song_id}")
async def update_song(song_id: str, payload: SongUpdateSchema):
    updated = await SongService.update_song(song_id, payload.dict(exclude_unset=True))
    if not updated:
        raise HTTPException(status_code=400, detail="Update failed")
    return {"message": "Song updated successfully"}


# -------------------------------
# DELETE SONG
# -------------------------------
@router.delete("/delete/{song_id}")
async def delete_song(song_id: str):
    deleted = await SongService.delete_song(song_id)
    if not deleted:
        raise HTTPException(status_code=400, detail="Song deletion failed")
    return {"message": "Song deleted successfully"}
