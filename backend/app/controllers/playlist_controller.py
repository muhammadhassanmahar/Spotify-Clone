from fastapi import HTTPException
from bson import ObjectId

from app.database import playlists_collection, songs_collection
from app.schemas.playlist_schema import PlaylistCreateSchema, PlaylistUpdateSchema


# ----------------------------------------
# CREATE PLAYLIST
# ----------------------------------------
async def create_playlist(data: PlaylistCreateSchema, user_id: str):
    playlist_dict = data.dict()
    playlist_dict["user_id"] = user_id
    playlist_dict.setdefault("songs", [])

    result = await playlists_collection.insert_one(playlist_dict)

    new_playlist = await playlists_collection.find_one({"_id": result.inserted_id})
    new_playlist["id"] = str(new_playlist["_id"])
    del new_playlist["_id"]

    return new_playlist


# ----------------------------------------
# GET PLAYLIST BY ID
# ----------------------------------------
async def get_playlist_by_id(playlist_id: str):
    playlist = await playlists_collection.find_one({"_id": ObjectId(playlist_id)})
    if not playlist:
        raise HTTPException(status_code=404, detail="Playlist not found")

    playlist["id"] = str(playlist["_id"])
    del playlist["_id"]

    return playlist


# ----------------------------------------
# GET ALL USER PLAYLISTS
# ----------------------------------------
async def get_user_playlists(user_id: str):
    playlists = []

    async for pl in playlists_collection.find({"user_id": user_id}):
        pl["id"] = str(pl["_id"])
        del pl["_id"]
        playlists.append(pl)

    return playlists


# ----------------------------------------
# ADD SONG TO PLAYLIST
# ----------------------------------------
async def add_song_to_playlist(playlist_id: str, song_id: str):
    playlist = await playlists_collection.find_one({"_id": ObjectId(playlist_id)})
    if not playlist:
        raise HTTPException(status_code=404, detail="Playlist not found")

    song_exists = await songs_collection.find_one({"_id": ObjectId(song_id)})
    if not song_exists:
        raise HTTPException(status_code=404, detail="Song not found")

    await playlists_collection.update_one(
        {"_id": ObjectId(playlist_id)},
        {"$addToSet": {"songs": song_id}}
    )

    return {"message": "Song added to playlist"}


# ----------------------------------------
# REMOVE SONG FROM PLAYLIST
# ----------------------------------------
async def remove_song_from_playlist(playlist_id: str, song_id: str):
    result = await playlists_collection.update_one(
        {"_id": ObjectId(playlist_id)},
        {"$pull": {"songs": song_id}}
    )

    if result.modified_count == 0:
        raise HTTPException(status_code=404, detail="Playlist or song not found")

    return {"message": "Song removed from playlist"}


# ----------------------------------------
# UPDATE PLAYLIST
# ----------------------------------------
async def update_playlist(playlist_id: str, data: PlaylistUpdateSchema):
    update_data = {k: v for k, v in data.dict().items() if v is not None}

    result = await playlists_collection.update_one(
        {"_id": ObjectId(playlist_id)},
        {"$set": update_data}
    )

    if result.modified_count == 0:
        raise HTTPException(status_code=404, detail="Playlist not found or no changes made")

    updated_playlist = await playlists_collection.find_one({"_id": ObjectId(playlist_id)})
    updated_playlist["id"] = str(updated_playlist["_id"])
    del updated_playlist["_id"]

    return updated_playlist


# ----------------------------------------
# DELETE PLAYLIST  ← (NEWLY ADDED)
# ----------------------------------------
async def delete_playlist(playlist_id: str):
    result = await playlists_collection.delete_one({"_id": ObjectId(playlist_id)})

    if result.deleted_count == 0:
        raise HTTPException(status_code=404, detail="Playlist not found")

    return {"message": "Playlist deleted successfully"}
