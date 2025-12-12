from fastapi import HTTPException, UploadFile, File, Form
from app.database import songs_collection
from bson import ObjectId
import uuid
import os

UPLOAD_DIR = "uploads/songs"
os.makedirs(UPLOAD_DIR, exist_ok=True)

# ==========================================
# Admin: Upload Song
# ==========================================
async def upload_song(
    title: str = Form(...),
    artist: str = Form(...),
    album: str = Form(None),
    genre: str = Form(None),
    duration: str = Form(None),
    audio_file: UploadFile = File(...)
):
    try:
        # Validate audio file
        allowed_ext = ["mp3", "wav", "aac", "m4a"]
        ext = audio_file.filename.split(".")[-1].lower()

        if ext not in allowed_ext:
            raise HTTPException(status_code=400, detail="Invalid audio format")

        # Generate unique filename
        unique_name = f"{uuid.uuid4()}.{ext}"
        file_path = os.path.join(UPLOAD_DIR, unique_name)

        # Save file
        file_data = await audio_file.read()
        with open(file_path, "wb") as f:
            f.write(file_data)

        # Song data for DB
        song_data = {
            "title": title,
            "artist": artist,
            "album": album,
            "genre": genre,
            "duration": duration,
            "file_url": f"/songs/{unique_name}"
        }

        result = await songs_collection.insert_one(song_data)
        song_data["_id"] = str(result.inserted_id)

        return {
            "success": True,
            "message": "Song uploaded successfully!",
            "song": song_data
        }

    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))


# ==========================================
# Admin: Get All Songs
# ==========================================
async def get_all_songs():
    try:
        songs = []
        async for song in songs_collection.find():
            song["_id"] = str(song["_id"])
            songs.append(song)

        return {
            "success": True,
            "total": len(songs),
            "songs": songs
        }

    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))


# ==========================================
# Admin: Delete Song
# ==========================================
async def delete_song(song_id: str):
    try:
        if not ObjectId.is_valid(song_id):
            raise HTTPException(status_code=400, detail="Invalid song ID")

        # Find the song before deleting
        song = await songs_collection.find_one({"_id": ObjectId(song_id)})
        if not song:
            raise HTTPException(status_code=404, detail="Song not found")

        # Delete from DB
        result = await songs_collection.delete_one({"_id": ObjectId(song_id)})

        # Delete audio file from folder
        file_path = f"uploads/songs/{song['file_url'].split('/')[-1]}"
        if os.path.exists(file_path):
            os.remove(file_path)

        return {"success": True, "message": "Song deleted successfully!"}

    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))
