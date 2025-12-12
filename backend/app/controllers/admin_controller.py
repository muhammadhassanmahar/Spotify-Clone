from fastapi import HTTPException, UploadFile, File, Form
from bson import ObjectId
import uuid
import os

from app.database import (
    users_collection,
    songs_collection
)

UPLOAD_DIR = "uploads/songs"
os.makedirs(UPLOAD_DIR, exist_ok=True)


# ==========================================
# USERS: Get All Users (Admin)
# ==========================================
async def get_all_users():
    try:
        users = []
        async for user in users_collection.find():
            user["_id"] = str(user["_id"])
            users.append(user)

        return {
            "success": True,
            "total": len(users),
            "users": users
        }

    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))


# ==========================================
# USERS: Delete User
# ==========================================
async def delete_user(user_id: str):
    try:
        if not ObjectId.is_valid(user_id):
            raise HTTPException(status_code=400, detail="Invalid user ID")

        user = await users_collection.find_one({"_id": ObjectId(user_id)})
        if not user:
            raise HTTPException(status_code=404, detail="User not found")

        await users_collection.delete_one({"_id": ObjectId(user_id)})

        return {"success": True, "message": "User deleted successfully!"}

    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))


# ==========================================
# USERS: Promote User To Admin
# ==========================================
async def promote_to_admin(user_id: str):
    try:
        if not ObjectId.is_valid(user_id):
            raise HTTPException(status_code=400, detail="Invalid user ID")

        user = await users_collection.find_one({"_id": ObjectId(user_id)})
        if not user:
            raise HTTPException(status_code=404, detail="User not found")

        await users_collection.update_one(
            {"_id": ObjectId(user_id)},
            {"$set": {"role": "admin"}}
        )

        return {"success": True, "message": "User promoted to admin!"}

    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))


# ==========================================
# SONGS: Upload Song
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
        allowed_ext = ["mp3", "wav", "aac", "m4a"]
        ext = audio_file.filename.split(".")[-1].lower()

        if ext not in allowed_ext:
            raise HTTPException(status_code=400, detail="Invalid audio format")

        unique_name = f"{uuid.uuid4()}.{ext}"
        file_path = os.path.join(UPLOAD_DIR, unique_name)

        file_data = await audio_file.read()
        with open(file_path, "wb") as f:
            f.write(file_data)

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
# SONGS: Get All Songs
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
# SONGS: Delete Song
# ==========================================
async def delete_song(song_id: str):
    try:
        if not ObjectId.is_valid(song_id):
            raise HTTPException(status_code=400, detail="Invalid song ID")

        song = await songs_collection.find_one({"_id": ObjectId(song_id)})
        if not song:
            raise HTTPException(status_code=404, detail="Song not found")

        await songs_collection.delete_one({"_id": ObjectId(song_id)})

        file_path = f"uploads/songs/{song['file_url'].split('/')[-1]}"
        if os.path.exists(file_path):
            os.remove(file_path)

        return {"success": True, "message": "Song deleted successfully!"}

    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))
